library(tidyverse)
library(dplyr)
library(jsonlite)
library(magick)


# Slide 1
frame1 <- image_blank(1200, 400, "#B20000") %>%
    image_annotate("YouTube Engagement Over Time For @LEMMiNO and @Rousseau",
        color = "#FFFFFF",
        size = 38,
        font = "sans",
        gravity = "Center"
    )
frame1

slide2 <- image_read("plot1.png") %>%
    image_scale("600x400!")
slide2Text <- image_blank(600, 400, "#B20000") %>%
    image_annotate("
    
    
  This chart shows each channel views count over the year
  
  1. There are instances where @Rousseau's videos outperform 
      @LEMMiNO's, indicating differences in content popularity 
      or audience engagement strategies.
  
  2. Both creators experienced fluctuations in view counts 
      across the years, suggesting the influence of various 
      factors such as video topics, trends, and algorithm changes.
                   ",
        color = "#FFFFFF",
        size = 20,
        font = "Trebuchet",
   
    )
frame2 = c(slide2, slide2Text) %>%
  image_append(stack = FALSE)
frame2


slide3 <- image_read("plot2.png") %>%
  image_scale("600x400!")

slide3Text <- image_blank(600, 400, "#B20000") %>%
  image_annotate("
  
  
  This chart show the video count over the year for 
  their respective channel
  
  1. The total video count for @LEMMiNO shows a 
      general decreasing trend over the years, 
      indicating a change in production style.
    
  2. In contrast, @Rousseau's video uploads appear 
      less consistent, with intermittent 
      years of video releases. However, there's a 
      trend of increasing video production from 2017 onwards.
                 ",
                 color = "#FFFFFF",
                 size = 20,
                 font = "Trebuchet"
  )
frame3 = c(slide3, slide3Text) %>%
  image_append(stack = FALSE)
frame3


slide4 <- image_read("plot3.png") %>%
  image_scale("600x400!")

slide4Text <- image_blank(600, 400, "#B20000") %>%
  image_annotate("
  
  
  
  This chart shows the popular video count. To qualify as popular, 
  a video's views, comments, or likes count must equal or exceed 
  the mean of each respective variable within the video channel.  
      
  1. For @LEMMiNO 44 out of 100 videos are popular.
  
  2. For @Rousseau's 34 out of 100 videos are popular. 
                 ",
                 color = "#FFFFFF",
                 size = 20,
                 font = "Trebuchet"
  )
frame4 = c(slide4, slide4Text) %>%
  image_append(stack = FALSE)
frame4

slide5 <- image_read("plot4.png") %>%
  image_scale("600x400!")

slide5Text <- image_blank(600, 400, "#B20000") %>%
  image_annotate("


  
  This chart shows the letter occurance from the youtube 
  video title
  
  1. Top 2 words are piano and version, this is probably 
      from @Rousseau videos since most of videos 
      consist of 'piano' or 'piano version'
      
  2. Some of the words 'part' are from @LEMMiNO because 
      most of his videos are seperated into parts
                 ",
                 color = "#FFFFFF",
                 size = 20,
                 font = "Trebuchet"
  )
frame5 = c(slide5, slide5Text) %>%
  image_append(stack = FALSE)
frame5


frame6 <- image_blank(1200, 400, "#B20000") %>%
    image_annotate("

  Overall, I learned that analyzing data trends can provide valuable insights 
  into the performance and growth of content creators on platforms like YouTube. 
  
  For instance, developing a line chart to visualize the video count throughout the year 
  illustrates the channel's progressive growth over time.
  
  or
  
  Comparing a bar chart of total video count across years with the previous chart 
  suggests that fewer videos paired with higher viewer counts indicate a focus on quality over quantity,
                   ",
        color = "#FFFFFF",
        size = 25,
        font = "sans"
    )
frame6


template_animation = c(frame1, frame2, frame3, frame4, frame5, frame6)

data_story = image_animate(template_animation, delay=500)
data_story

save = image_write(data_story, "data_story.gif")


