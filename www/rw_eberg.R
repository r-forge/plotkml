
# title         : rw_eberg.R
# purpose       : preparation of the Ebergotzen data;
# reference     : [http://geomorphometry.org/content/ebergotzen]
# producer      : Prepared by T. Hengl
# last update   : In Wageningen, NL, June 2012.
# inputs        : various vector and raster imagery; 
# outputs       : rda file for use in a package;
# remarks 1     : limited data set;

library(rgdal)
library(RSAGA)
si <- Sys.info()
fw.path = utils::readRegistry("SOFTWARE\\WOW6432Node\\FWTools")$Install_Dir
gdalwarp = shQuote(shortPathName(normalizePath(file.path(fw.path, "bin/gdalwarp.exe"))))
gdalinfo = shQuote(shortPathName(normalizePath(file.path(fw.path, "bin/gdalinfo.exe"))))
prj <- CRS("+init=epsg:31467")

# ------------------------------------
# Import and format point data:
# ------------------------------------

# download data from the server:
download.file("http://geomorphometry.org/system/files/ebergotzen_input.zip", destfile=paste(getwd(), "/", "ebergotzen_input.zip", sep="")) 
unzip("ebergotzen_input.zip")

# 3D textures:
korng10 <- read.table("korng_mit_skelettanteil_09.gstat", skip = 7)
korng30 <- read.table("korng_mit_skelettanteil_29.gstat", skip = 7)
korng50 <- read.table("korng_mit_skelettanteil_49.gstat", skip = 7)
korng70 <- read.table("korng_mit_skelettanteil_69.gstat", skip = 7)
korng90 <- read.table("korng_mit_skelettanteil_89.gstat", skip = 7)
# horizon names:
korng10$hor <- rep("H1", nrow(korng10))
korng30$hor <- rep("H2", nrow(korng30))
korng50$hor <- rep("H3", nrow(korng50))
korng70$hor <- rep("H4", nrow(korng70))
korng90$hor <- rep("H5", nrow(korng90))
# point IDs (use coordinates to attach those):
korng10$ID <- as.factor(paste(korng10$V1, korng10$V2, sep="_"))
korng30$ID <- as.factor(paste(korng30$V1, korng30$V2, sep="_"))
korng50$ID <- as.factor(paste(korng50$V1, korng50$V2, sep="_"))
korng70$ID <- as.factor(paste(korng70$V1, korng70$V2, sep="_"))
korng90$ID <- as.factor(paste(korng90$V1, korng90$V2, sep="_"))
# merge all horizons into a single data frame:
t1 <- merge(korng10, korng30, by="ID", all.x=TRUE, all.y=FALSE)
t2 <- merge(korng10, korng50, by="ID", all.x=TRUE, all.y=FALSE)
t3 <- merge(korng10, korng70, by="ID", all.x=TRUE, all.y=FALSE)
t4 <- merge(korng10, korng90, by="ID", all.x=TRUE, all.y=FALSE)

# add soil types:
library(gdata)
perl <- gdata:::findPerl("perl")
# perl = "C:/Perl64/bin/perl.exe"
tex <- read.xls("textures.xls", perl=perl)
str(tex)
tex$ID <- as.factor(paste(tex$X, tex$Y, sep="_")) 
tx <- merge(korng10, tex[,c("ID","name","soiltype")], by="ID", all.x=TRUE, all.y=FALSE)
str(tx)
summary(tx$soiltype)
# soil type names need to be trimmed:
levels(tx$soiltype) <- gdata::trim(levels(tx$soiltype))
# reclassify:
tx$soiltype <- as.factor(as.character(tx$soiltype)) 
# check IDs:
summary(tx$name)
tx$rindex <- as.integer(row.names(tx))
# add full soil names:
classnames <- data.frame(matrix(c("A", "Auenboden", "B", "Braunerde", "D", "Pelosol", "G", "Gley", "Ha", "Moor", "Hw", "HMoor", "K", "Kolluvisol", "L", "Parabraunerde", "N", "Ranker", "Q", "Regosol", "R", "Rendzina", "S", "Pseudogley", "Z", "Pararendzina"), ncol=2, byrow = TRUE))
names(classnames) <- c("soiltype", "TAXGRSC")
x <- merge(tx, classnames, all.x=TRUE, by="soiltype")

