# ---------------------------------------------------------------------------
# Autor: Antonio Pantoja
# Fecha: febrer 7  de 2013
# email: jesuspantoja@gmail.com
# Proposito: Extraer con mascar shp o raster, sirve para una sola carpeta ejemplo worldclim
# Nota:
# ---------------------------------------------------------------------------

import arcgisscripting, os, sys, string
gp = arcgisscripting.create(9.3)
gp.CheckOutExtension("Spatial")
os.system('cls')


entrada = r'\\dapadfs\data_cluster_2\gcm\cmip5\downscaled\rcp60\global_30s'
mascara = r'\\dapadfs\workspace_cluster_9\Coffee_Cocoa2\_indonesia\shp\bse\IDN_adm0.shp'
salida = r'Z:\_indonesia\raster\grid\climate\ftr\2050'

epoca = "2040_2069"
	
lista_modelos = sorted([s for s in os.listdir(entrada)
		if os.path.isdir(os.path.join(entrada,s))])
print 	lista_modelos	
variablelist = ["bio","cons_mths","prec","tmin","tmax","tmean" ]
for modelo in lista_modelos:
	if not os.path.exists(salida + "\\" + modelo): os.system('mkdir ' + salida + "\\" + modelo)
	gp.workspace = entrada  + "\\" + modelo + '\\r1i1p1\\' + epoca
	#rasters = sorted(gp.ListRasters("", "GRID"))
	#for raster in rasters:
	for var in variablelist:
	   if var == "bio":
		num = 19
	   else:
		num = 12
	   # for month in [1,12]:
	   for month in range(1, num+1):
		if var == "cons_mths":
		 raster = var
		else:
		 raster = var + "_" + str(month)	
	
		if raster[:3] != "ozon":  #if raster[:3] != "bio":
			corte = salida + "\\" + modelo + "\\" + raster
			# print  "sale  " + corte
			if not gp.Exists(corte):
				
				RasterEntrada = entrada  + "\\" + modelo + '\\r1i1p1\\' + epoca	 + "\\" + raster
				print RasterEntrada			
				
				gp.workspace = salida  + "\\" + modelo
				#print "workspace Salida" , salida  + "\\" + modelo
				
				gp.SnapRaster =  RasterEntrada
				#print RasterEntrada
				
				gp.ExtractByMask_sa(RasterEntrada, mascara , corte)
				print "\n"
			else:
				print "ya existe: " + corte
print "Proceso terminado !!!"