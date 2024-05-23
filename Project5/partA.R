library(tidyverse)
library(dplyr)
library(jsonlite)
library(magick)
library(rvest)

# My data context is the countries in Ocenia. It gives the population and subregion of the countries in Oceania. 

# In the https://www.worldometers.info/geography/how-many-countries-in-oceania/robots.txt, the website does not any robots txt. so it safe to assume that the website is open to web scraping.
# In the terms of conditions/disclaimer and privacy policy, they didnt specify anything related to web scraping. So, I will proceed with web scraping.



url <- "https://www.worldometers.info/geography/how-many-countries-in-oceania/"
webpage <- read_html(url)

# Create data objects
title <- webpage %>%
    html_nodes("#maincounter-wrap") %>%
    html_element("h1") %>%
    html_text()

countryCount <- webpage %>%
  html_nodes(".maincounter-number") %>%
  html_text() %>%
  str_trim %>%
  as.integer()

countries <- webpage %>%
  html_nodes("#example2 tbody tr td:nth-child(2)") %>%
  html_text()

populations <- webpage %>%
  html_nodes("#example2 tbody tr td:nth-child(3)") %>%
  html_text()

countries
populations
