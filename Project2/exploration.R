library(tidyverse)
library(dplyr)

#Reads the data frame and assign a variable name to each columns
learning_data <- data.frame(read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vSI6cLoMaiWKH9pocOkC40BlUYBPz2V-UDtZ1Evz-qG0UOVd5ML_ZGBEDz7L3-zkxa8fSPf2KyY57mB/pub?gid=1662325778&single=true&output=csv") %>%
    rename(
        age = 2,
        gender = 3,
        frequent_social = 4,
        hour_social = 5,
        effect_social = 6,
        emotion_social = 7,
        sleep = 8
    )
)


names(learning_data)

# Static summary value 1 - the mean of the user's age
mean(learning_data[["age"]])

# Static summary value 2 - the highest age median of the gender group
all_median = learning_data %>% 
  group_by(gender) %>%
  summarise(median_age = median(age))
all_median["median_age"]

# box_plot - creating a box plot to indicate the user ages' quantile, mean, median for each gender
box_plot = learning_data %>% 
  ggplot() + 
  geom_boxplot(aes(x = age, y = gender, fill = gender), alpha = 0.8) + 
  scale_fill_brewer(palette = "BuPu") + 
  scale_color_brewer(palette = "BuPu") +
  stat_summary(fun = "mean", geom = "point", mapping = aes(x = age, y = gender), shape = 2, size = 3, color = "blue") +
  theme_bw()
box_plot

# box_plot1 - creating a box plot to indicate the overall user ages' quantile, mean, median 
box_plot1 = learning_data %>% 
  ggplot() +
  geom_boxplot(aes(x = age, y = 0), alpha = 0.8, fill = "gray", width = 0.5) +
  stat_summary(fun = "mean", geom = "point", mapping = aes(x = age, y = gender), shape = 2, size = 3, color = "blue") +
  theme_bw()
box_plot1

# bar plot - creating a bar plot to indicate the each gender's social media effect on their sleep
bar_plot1 = learning_data %>% ggplot(aes(x = sleep, y = gender, fill = effect_social)) + geom_bar(position = "dodge", stat = "identity") + theme_bw()
bar_plot1

# below variable holds the dataframe that is group by social media effect (effect_social) and their emotion due to social media (emotion social), and calculate the percentage of each levels in emotion social's number of occurrence
percentage_data = learning_data %>%
  group_by(effect_social, emotion_social) %>%
  summarise(count = n()) %>%
  group_by(effect_social) %>%
  mutate(percentage = count / sum(count) * 100)

# below variable holds the dadtaframe that is group by effect_social and sum each effect_social's level 
sum_count = percentage_data %>%
  group_by(effect_social) %>%
  summarise(summation = sum(count))
sum_count

# Below vectorised variable assigns each emotion level with appropriate colour 
colour = c(Anxious="#d6b4fc", Depressed="#d4d4d4", Excited="yellow", Frustrated="#ff6242", "I am not sure"="pink", Relax="lightblue")

# bar_plot2 - creating a stacked bar plot to indicate the each sleep impact by social media, in percentage 
bar_plot2 = ggplot(percentage_data, aes(x = effect_social, y = percentage, fill = emotion_social)) + geom_bar(stat = "identity") + scale_fill_manual(values=colour) + theme_bw()
bar_plot2
