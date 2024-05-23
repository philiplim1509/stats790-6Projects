headlines_data <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vSzM_3hRnNKMfAv3-bn_yF833sqB7AWrMVEGs2dRKJ77myE7oHX2VKDlKWg6NmiVZ5Cj5Y5gFY4KSo1/pub?gid=0&single=true&output=csv") %>%
  slice(305 : 455)

#1
headlines_data$headline[22]

view(headlines_data)

#2
library(stringr)

headline_words1 <- str_squish(headlines_data$headline[143]) %>%
  str_split(" ") %>%
  unlist()

headline_words1[10]

#3
headline_words2 <- str_squish(headlines_data$headline[124]) %>%
  str_split(" ") %>%
  unlist()

headline_words2 %>% length

#4 
all_words <- union(headline_words1, headline_words2)
all_words %>% length

same_words <- intersect(headline_words1, headline_words2)
same_words

#5
get_similarity <- function(phrase1, phrase2){
  
  words1 <- phrase1 %>% str_squish() %>% str_split(" ") %>% unlist()
  words2 <- phrase2 %>% str_squish() %>% str_split(" ") %>% unlist()
  
  num_same <- intersect(words1, words2) %>% length()
  num_total <- union(words1, words2) %>% length()
  
  num_same / num_total # remember last thing created is returned by default, or use return()
}

phrase1_m <- headlines_data$headline[102]
phrase2_m <- headlines_data$headline[37]

round(get_similarity(phrase1_m, phrase2_m),1)


compare_headlines <- tibble(headline1 = headlines_data$headline[1:75], headline2 = headlines_data$headline[76:150])
#6
similarity_data <- compare_headlines %>%
  rowwise() %>%
  mutate(similarity_score = get_similarity(headline1, headline2)) %>%
  ungroup()

similarity_data$similarity_score[10]


max_similarity <- max(similarity_data$similarity_score)

round(max_similarity,1)



mean_similarity <- mean(similarity_data$similarity_score)

rounded_mean <- round(mean_similarity, 1)
rounded_mean
