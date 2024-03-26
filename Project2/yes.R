library(tidyverse, help, pos = 2, lib.loc = NULL)
song_data <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQjF1Hf5KQ9--IboWbmaXJ14tknXsXUcfTlqZM4CVI3OiSnG_w6BxQcD5EJ4lvF5UeVXXLPmWyckJQ2/pub?gid=943654468&single=true&output=csv")
song_data %>%
  ggplot() +
   geom_bar(aes(x = mode_name, fill = tempo))


song_data %>%
  ggplot() +
   geom_bar(aes(x = tempo, fill = mode_name))
