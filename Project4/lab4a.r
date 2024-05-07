song_data <- fromJSON("https://stat.auckland.ac.nz/~fergusson/stats220_S124/data/lab4A.json")
view(song_data)

year_data <- song_data %>%
  mutate(year_released = release_date %>% str_sub(1, 4) %>% parse_number()) %>%
  count(year_released)
year_data

tricky_time_data <- song_data %>%
   mutate(key_tricky = ifelse(str_detect(key_name, "#"),
                            "sharps",
                            "no sharps")) %>%
  mutate(year_released = release_date %>% str_sub(1, 4) %>% parse_number()) %>%
  count(key_tricky, year_released)

view(tricky_time_data)
