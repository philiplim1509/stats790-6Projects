library(tidyverse)

#Reads the data frame and assign a variable name to each columns
learning_data <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vSI6cLoMaiWKH9pocOkC40BlUYBPz2V-UDtZ1Evz-qG0UOVd5ML_ZGBEDz7L3-zkxa8fSPf2KyY57mB/pub?gid=1662325778&single=true&output=csv") %>%
    rename(
        age = 2,
        gender = 3,
        frequent_social = 4,
        hour_social = 5,
        effect_social = 6,
        emotion_social = 7,
        sleep = 8
    )


names(learning_data)

bar_point = learning_data %>% ggplot(aes(x = sleep, y = age))

