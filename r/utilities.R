



# utilities -----------------------------------------------------------------


shuffle_factor_levels<-function(x, seed = NULL){
  if(!is.null(seed)){
    set.seed(seed)
  }
  x = factor(x,levels(x)[sample(1:length(x))])
  x
}


#' turn all NA values in x into the first value in x that is not NA
#' @param x a vector
#' @return a vector as long as x with no NAs if any value in x was not NA
expand_not_na <- function(x){
  if(all(is.na(x))){return(x)} #if all are NA, do nothing
  first_not_NA <- x[min(which(!is.na(x)))] # get first matching dominant value
  x[is.na(x)]<-first_not_NA # convert all NAs into that value
  x
}




