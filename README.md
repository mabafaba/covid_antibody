# Covid Antibody Visualisation

## Project structure
- `circos.html` output (includes code)
- `circos.Rmd`  main script & doc (produces circos.html)
- `covid_raw.R` equivalent to `circos.Rmd` but straight up R code (without markdown)
- `covid_antibody.RProj` open this file to edit the scripts in RStudio
- `./r/.*.R` functions used in circos.Rmd
- `./data` raw data as received. Do not edit these files. (may be exluded from repository - please ask for data)
- `./resources` related information / documents

## Citation

Please cite the `circlize` package authors as:

```
@Article{,
   title = {circlize implements and enhances circular visualization in R},
   author = {Zuguang Gu and Lei Gu and Roland Eils and Matthias Schlesner and Benedikt Brors},
   journal = {Bioinformatics},
   volume = {30},
   issue = {19},
   pages = {2811-2812},
   year = {2014},
 }
```
(more info on citing R packages: https://www.r-bloggers.com/how-to-cite-packages/ )



## To Do

- join patients COVID01 und COVID01-t2
- highlight anti-covid IPCs
- add clonality band
- add # patients connected band
- 
