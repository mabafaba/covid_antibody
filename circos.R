## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE,message = FALSE,warning = FALSE)

## ---- eval=FALSE---------------------------------------------------------
## 
## # setup & loading functions -----------------------------------------------
## 
## # hope I didn't forget any
## 
## # if you don't have these packages yet, please install:
## # install.packages("circlize")
## # install.packages("dplyr")
## # install.packages("RColorBrewer") # funky colours
## # install.packages("viridis")  # even more funky colours <3
## # install.packages("purrr")
## # install.packages("readr")
## # install.packages("knitr") # required only to process this file
## 

## ---- message=FALSE, warning=FALSE---------------------------------------
library(circlize)
library(dplyr)
library(RColorBrewer)
library(viridis)
library(purrr)
library(readr)

## ------------------------------------------------------------------------
# source all files in ./r
# they're all functions used below
sapply(list.files("./r",pattern = ".*\\.R",full.names = T),source) %>% invisible()

## ------------------------------------------------------------------------
citation("circlize")
#' citation("dplyr")
#' citation("purrr")

## ---- message=FALSE,warning=FALSE----------------------------------------
ab <- readr::read_delim("./data/antibody_v4.csv",delim = ",")
# standardise headers
ab <- ab %>% select(Patient = ID,
                    Name = Name,
                    Clonality = Clonality,
                    `Inter-Patient connection` = `Inter Patient Clonality`)

# shorten patient names
ab$Patient<-gsub("COVID0","CV",ab$Patient)
ab$Patient<-gsub("COVID-","CV-",ab$Patient)


## ------------------------------------------------------------------------
ab <- ab %>%
  merge_patients("CV01","CV01_t2") %>% 
  merge_patients("CV-SP", "CV-SP (HD-B)") %>%
  highlight_known_covid_ipcs(c(
    "CV38-119",
    # "CV03-150",
    "CV07-209",
    # "HL CV01-276",
    "CV07-209",
    "HK CV05-191",
    "HL CV07-235",
    "HK CV07-143",
    "CV07-255", 
    "CV38-119",
    # "CV03-106",
    "(CV05-114)",
    "CV07-255",
    # "(CV-SP-107)",
    "CV05-119",
    "CV07-209"
                               )) %>% 
  generate_x_coordinates 

## ------------------------------------------------------------------------
links <- ab %>%
  get_link_table %>%  
  add_info_to_link_table(ab) %>% 
  merge_clonality_in_links %>% 
  remove_inter_patient_links

## ---- eval = TRUE--------------------------------------------------------
pdf(file = "./circos_plot.pdf",width = 5,height = 6)

## ------------------------------------------------------------------------


# plot parameters --------------------------------------------------------------------

pdf_width <- 5
pdf_height<- 6
gap_between_patients <- 5 # in degree out of 360

# plot setup --------------------------------------------------------------------

circos.clear() # reset to defaults just in case
circos.par("track.height" = 0.3, gap.after = gap_between_patients) # ?circos.par : track.height: The default height of tracks. It is the percentage according to the radius of the unit circle. The height includes the top and bottom cell paddings but not the margins. convert_height can be used to set the height to an absolute unit.

# get the limits on the x axis per patient so we can set up the circle layout accordingly
x_limits <- ab %>% group_by(Patient) %>% summarise(x_min = min(start), x_max = max(end)) %>% select(-Patient)
#' allocate sectors
#' "factors" argument: variable with categories to split the pie (often chromosomes)
#' "xlim" argument: the minimum and maximum values for the x axis

circos.initialize(factors = ab$`Patient`, xlim = x_limits)

# track for antibody stripes
circos.trackPlotRegion(factors =ab$`Patient`, ylim = c(0, 1),bg.border = NA,track.margin = c(0,0))


# Plot stripes ---------------------------------------------------------





# Plot markers for clonality

ab %>% 
  filter(Clonality!="unique") %>% 
  group_by(Patient,Clonality) %>%
  summarise(start = min(start),end= max(end)) %>% 
  antibody_rectangles(rectangle_color = "#000000",  # fill black
                      border_color = "#FFFFFF", # border white (for gaps between the black stripes where clon groups touch)
                      y = c(0.95, 1.05))


# individual antibodies

# decide the colors
colors <- ifelse(ab$known_covid_antibody,
                                  palette[13], # when known_covid_antibody then this color
                                  "#CCCCCC" )# otherwise this color
# plot
ab %>% 
  antibody_rectangles(rectangle_color = colors,
                      border_color = colors,
                      y=c(-0.1,0.9)) # the track goes from 0 to 1; I move this down a notch so that the clonality peaks out and so there is no gap to the links because it looks cool




# Plot connections --------------------------------------------------------

# decide the colors
link_colors <- ifelse(links$known_covid_antibody,
                      palette[c(13)], # when known_covid_antibody then this color
                      "#CCCCCC") # otherwise this color 

# plot the links
antibody_links(links,link_color = link_colors)



# plot labels -------------------------------------------------------------

patient_labels(ab,patient_label_offset = 0.15,
               patient_label_prefix = "",
               patient_label_size = 0.8)

# 
# antibody_labels(ab,antibody_label_offset = 0,
#                 antibody_label_facing = "clockwise",
#                 antibody_label_size = 0.2)


## ---- results=FALSE, eval = TRUE-----------------------------------------
# dev.off()

## ---- echo = T-----------------------------------------------------------


object_list <- sapply(ls(),get) %>% sapply(is.function)

sapply(names(object_list)[object_list],get) %>% print

palette <-
c("#000004FF", "#07071DFF", "#160F3BFF", "#29115AFF", "#400F73FF", 
"#56147DFF", "#6B1D81FF", "#802582FF", "#952C80FF", "#AB337CFF", 
"#C03A76FF", "#D6456CFF", "#E85362FF", "#F4685CFF", "#FA815FFF", 
"#FD9A6AFF", "#FEB37BFF", "#FECC8FFF", "#FDE4A6FF", "#FCFDBFFF"
)


## ------------------------------------------------------------------------
Sys.time()

## ------------------------------------------------------------------------
sessionInfo()



