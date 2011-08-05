
# Comparison gdalwarp and reproject from the raster package:
source('../pkg/R/reproject.R')

# Download data:
download.file("http://spatial-analyst.net/DATA/ebergotzen.zip", destfile="ebergotzen.zip")
unzip(files="SLOPE.asc", zipfile="ebergotzen.zip")
tif.file <- "SLOPE.asc"  # 25M pixs

## First download and install FWTools from http://fwtools.maptools.org/  or  http://fwtools.maptools.org/linux-experimental.html
# Locate GDALwarp undex Windows:
fw.path <- shortPathName(readRegistry("SOFTWARE\\WOW6432NODE\\FWTools")$Install_Dir)
gdalwarp <- ifelse(.Platform$OS.type=="windows", paste(fw.path, "bin", "gdalwarp.exe", sep="\\"), "gdalwarp")

# Raster package:
obj <- raster(tif.file)
obj@crs@projargs <- "+init=epsg:31467"
system.time(reproject.RasterLayer(obj))
## 21 sec

# gdalwarp via FWTools:
mvFlag <- obj@file@nodatavalue
cmd <- paste(gdalwarp, " ", shortPathName(tif.file), " ", shortPathName(set.file.extension(tif.file, ".sdat")), " -of \"SAGA\" -r bilinear -s_srs \"", obj@crs@projargs, "\" -t_srs \"+proj=longlat +datum=WGS84\" -srcnodata ", mvFlag, " -dstnodata -99999", sep="")
system.time(system(cmd))
## 0.5 secs - much better!
