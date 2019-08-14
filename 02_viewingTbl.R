
# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(raster, rgdal, rgeos, stringr, velox, sf, tidyverse, readxl)

g <- gc(reset = TRUE)
rm(list = ls())
options(scipen = 999)

# Load data ---------------------------------------------------------------
pth <- '../tbl/tables_kopi.xlsx'
sht <- excel_sheets(path = pth)
tb1 <- read_excel(path = pth, sheet = sht[[1]])
tb2 <- read_excel(path = pth, sheet = sht[[2]])
shp <- st_read('../shp/bse/IDN_adm1.shp')

# Remove NAs --------------------------------------------------------------
colnames(tb1) <- c('NO', 'PROVINSI', 'INMATURE_HA', 'MATURE_HA', 'DAMAGED_HA', 'TOTAL_HA', 'PRODUCTION_TON', 'YIELD_KG_HA', 'TK')
colnames(tb2) <- c('NO', 'PROVINSI', 'INMATURE_HA', 'MATURE_HA', 'DAMAGED_HA', 'TOTAL_HA', 'PRODUCTION_TON', 'YIELD_KG_HA', 'TK')

tb1 <- tb1[!is.na(tb1$MATURE_HA),]
tb2 <- tb2[!is.na(tb2$MATURE_HA),]

# Processing the data -----------------------------------------------------
tb1 <- tb1 %>% mutate(PROVINSI = as.character(stringr::str_to_title(PROVINSI)))
tb2 <- tb2 %>% mutate(PROVINSI = as.character(stringr::str_to_title(PROVINSI)))
shp <- shp %>% mutate(NAME_1 = as.character(NAME_1))

nm1 <- pull(tb1, 2) %>% sort()
nm2 <- pull(tb2, 2) %>% sort()
sh1 <- shp %>% pull(NAME_1) %>% sort()

sf1 <- inner_join(shp, tb1, by = c('NAME_1' = 'PROVINSI'))
sf2 <- inner_join(shp, tb2, by = c('NAME_1' = 'PROVINSI'))

st_write(obj = sf1, dsn = '../shp/prd', layer = 'prd_robusta', driver = 'ESRI Shapefile', update = TRUE)
st_write(obj = sf2, dsn = '../shp/prd', layer = 'prd_arabica', driver = 'ESRI Shapefile', update = TRUE)
