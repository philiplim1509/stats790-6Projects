library(tidyverse)
library(dplyr)
library(jsonlite)
library(magick)
json_data <- fromJSON("pixabay_data.json")
pixabay_photo_data <- json_data$hits

# Variable 1
selected_photos <- pixabay_photo_data %>%
    mutate(tags_types = ifelse(str_detect(
        str_to_lower(tags),
        "fox|bear|bird|animal|mammal|canine|cat|predator|deer|dog"
    ),
    "Animals",
    "Not Animals"
    ))

# Variable 2
selected_photos <- selected_photos %>%
    mutate(popular = ifelse(likes >= median(likes) | views >= median(views),
        "Popular",
        "Not Popular"
    ))

# Variable 3
selected_photos <- selected_photos %>%
    mutate(view_download_ratio = views/downloads
    )

# selected_photos %>% count(popular)

selected_photos <- selected_photos %>%
    filter(userImageURL != "" & view_download_ratio > 1.6)

view(selected_photos)

write_csv(selected_photos, "selected_photos.csv")


# ------------------------------------------------------------------------------------------------------------------------------------------------------



calc1 <- selected_photos %>%
    group_by(popular) %>%
    summarise(avg_likes = round(mean(likes),1), avg_views = round(mean(views),1), avg_downloads = round(mean(downloads),1), avg_view_to_download_ratio = round(mean(view_download_ratio),4))
view(calc1)



calc2 <- selected_photos %>%
    group_by(tags_types) %>%
    summarise(popular_count = sum(popular == "Popular", na.rm = TRUE), not_popular_count = sum(popular == "Not Popular", na.rm = TRUE))
calc2

calc3 <- selected_photos %>%
    group_by(popular) %>%
    summarise(download_count = sum(downloads))
calc3


img_urls <- selected_photos$previewURL %>% na.omit()

image_read(img_urls) %>%
    image_join() %>%
    image_scale(500) %>%
    image_animate(fps = 1) %>%
    image_write("my_photos.gif")

