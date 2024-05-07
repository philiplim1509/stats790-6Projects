library(tidyverse)
library(dplyr)
library(jsonlite)
library(magick)

youtube_data <- data.frame(read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vRAk1VTiPEDf6H_bk442dTuh3CTLgjyd7HDgh-QhlkyWs-onXy8_ZnOp2i_BxgM0hIYx_gTB-rfw4fT/pub?output=csv"))

view(youtube_data)

youtube_data <- youtube_data %>%
    mutate(
        yearReleased = datePublished %>% str_sub(1, 4) %>% parse_number()
    )

viewCountsPerYear <- youtube_data %>%
    group_by(yearReleased, channelName) %>%
    summarise(totalViewCount = sum(viewCount))

view(viewCountsPerYear)

# Alternative chart 1

# viewCountsPerYear %>%
#     ggplot(aes(x = yearReleased, y = totalViewCount, color = "green")) +
#     geom_line() +
#     labs(x = "Year Released", y = "View Count", title = "View Counts Over the Years") +
#     theme_minimal() +
#     scale_y_continuous(labels = scales::comma) +
#     facet_wrap(vars(channelName))


# Line plot 1 (Compare the ChannelName total viewCount by the year)
viewCountsPerYear %>%
    ggplot(aes(x = yearReleased, y = totalViewCount, color = channelName)) +
    geom_line(size = 2) +
    labs(x = "Year Released", y = "View Count", title = "View Counts Over the Years") +
    theme_bw() +
    scale_y_continuous(labels = scales::comma) +
    scale_x_continuous(breaks = seq(2012, 2024, 2))
ggsave("plot1.png")


videoPerYear <- youtube_data %>%
    mutate(yearReleased = datePublished %>% str_sub(1, 4) %>% parse_number()) %>%
    group_by(channelName, yearReleased) %>%
    summarise(totVideos = n())
view(videoPerYear)

# Bar chart 2 (Total number of videos by the year)
videoPerYear %>%
    ggplot() +
    geom_bar(
        aes(
            x = yearReleased,
            y = totVideos,
            fill = channelName
        ),
        stat = "identity",
        position = "dodge"
    ) +
    theme_bw() +
   labs(x = "Year Released", y = "Total Video", title = "Total Videos Over the Years")
    scale_x_continuous(breaks = seq(2012, 2024, 2))

ggsave("plot2.png")

# Bar Chart 3 (Comparison of total popular video respective to their channel)

# Finding the Mean for view count, like count, comment count (L = @LEMMiNO, R = @Rousseau)
LMean <- youtube_data %>%
    filter(channelName == "@LEMMiNO") %>%
    summarise(viewCount = mean(viewCount), likeCount = mean(likeCount), commentCount = mean(commentCount))
# LMean

RMean <- youtube_data %>%
    filter(channelName == "@Rousseau") %>%
    summarise(viewCount = mean(viewCount), likeCount = mean(likeCount), commentCount = mean(commentCount))

# Requirement for a video to be popular (3 variables need to above the mean respective to their channel name)

# @LEMMiNO popolar grouping
Lpopular <- youtube_data %>%
    filter(channelName == "@LEMMiNO") %>%
    mutate(
        popular = ifelse(viewCount >= LMean$viewCount | likeCount >= LMean$likeCount | commentCount >= LMean$commentCount,
            "Popular", "Not Popular"
        )
    )

# @Rosseau popolar grouping
Rpopular <- youtube_data %>%
    filter(channelName == "@Rousseau") %>%
    mutate(
        popular = ifelse(viewCount >= RMean$viewCount | likeCount >= RMean$likeCount | commentCount >= RMean$commentCount,
            "Popular", "Not Popular"
        )
    )

# Combined the datasets
popularData <- bind_rows(Lpopular, Rpopular)

popularData <- popularData %>%
    group_by(channelName) %>%
    summarise(popular_count = sum(popular == "Popular", na.rm = TRUE))
view(popularData)

# Label
label <- c("44 out of 100 videos are popular", "34 out of 100 vides are popular")

ggplot(popularData, aes(x = channelName, y = popular_count, fill = channelName)) +
    geom_bar(stat = "identity") +
    labs(x = "Channel Name", y = "Popular Count", title = "Popular Count by Channel") +
    geom_text(aes(label = label), position = "stack", vjust = -0.5, size = 3) +
    theme_bw()
ggsave("plot3.png")



# Bar plot 4 (Count the word occurance in the title column)
title_word_counts <- youtube_data %>%
    select(title) %>%
    separate_rows(title, sep = " ") %>%
    mutate(clean_word = str_to_lower(title) %>%
        str_remove_all("[[:punct:]]")) %>%
    filter(
        !clean_word == ""
    ) %>%
    group_by(clean_word) %>%
    summarise(n = n()) %>%
    arrange(desc(n)) %>%
    slice(1:10) %>%
    ungroup()

title_word_counts %>%
    ggplot(aes(
        x = reorder(clean_word, n),
        y = n
    )) +
    geom_col(fill = "blue") +
    geom_text(aes(label = clean_word),
        colour = "blue",
        size = 8,
        position = position_nudge(y = 1.5)
    ) +
    geom_text(aes(label = n),
        position = position_nudge(y = -1),
        colour = "white",
        size = 6
    ) +
    labs(
        x = "word",
        y = "number of songs"
    ) +
    theme_void()
ggsave(("plot4.png"))


ggplot(youtube_data, aes(x = yearReleased)) +
    geom_line(aes(y = viewCount, color = "Views")) +
    geom_line(aes(y = likeCount, color = "Likes")) +
    geom_line(aes(y = commentCount, color = "Comments")) +
    labs(x = "Date", y = "Count", color = "Metric", title = "Number of Views, Likes, and Comments Over Time") +
    scale_color_manual(values = c("Views" = "blue", "Likes" = "green", "Comments" = "red")) +
    scale_y_continuous(labels = scales::comma) +
    scale_x_continuous(breaks = seq(2012, 2024, 2)) +
    theme_minimal()
ggsave(("fail_chart.png"))
