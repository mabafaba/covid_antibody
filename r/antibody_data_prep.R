

generate_x_coordinates<-function(ab){
  
  #' we're missing info on genomic position, so we'll create some values to arrange the data by along the x (angular) axis
  
  # sort
  ab <- ab %>% arrange(known_covid_antibody,Patient,Clonality,Name) 
  #' assign fake "start" and "end" positions for each antibody (same width for all)
  #' to make our life easier later, make them start at 0 for each patient, with an antibody "lenght" of 1
  ab <- ab %>% group_by(Patient) %>% mutate(start=0:(n()-1), end = 1:n()) %>% ungroup
  
  
  #' "inter patient connections" in the plot should connect the entire clonality group that contains the link
  #' to do that it helps a lot to have the "inter-patient connection" group added to all entries of a clonality group
  ab <- ab %>% filter(Clonality!="unique") %>%  # remove all entries without clonality temporarily
    group_by(Clonality) %>% # for each clonality group..
    mutate(`Inter-Patient connection` = expand_not_na(`Inter-Patient connection`)) %>% # expand the first inter patient connection group to all values
    bind_rows(ab %>% filter(Clonality=="unique")) %>% # add non-clonality entires back in
    arrange(known_covid_antibody,Patient,Clonality, Name) # get rows back in order
  
  return(ab)
}


# add known covid-antibodies ----------------------------------------------

highlight_known_covid_ipcs<-function(ab, known_covid_ipc){
  ab$known_covid_antibody<-FALSE
  ab$known_covid_antibody[ab$`Inter-Patient connection` %in% known_covid_ipc]<-TRUE
  ab
}


# merge patients ----------------------------------------------------------

merge_patients<-function(ab, patient1, patient2){
  ab$Patient[ab$Patient==patient2]<-patient1
  ab
}



