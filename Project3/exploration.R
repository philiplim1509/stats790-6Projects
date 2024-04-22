library(tidyverse)
library(dplyr)
library(jsonlite)
library(magick)
json_data <- fromJSON("pixabay_data.json")
pixabay_photo_data <- json_data$hits

# selected_photos = pixabay_photo_data %>% slice(1:50)
selected_photos <- pixabay_photo_data

selected_photos %>% select(pageURL)


variable1 <- selected_photos %>%
    mutate(tags_types = ifelse(str_detect(
        str_to_lower(tags),
        "fox|bear|bird|animal|mammal|canine|cat|predator|deer|dog"
    ),
    "Animals",
    "Not Animals"
    ))

variable2 <- variable1 %>%
    mutate(popular = ifelse(likes >= mean(likes) & views >= mean(views) & downloads >= mean(downloads),
        "Popular",
        "Not Popular"
    ))

variable3 <- variable2 %>%
    mutate(active_user = ifelse(collections >= mean(collections),
        "Active Collections",
        "Not Active Collections"
    ))

view(variable3)



filtered_photos <- variable3 %>%
    filter(tags_types == "Not Animals" & popular == "Not Popular" & userImageURL != "" & active_user == "Not Active Collections")

view(filtered_photos)

selected_photos <- filtered_photos
view(selected_photos)

write_csv(selected_photos, "selected_photos.csv")

calc1 <- variable3 %>%
    group_by(popular) %>%
    summarise(total_likes = sum(likes), total_views = sum(views))
calc1

calc2 <- selected_photos %>%
    group_by(tags_types) %>%
    summarise(popular_count = sum(popular == "Popular", na.rm = TRUE))
calc2

calc3 <- selected_photos %>%
    group_by(popular, tags_types) %>%
    summarise(download_count = sum(downloads))
calc3


img_urls <- selected_photos$previewURL %>% na.omit()

x <- image_read(img_urls) %>%
    image_join() %>%
    image_scale(400) %>%
    image_animate(fps = 1) %>%
    image_write("my_photos.gif")
x
