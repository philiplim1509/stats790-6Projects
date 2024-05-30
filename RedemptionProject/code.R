# Import all the nessary libraries
library(tidyverse)
library(dplyr)
library(jsonlite)
library(magick)
library(kableExtra)

# Load the data
memes <- data.frame(read.csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQll5ONs_D5XyKMbfrNEFQRwy05VjHZ9qdVeA-wcRJZYrwq5_N4NsdJkHKhozOe3ns3xAscLzoO3zR6/pub?gid=0&single=true&output=csv"))
    # view(memes)

# Getting the URL while ignoring the NA values
thumbnail <- memes$URL %>% na.omit()

# Creating the GIF
image_read(thumbnail) %>%
  image_join() %>%
  image_scale(700) %>%
  image_animate(fps = 1) %>%
  image_write("thumbnail.gif")

# Mutate the memes into popular and not popular based on if the memes excees the mean Captions
memes <- memes %>%
    mutate(popular = ifelse(Captions >= mean(Captions),
        "Popular",
        "Not Popular"
    ))

# Filter the popular memes and arrange them in descending order
popular <- memes %>%
    filter(popular == "Popular") %>%
    arrange(desc(Captions))

# Display the top 10 popular memes
top_popular_memes <- head(popular, 10)

# Display the top 10 popular memes in a table using a new libary called kableExtra
# top_popular_memes %>%
#     select(Name, URL, Captions) %>%
#     mutate(Preview = paste0('<img src="', URL, '" width="100" />')) %>%
#     select(Name, Preview, Captions) %>%
#     kable(escape = FALSE, format = "html", col.names = c("Meme Name", "Preview", "Captions")) %>%
#     kable_styling(full_width = FALSE, position = "center")
# top_popular_memes

top_popular_memes %>%
  select(Name, URL, Captions) %>%
  mutate(Preview = paste0('<img src="', URL, '" width="100" />')) %>%
  select(Name, Preview, Captions) %>%
  knitr::kable(escape = FALSE, format = "html", col.names = c("Meme Name", "Preview", "Captions")) %>%
  kable_styling(full_width = FALSE, position = "center")
