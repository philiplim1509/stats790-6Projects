install.package(magick)

library(magick)
# Need to have:
# c(), image_blank(), image_read(), image_annotate(), image_append()

lookup = image_read("https://i.kym-cdn.com/entries/icons/mobile/000/047/940/cat_eating_looking_up.jpg") %>%
  image_scale(400)

orange_cat = image_read("https://cdn3.emoji.gg/emojis/1312-suscat.png") %>%
  image_scale(400)


meme_text1 = image_blank(400,225,"#000000") %>%
  image_annotate("Looking at red dot light",
                 color = "#FFFFFF",
                 size = 28,
                 font = "sans",
                 gravity = "Center")

meme_text2 = image_blank(400,400,"#000000") %>%
  image_annotate("When you realise whose \n been controlling the red light",
                 color = "#FFFFFF",
                 size = 28,
                 font = "sans",
                 gravity = "Center")

first_row = c(lookup, meme_text1) %>%
  image_append()

second_row = c(orange_cat, meme_text2) %>%
  image_append()

meme_creation = c(first_row, second_row) %>%
  image_append(stack = TRUE)

meme_creation

static = image_write(meme_creation, "static_meme.png")



# need to have:
#   4 frames

image1 = image_read("1.png") %>%
  image_scale(400) %>%
  image_annotate("          Learning Stats 220",
                 color = "#FFFFFF",
                 size = 28,
                 font = "Trebuchet")

image2 = image_read("2.png") %>%
  image_scale(400) %>%
  image_annotate("    Realising its coding course",
                 color = "#FFFFFF",
                 size = 28,
                 font = "Trebuchet") %>%
  image_noise()

image3 = image_read("3.png") %>%
  image_scale(400) %>%
  image_annotate("    There are multiple project",
                 color = "#FFFFFF",
                 size = 28,
                 font = "Trebuchet")%>%
  image_noise()


image4 = image_read("4.png") %>%
  image_scale(450) %>%
  image_annotate("      There are test and exam",
                 color = "#FFFFFF",
                 size = 28,
                 font = "Trebuchet")%>%
  image_implode(factor = 0.5)

image_1 = image_read("inspo_meme2.png") %>%
  image_crop("260x350") %>%
  image_scale(400) %>%
  image_annotate("Lastly",
                 color = "#FFFFFF",
                 size = 28,
                 font = "Trebuchet")

image5 = image_read("1.png") %>%
  image_scale(400) %>%
  image_annotate("         It's not double pass",
                 color = "#FFFFFF",
                 size = 28,
                 font = "Trebuchet")

template_animation = c(image1, image2, image3, image5, image4)

animated_meme = image_animate(template_animation, fps=0.5)

save = image_write(animated_meme, "animated_meme.gif")