# format to a table / data.frame:
eberg <- x[order(x$rindex),c("name","soiltype","TAXGRSC")]
eberg$X <- t1$V1.x
eberg$Y <- t1$V2.x
eberg$UHDICM_A <- rep(0, nrow(eberg))
eberg$LHDICM_A <- rep(10, nrow(eberg))
eberg$SNDMHT_A <- t1$V3.x
eberg$SLTMHT_A <- t1$V4.x 
eberg$CLYMHT_A <- t1$V5.x
eberg$UHDICM_B <- rep(10, nrow(eberg))
eberg$LHDICM_B <- rep(30, nrow(eberg))
eberg$SNDMHT_B <- t1$V3.y
eberg$SLTMHT_B <- t1$V4.y 
eberg$CLYMHT_B <- t1$V5.y
eberg$UHDICM_C <- rep(30, nrow(eberg))
eberg$LHDICM_C <- rep(50, nrow(eberg))
eberg$SNDMHT_C <- t2$V3.y
eberg$SLTMHT_C <- t2$V4.y 
eberg$CLYMHT_C <- t2$V5.y
eberg$UHDICM_D <- rep(50, nrow(eberg))
eberg$LHDICM_D <- rep(70, nrow(eberg))
eberg$SNDMHT_D <- t3$V3.y
eberg$SLTMHT_D <- t3$V4.y 
eberg$CLYMHT_D <- t3$V5.y
eberg$UHDICM_E <- rep(70, nrow(eberg))
eberg$LHDICM_E <- rep(90, nrow(eberg))
eberg$SNDMHT_E <- t4$V3.y
eberg$SLTMHT_E <- t4$V4.y 
eberg$CLYMHT_E <- t4$V5.y

# add missing IDs:
eberg$name <- paste(eberg$name)
sel <- which(eberg$name == "NA")
eberg[sel,"name"] <- paste("idx", substr(1000+1:length(sel), 2, 5), sep="")
eberg$name <- as.factor(eberg$name)

# fix numbers and replace all 0 values with NA's:
for(i in c("A", "B", "C", "D", "E")){
  for(j in c("SNDMHT", "SLTMHT", "CLYMHT")){
    vname <- paste(j, i, sep="_")
    sel <- which(eberg[,vname] == 0)
    if(length(sel)>0){ eberg[sel,vname] <- rep(NA, length(sel)) }
    }
}

# remove points with no textures:
eberg <- eberg[!(is.na(eberg$SNDMHT_A)&is.na(eberg$SNDMHT_B)&is.na(eberg$SNDMHT_C)),]
row.names(eberg) <- NULL
# View(eberg)
names(eberg)[1] <- "ID"
str(eberg)

# ------------------------------------
# Import and format gridded data:
# ------------------------------------

bbox <- matrix(c(3570000, 5708000, 3580000, 5718000), nrow=2)

# 100 m resolution SRTM DEM:
system(paste(gdalwarp, "srtm50m_4426.sdat srtm100m.sdat -of \"SAGA\" -r bilinear -te", bbox[1,1], bbox[2,1], bbox[1,2], bbox[2,2], "-tr", 100, 100))
# TWI:
rsaga.geoprocessor(lib="ta_hydrology", module=15, param=list(DEM="srtm100m.sgrd", C="catharea.sgrd", GN="catchslope.sgrd", CS="modcatharea.sgrd", SB="twi100m.sgrd", T=10))
# CORINE Land cover map:
system(paste(gdalwarp, 'E:/EU/g100_06.tif g100_06.sdat -t_srs \"', prj@projargs, '\" -of \"SAGA\" -r near -te ', bbox[1,1], bbox[2,1], bbox[1,2], bbox[2,2], '-tr', 100,100))
# ASTER imagery downloaded from [http://glovis.usgs.gov/]
system(paste(gdalinfo, "AST_L1A_00306052010103253_20120515122657_12883.hdf"))
system(paste(gdalwarp, 'HDF4_EOS:EOS_SWATH:"AST_L1A_00306052010103253_20120515122657_12883.hdf":TIR_Band14:ImageData TIR14.sdat -s_srs \"+proj=longlat\" -t_srs \"', prj@projargs, '\" -of \"SAGA\" -r bilinear -te ', bbox[1,1], bbox[2,1], bbox[1,2], bbox[2,2], '-tr', 100,100))
# Geological map (parent material):
rsaga.geoprocessor(lib="grid_gridding", module=0, param=list(USER_GRID="parent_material_type.sgrd", GRID_TYPE=0, INPUT="4426_parent_material.shp", FIELD=1, TARGET=0, LINE_TYPE=0, USER_SIZE=100, USER_XMIN=bbox[1,1]+100/2, USER_XMAX=bbox[1,2]-100/2, USER_YMIN=bbox[2,1]+100/2, USER_YMAX=bbox[2,2]-100/2))
# fix the last column (copy values):
grid100 <- readGDAL("parent_material_type.sdat")
xyz <- as.matrix(grid100)
xyz[100,] <- xyz[99,]
# image(xyz)
grid100$PRMGEO6 <- as.factor(as.vector(xyz))
geo.lev <- c("Lower Bunter Sandstone (depression)", "Lower Bunter Sandstone (river valley)", "Clayey derivats from weathered Lower Muschelkalk", "Clay and loess from Upper Bunter Sandstone covered with loess", "Lower Muschelkalk (depression)", "Upper Bunter Sandstone (slope)", "Silt and sand from loess covering sandy Lower Bunter Sandstone", "Sandy material from weathered Middle Bunter Sandstone")
levels(grid100$PRMGEO6) <- geo.lev 
# spplot(grid100["PRMGEO6"])
grid100$DEMSRT6 <- round(readGDAL("srtm100m.sdat")$band1, 0)
grid100$TWISRT6 <- round(readGDAL("twi100m.sdat")$band1, 1)
grid100$TIRAST6 <- round(readGDAL("TIR14.sdat")$band1, 0)
# str(grid100@data)
grid100$LNCCOR6 <- readGDAL("g100_06.sdat")$band1
lnc <- read.table("E:/EU/clc_legend_qgis.txt", sep=",", skip = 2)
names(lnc)[1] <- "LNCCOR6"
lnc.x <- merge(data.frame(rowi=1:length(grid100$LNCCOR6), LNCCOR6=grid100$LNCCOR6), lnc[,c("LNCCOR6","V6")], all.x=TRUE, all.y=FALSE)
grid100$LNCCOR6 <- lnc.x[order(lnc.x$rowi),]$V6
# spplot(grid100["LNCCOR6"])
grid100$band1 <- NULL
eberg_grid <- as.data.frame(grid100)
str(eberg_grid)

