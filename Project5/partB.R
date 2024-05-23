library(tidyverse)
library(dplyr)
library(jsonlite)
library(magick)
library(rvest)

# Hon Erica Stanford

url <- "https://www.beehive.govt.nz/minister/hon-erica-stanford"

pages <- read_html(url) %>%
    html_elements(".release__wrapper") %>%
    html_elements("h2") %>%
    html_elements("a") %>%
    html_attr("href") %>%
    paste0("https://www.beehive.govt.nz", .)


get_release <- function(page_url){
  Sys.sleep(2)
  # print the page_url so if things go wrong
  # we can see which page caused issues
  print(page_url)
  page <- read_html(page_url)
  
  # add code to scrape the release title and release content
  release_title <- page %>%
    html_nodes("h1.article__title") %>%
    html_text() %>%
    str_trim()
  release_content <- page %>%
    html_nodes(".prose.field.field--name-body.field--type-text-with-summary.field--label-hidden.field--item") %>%
    html_text()
  
  # add code to return a tibble created using these data objects
  tibble(title = release_title, content = release_content)
}

release_data <- map_df(pages, get_release)

# Calculate the total number of words in all release contents
total_words <- str_count(release_data$content, "\\w+") %>% sum()

# Calculate the average number of words per release
mean_words_per_release <- mean(str_count(release_data$content, "\\w+"))

# Find the most common word in release titles
title_words <- str_split(release_data$title, "\\W+") %>% unlist() %>% tolower()
most_common_title_word <- names(sort(table(title_words), decreasing = TRUE))[1]
most_common_title_word

#Count title words
title_word_counts <- table(title_words) %>%
sort(decreasing = TRUE)
title_word_counts

# Find the most common word in release contents
content_words <- str_split(release_data$content, "\\W+") %>% unlist() %>% tolower()
most_common_content_word <- names(sort(table(content_words), decreasing = TRUE))[1]

#Count content words
content_word_counts <- table(content_words) %>%
  sort(decreasing = TRUE)

