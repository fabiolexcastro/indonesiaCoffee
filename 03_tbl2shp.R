
# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(raster, rgdal, rgeos, stringr, velox, sf, tidyverse, readxl)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999)

# Functions to use --------------------------------------------------------
changeNames <- function(lst, position){
  # position <- 1
  print(position)
  tbl <- lst[[position]] %>% 
    setNames(c('no', 'provinsi', paste0('inmature_', position), paste0('mature_', position), paste0('damaged_', position), paste0('total_', position), paste0('prod_ton_', position), paste0('yield_kgha_', position), paste0('farmers_kk_', position))) %>% 
    dplyr::select(-no)
  print('Done!')
  return(tbl)
}
mySum <- function(lst){
  # lst <- ar2
  lst <- Reduce(inner_join, lst)
  lst[is.na(lst)] <- 0
  tbl <- lst %>% 
    mutate(inmature = inmature_1 + inmature_2 + inmature_3,
           mature = mature_1 + mature_2 + mature_3,
           damaged = damaged_1 + damaged_2 + damaged_3,
           total = total_1 + total_2 + total_3,
           prod_ton = prod_ton_1 + prod_ton_2 + prod_ton_3,
           yield_kgha = yield_kgha_1 + yield_kgha_2 + yield_kgha_3,
           farmers_kk = farmers_kk_1 + farmers_kk_2 + farmers_kk_3) %>% 
    dplyr::select(provinsi, inmature, mature, damaged, total, prod_ton, yield_kgha, farmers_kk)
  print('Done!')
  return(tbl)
}

# Load data ---------------------------------------------------------------
nms <- c(paste0('arabica', 1:3, '.csv'), paste0('robusta', 1:3, '.csv'))
ara <- list.files('../tbl', full.names = TRUE, pattern = '.csv$') %>% 
  grep(paste0(nms, collapse = '|'), ., value = TRUE) %>% 
  grep('arabica', ., value = TRUE) %>% 
  lapply(., read_csv)
rob <- list.files('../tbl', full.names = TRUE, pattern = '.csv$') %>% 
  grep(paste0(nms, collapse = '|'), ., value = TRUE) %>% 
  grep('robusta', ., value = TRUE) %>% 
  lapply(., read_csv)
shp <- st_read('../shp/bse/IDN_adm1.shp') %>% 
  mutate(NAME_1 = as.character(NAME_1))

# Apply the function ------------------------------------------------------
ar2 <- lapply(1:3, function(x) changeNames(ara, x))
ro2 <- lapply(1:3, function(x) changeNames(rob, x))
ar2 <- mySum(lst = ar2)
ro2 <- mySum(lst = ro2)

# Join with the shapefile -------------------------------------------------
ar2 <- ar2 %>% 
  mutate(provinsi = stringi::stri_trans_totitle(provinsi))
ro2 <- ro2 %>% 
  mutate(provinsi = stringi::stri_trans_totitle(provinsi))

shp_ar2 <- inner_join(shp, ar2, by = c('NAME_1' = 'provinsi'))
shp_ro2 <- inner_join(shp, ro2, by = c('NAME_1' = 'provinsi'))

st_write(shp_ar2, dsn = '../shp/prd', layer = 'prd_arabica_2', driver = 'ESRI Shapefile', update = TRUE)
st_write(shp_ro2, dsn = '../shp/prd', layer = 'prd_robusta_2', driver = 'ESRI Shapefile', update = TRUE)












