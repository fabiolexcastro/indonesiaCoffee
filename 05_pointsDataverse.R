
# Load libraries ----------------------------------------------------------------------
require(pacman)
pacman::p_load(raster, rgdal, rgeos, stringr, velox, sf, tidyverse, plotKML, magrittr)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999)

# Load data ---------------------------------------------------------------------------
tbl <- read_csv('../tbl/occ/CoffeePoints_2_dataverse.csv') 

# Processing the dataframe ------------------------------------------------
tbl %<>% 
  mutate(Specie = 'arabica',
         Source = 'https://doi.org/10.7910/DVN/29634') %>% 
  filter(Country == 'Indonesia') %>% 
  dplyr::select(-Taxon, -ADM1_NAME, -ADM2_NAME)

write.csv(tbl, '../tbl/occ/arabica_dataverse.csv', row.names = FALSE)

