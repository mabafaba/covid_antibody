
# plot elements -----------------------------------------------------------

antibody_rectangles<-function(ab, rectangle_color,border_color = "white",y=c(0,1),lty="solid",track.index = NULL){
  
  ab %>% ungroup %>% 
    transmute(xleft = start,ybottom = y[1],
              xright = end, 
              ytop = y[2],
              sector.index = Patient,
              track.index = track.index,
              col = rectangle_color,
              border = border_color,
              lty = lty) %>%
    purrr::pmap(circos.rect) %>% invisible()
  
}


antibody_links<-function(links,link_color){
  
  links$color<-link_color

  link_thickness <- ifelse(links$known_covid_antibody,
                           "1", # when known_covid_antibody then this thickness
                           "0.2") #otherwise this

  links$thickness<-link_thickness
  
  links %>% ungroup %>% rowwise %>% transmute(sector.index1 = from_patient,
                                              point1 = list(c(from_start,from_end)),
                                              sector.index2 = to_patient,
                                              point2 = list(c(to_start,to_end)),
                                              col = color,lty = "solid", lwd= thickness) %>%  
    purrr::pmap(circos.link) %>% invisible() 
}



# labels ------------------------------------------------------------------

#' patient labels
patient_labels <-function(ab, patient_label_offset,patient_label_prefix,patient_label_size){
  ab %>% group_by(Patient) %>% 
    summarise(midpoint = min(start) + ((max(start)-min(start))/2)) %>%  # calculate midpoint for x position
    transmute(x = midpoint,
              y = 1 + patient_label_offset,  # a bit above outside the circle
              label = paste(patient_label_prefix, Patient), 
              track.index = 1,
              sector.index = Patient,
              cex = patient_label_size,
              niceFacing = T) %>% # flip labels to not be totally upside down 
    purrr::pmap(circos.text) %>% invisible()
}
antibody_labels <-function(ab, antibody_label_offset,antibody_label_facing,antibody_label_size){
  
  #' antibody labels (mostly for debugging but can keep)
  ab %>% transmute(x = start, # left aligned. ### alternative: + (end-start)/2, # the rect center
                   y = 1+antibody_label_offset, #a bit above the top of the track which is at 1
                   label = Name,
                   facing = antibody_label_facing,
                   sector.index = Patient,
                   track.index = 1,
                   cex = antibody_label_size, adj = 0) %>%
    purrr::pmap(circos.text) %>% invisible()
}
# colors ------------------------------------------------------------------



#' function to create colors for each unique value in a vector and return a vector with corresponding colors
#' @param x a vector
#' @param palette the name of a viridis palette. You should use "magma" because it is {kiss all right hand fingertips}
#' @param randomise_order randomise the order of the palette
#' @param seed change this to a number different than 999 to get a different (deterministic) colour randomisation
#' @return a vector of colors same length as x
as_colors<-function(x, palette = "magma", randomise_order = T, seed = 999){
  
  n <- length(unique(x)) # how many we need
  cols <- viridis(n,option = palette) # make palette
  if(randomise_order){
    set.seed(seed)
    cols<-sample(cols)
  }
  if(length(cols)<n){stop("not enough colours in pallette")}
  
  return(cols[match(x,unique(x))]) # get vector of colors matching the input vector
  
}


# nice colors:
palette<-as_colors(1:20,randomise_order = F)
# 
# plot(1:20,rep(1,20),col=as_colors(1:20,randomise_order = F),pch=20,cex=20)
# text(1:20,rep(1.1,20),labels = 1:20)


# antibody labels -------------------------------------------------------------------





