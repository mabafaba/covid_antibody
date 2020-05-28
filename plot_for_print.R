# convert rmd to pure R: 
knitr::purl("circos.Rmd")
# open graphics device
pdf(file = "./circos_plot.pdf",width = 5,height = 6)
# plot from pure R code
source("circos.R") 
# close device
dev.off()
