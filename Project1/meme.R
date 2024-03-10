```{r}
setwd("C:/Users/phili/Documents/GitHub/stats220/Project1")
```


```{r}
library(magick)


orange_cat = image_read("inspo_meme.gif") %>%
  image_scale(10)

orange_cat
```
