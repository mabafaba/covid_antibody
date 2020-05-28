#' we need an "edge" list to draw the links that has:
#' - one row per link, with the names of the clonalities they connect 
#' - four values on the "x axis" for the four "corners" of the band (from_start, from_end, to_start, to_end)
#' - info which patients they connect (because x values are applied relative to the sector)




# functions ---------------------------------------------------------------


get_link_table<-function(ab){
  links <- ab %>% ungroup %>% 
    # get only those antibodies with links
    filter(!is.na(`Inter-Patient connection`)) %>%
    # pick out relevant columns
    select(Name,`Inter-Patient connection`) %>% 
    # do everything after this for each "connection group" (they appear multiple times but we just filter them out after)
    group_by(`Inter-Patient connection`) %>%  
    # get all possible combinations of 2 within each group:  1 and 2 and 3 --->   1-1 and 1-2 and 1-3 and 2-3
    transmute(name = list((combn(as.character(Name),2) %>% t))) 
  # extract the source -> target combinations for the bands and turn them into a data frame of their own
  links <- links$name %>% do.call(rbind,.) %>% data.frame 
  colnames(links)<-c("from_name","to_name")
  # remove duplicates
  links <-unique(links)
  links
}

add_info_to_link_table<-function(links,ab){
  links <- links %>%
    # merge info for the start antibody
    inner_join(ab %>% select(Name,
                             from_patient = Patient,
                             from_clonality = Clonality,
                             from_start = start,
                             from_end = end,
                             known_covid_antibody = known_covid_antibody),
               by=c("from_name" = "Name")) %>% 
    # merge info for the end antibody
    inner_join(ab %>% select(Name,
                             to_patient = Patient,
                             to_clonality = Clonality,
                             to_start = start,
                             to_end = end),
               by=c("to_name" = "Name"))
}




merge_clonality_in_links<-function(links){
#' merge links that come from & to antibodies of the same clonality
#' this means we want one row for each unique patient & clonality (from and to) combination (considering "unique" clonalities as actually unique values)

#' create actually unique clonality values for "unique" clonality entries
links$from_clonality[links$from_clonality=="unique"] <- paste("unique_clon ",
                                                              links$from_name[links$from_clonality=="unique"]
)
links$to_clonality[links$to_clonality=="unique"] <- paste("unique_clon ",
                                                          links$to_name[links$to_clonality=="unique"])                                                              


links <- links %>% 
  group_by(from_patient, from_clonality, to_patient,to_clonality, known_covid_antibody) %>%  # this will let us end up with one row per unique combination of these variables
  summarise(
    # get the min/max values for the start/end x coordinates of the "from" and "to" anitbodies of each joined band
    from_start = min(from_start),
    from_end = max(from_end),
    to_start = min(to_start),
    to_end = max(to_end)
  )
}

remove_inter_patient_links<-function(links){
  # get rid of links within patients:
  links <- links %>% filter(from_patient != to_patient)
  
}


#' 
#' link_group_count <- links %>% ungroup %>% 
#'   tidyr::pivot_longer(cols = ends_with("clonality"),
#'                       names_to = "from/to",
#'                       values_to = "clonality") %>% 
#'   select(clonality) %>% group_by(clonality) %>% summarise(n=n()) %>% arrange(desc(n))
#' 
#' 
#' #' count how many other links are connected with the same antibodies each link is connected to (1 patient, 2 patients, 3 patients?)  
#' num_links_in_group<-function(clonalities){
#'   max(link_group_count$n[link_group_count$clonality %in% clonalities])
#' }

# links <- links %>%
#   rowwise %>%
#   mutate(group_size = num_links_in_group(c(from_clonality,to_clonality))) %>%
#   arrange(desc(group_size)) %>% ungroup



