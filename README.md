# Covid Antibody Visualisation

## Publication

This code was used for:
Kreye, Jakob, et al. "A therapeutic non-self-reactive SARS-CoV-2 antibody protects from lung pathology in a COVID-19 hamster model." Cell (2020).
https://doi.org/10.1016/j.cell.2020.09.049
(Figure S3B)


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