# 25 m resolution DEM:
system(paste(gdalwarp, "4426.sdat dem25m.sdat -of \"SAGA\" -r bilinear -te", bbox[1,1], bbox[2,1], bbox[1,2], bbox[2,2], "-tr", 25, 25))
# TWI:
rsaga.geoprocessor(lib="ta_hydrology", module=15, param=list(DEM="dem25m.sgrd", C="catharea.sgrd", GN="catchslope.sgrd", CS="modcatharea.sgrd", SB="twi25m.sgrd", T=10))
## 25 m resolution ASTER VNIR:
# system(paste(gdalwarp, 'HDF4_EOS:EOS_SWATH:"AST_L1A_00306052010103253_20120515122657_12883.hdf":VNIR_Band1:ImageData VNIR1.sdat -s_srs \"+proj=longlat\" -t_srs \"', prj@projargs, '\" -of \"SAGA\" -r bilinear -te ', bbox[1,1], bbox[2,1], bbox[1,2], bbox[2,2], '-tr', 25,25))
# Shape file with agricultural plots:
bs4426 <- readShapePoly("bs4426_nur_bs_flächen.shp")
bs4426$hb <- as.numeric(bs4426$HAUPTBOTYP)
writePolyShape(bs4426["hb"], "bs4426.shp")
rsaga.geoprocessor(lib="grid_gridding", module=0, param=list(USER_GRID="bs4426.sgrd", GRID_TYPE=0, INPUT="bs4426.shp", FIELD=1, TARGET=0, LINE_TYPE=0, USER_SIZE=25, USER_XMIN=bbox[1,1]+25/2, USER_XMAX=bbox[1,2]-25/2, USER_YMIN=bbox[2,1]+25/2, USER_YMAX=bbox[2,2]-25/2))

grid25 <- readGDAL("dem25m.sdat")
grid25$DEMTOPx <- round(grid25$band1, 0)
grid25$HBTSOLx <- round(readGDAL("bs4426.sdat")$band1, 0)
grid25$HBTSOLx <- as.factor(ifelse(grid25$HBTSOLx==129, NA, grid25$HBTSOLx))
levels(grid25$HBTSOLx) <- levels(bs4426$HAUPTBOTYP)
# spplot(grid25["HBTSOLx"])
grid25$TWITOPx <- round(readGDAL("twi25m.sdat")$band1, 1)
# LANDSAT NDVI:
grid25$NVILANx <- readGDAL("landsat_ndvi.asc")$band1
# clean up and reformat:
grid25$band1 <- NULL
eberg_grid25 <- as.data.frame(grid25)
str(eberg_grid25)


# ------------------------------------
# Export and compress:
# ------------------------------------

save(eberg, file="eberg.rda", compress="xz")
save(eberg_grid, file="eberg_grid.rda", compress="xz")
save(eberg_grid25, file="eberg_grid25.rda", compress="xz")


# end of script;