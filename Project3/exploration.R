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
        "fox|bear|bird|animal|mammal|canine|cat|predator|deer|dog|frog|fish|rat"
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
view(calc2)

calc3 <- selected_photos %>%
    group_by(tags_types) %>%
    summarise(download_count = sum(downloads))
view(calc3)


img_urls <- selected_photos$previewURL %>% na.omit()

image_read(img_urls) %>%
    image_join() %>%
    image_scale(500) %>%
    image_animate(fps = 1) %>%
    image_write("my_photos.gif")


#--------------------------
# Creativity

calc1 %>%
ggplot(aes(x = popular, y = avg_likes)) +
  geom_bar(stat = "identity") +
  labs(x = "Popularity", y = "Average Likes", title = "Average Likes by Popularity")

  
calc3 %>%
ggplot(aes(x = tags_types, y = download_count)) +
  geom_bar(stat = "identity") +
  labs(x = "Types of Tags", y = "Total Downloads", title = "Total Downloads by different Tags")


# Meme
url = "https://cdn.pixabay.com/photo/2015/09/06/11/40/zebras-927272_1280.jpg"
download.file(url, destfile = "zebra.png", mode = "wb")

lookup = image_read("zebra.png") %>%
  image_scale(400)

meme_text = image_blank(400,225,"#000000") %>%
  image_annotate("Am I black covered in white stripe or
  Am I white covered in black stripe",
                 color = "#FFFFFF",
                 size = 20,
                 font = "sans",
                 gravity = "Center")

first_row = c(lookup, meme_text) %>%
  image_append()

image_write(first_row, "meme.png")

