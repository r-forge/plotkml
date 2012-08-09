<!-- This is the project specific website template -->
<!-- It can be changed as liked or replaced by other content -->
<?php

$domain=ereg_replace('[^\.]*\.(.*)$','\1',$_SERVER['HTTP_HOST']);
$group_name=ereg_replace('([^\.]*)\..*$','\1',$_SERVER['HTTP_HOST']);
$themeroot='https://r-forge.r-project.org/themes/rforge/';

echo '<?xml version="1.0" encoding="UTF-8"?>';
?>
<!DOCTYPE html
	PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en   ">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><?php echo $group_name; ?></title>
<link href="<?php echo $themeroot; ?>styles/estilo1.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
.style1 {font-size: small}
.R_code {
	font-family:"Courier New", Courier, monospace;
	font-size: x-small;
	font-style: italic;
}
.caption {
	font-size: x-small;
	font-style: italic;
	padding-bottom: 10px;
}
.R_env {
	font-family:"Courier New", Courier, monospace;
	color:#0000FF;
	font-size: x-small;
	padding-left: 10px;
    white-space: pre;
}
.R_arg {
font-family:"Courier New", Courier, monospace;
color:#FF0000;
font-size: x-small;
}
LI P {
  margin-left:  0pt;
  margin-right: 0pt;
}
-->
    </style>
</head>
<body>
<!-- R-Forge Logo -->
<table border="0" width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td><a href="http://r-forge.r-project.org/"><img src="<?php echo $themeroot; ?>imagesrf/logo.png" border="0" alt="R-Forge Logo" /> </a> </td>
  </tr>
</table>
<!-- get project title  -->
<!-- own website starts here, the following may be changed as you like -->
<?php if ($handle=fopen('http://'.$domain.'/export/projtitl.php?group_name='.$group_name,'r')){
$contents = '';
while (!feof($handle)) {
	$contents .= fread($handle, 8192);
}
fclose($handle);
echo $contents; } ?>
<!-- end of project description -->
<div>
  <h1><strong>Tutorial: installation of plotKML and first steps</strong></h1>
</div>
<hr />
<p class="style1">Prepared by: <a href="http://www.wewur.wur.nl/popups/vcard.aspx?id=HENGL001" target="_blank">Tomislav Hengl</a><br />
  Last update:
  <!-- #BeginDate format:Am1 -->August 9, 2012<!-- #EndDate -->
</p>
<p>This a short review of the plotKML functionality with examples of inputs and outputs. The plotKML (R package) <strong>project summary page</strong> you can find <a href="http://<?php echo $domain; ?>/projects/<?php echo $group_name; ?>/"><strong>here</strong></a>. To learn more about the <strong>Global Soil Information Facilities</strong> (GSIF), visit the <a href="http://www.isric.org/projects/global-soil-information-facilities-gsif" target="_blank">main project page</a>. This tutorial only explains how to quickly plot various spatial and spatio-temporal data in Google Earth. To use the advanced  <strong><a href="00Index.html">functionality</a></strong>, refer to the  plotKML package documentation.</p>
<p>Download the tutorial's  <a href="plotKML-method.html">R code </a>. </p>
<p><em><a name="top" id="top"></a>Table of content:</em></p>
<ul>
  <li><a href="#first_steps">Installation and first steps</a>
    <ul>
      <li><a href="#plotKML_installation">Package installation and main functionality </a></li>
      <li><a href="#external">External applications and environmental settings</a></li>
    </ul>
  </li>
  <li><a href="#examples">Writing sp, raster and derived classes to KML</a>
    <ul>
      <li><a href="#sp_classes">Point, line, polygon and gridded objects </a></li>
      <li><a href="#SpatialPhotoOverlay">Field photographs</a></li>
      <li><a href="#SoilProfileCollection">Soil profile data</a></li>
      <li><a href="#spacetime">Space-time classes (time series, trajectories)</a></li>
    </ul>
  </li>
  <li><a href="#analysis_outputs">Writing analysis outputs to KML</a>
    <ul>
      <li><a href="#RasterBrickTimeSeries">Time-series of images</a></li>
      <li><a href="#SpatialPredictions">Geostatistical mapping</a></li>
      <li><a href="#SpatialSamplingPattern">Spatial sampling patterns</a> </li>
      <li><a href="#spatial_simulations">Spatial simulations</a> </li>
      <li><a href="#SpatialMaxEntOutput">Species distribution modeling </a></li>
    </ul>
  </li>
  <li><a href="#large_data">Working with large data sets </a>
    <ul>
      <li><a href="#map_tiling">Tiling grids </a></li>
      <li><a href="#lapply">Writing objects in loops  </a></li>
    </ul>
  </li>
  <li><a href="#references">References</a></li>
</ul>
<hr />
<table width="100%" border="0" cellspacing="0" cellpadding="10">
  <tr>
    <th scope="col"><div align="left">
      <h2><a name="first_steps" id="first_steps"></a>Installation and first steps </h2>
    </div></th>
    <th scope="col">&nbsp;</th>
    <th scope="col"><div align="right"><a href="#top">^to top</a> </div></th>
  </tr>
</table>
<h3><a name="plotKML_installation" id="plotKML_installation"></a>Package installation and main functionality</h3>
<p><a href="plotKML-package.html">plotKML</a> can be obtained from CRAN. In 2012, plotKML is still being developed and filtered for bugs (until version &gt;1.0), so to obtain the most recent development version of the package run:</p>
<pre class="R_code">&gt; sessionInfo()</pre>
<pre class="R_env">R version 2.14.1 (2011-12-22)<br />Platform: x86_64-pc-mingw32/x64 (64-bit)</pre>
<pre class="R_code">&gt; install.packages(c(&quot;XML&quot;, &quot;RSAGA&quot;, &quot;rgdal&quot;, &quot;raster&quot;, &quot;plyr&quot;, &quot;colorspace&quot;, 
+  &quot;colorRamps&quot;, &quot;spacetime&quot;, &quot;aqp&quot;, &quot;spatstat&quot;, &quot;scales&quot;, &quot;stringr&quot;, &quot;plotrix&quot;, &quot;pixmap&quot;, &quot;dismo&quot;))<br />&gt; download.file(&quot;http://plotkml.r-forge.r-project.org/plotKML_0.*-*.tar.gz&quot;, &quot;plotKML_0.*-*.tar.gz&quot;)<br />&gt; system(&quot;R CMD INSTALL plotKML_0.*-*.tar.gz&quot;)</pre>
<p>where <span class="R_code">0.*-*</span> is the most recent pre-alpha version of this software. Note that, when installing package from source i.e. from R-forge using R CMD, dependencies need to be taken care of before starting the package.</p>
<p>If the installation was successfully, you can start the package by typing:</p>
<p class="R_code">&gt; library(plotKML)</p>
<pre class="R_env">Loading required package: XML
Loading required package: pixmap
Loading required package: colorspace
Loading required package: plotrix
Loading required package: colorRamps
Loading required package: stringr
Loading required package: RColorBrewer
Loading required package: aqp
Loading required package: reshape<br />...<br />plotKML version 0.2-4 (2012-08-09)<br />URL: http://plotkml.r-forge.r-project.org/</pre>
<p>Note that plotKML has many dependencies. It largely builds on the sp and raster-related packages, but it tries to serve a number of packages that provide functionality for space-time data. The drawback of using many packages is that the package takes more time to load, and it is more sensitive to changes in the packages that it extends and depends on. </p>
<h3><a name="external" id="external"></a>External applications and environmental settings </h3>
<p>plotKML uses also a number of optional external packages that need to be installed independently: <a href="http://fwtools.maptools.org">FWTools</a> / GDAL utilities, <a href="http://www.saga-gis.org">SAGA GIS</a>, <a href="http://imagemagick.org" target="_blank">ImageMagick</a>, <a href="http://www.python.org/getit/" target="_blank">Python</a>, and (of course) <a href="http://www.google.com/earth/" target="_blank">Google Earth</a>. Before visualizing any data in plotKML, we advise you to first install any additional R and external software package that can speed up the processing and help you achieve the maximum result. These packages are a requirement and plotKML is suppose to be able to run most of operations without them, however, we recommended that you install and register on your machine all four external software packages. </p>
<p>You can check if R has successfully located the external packages by using the <span class="R_code">plotKML.env()</span> command. For example, if you are running Windows OS, then the output of finding the <a href="plotKML.env.html">paths</a> would look something like this:</p>
<pre class="R_code">&gt; paths()</pre>
<pre class="R_env">Loading required package: animation
Version: ImageMagick 6.6.8-10 2011-03-26 Q16 http://www.imagemagick.org
Located FWTools from the Registry Hive: &quot;C:\PROGRA~2\FWTOOL~1.7&quot;
Located Python from the Registry Hive: &quot;C:\Python27\&quot;
Located SAGA GIS 2.0.8 from the 'Program Files' directory: &quot;C:\PROGRA~1\R\R-214~1.1\library\RSAGA\saga_vc\saga_cmd.exe&quot;
gdalwarp                                gdal_translate
1 &quot;C:\\PROGRA~2\\FWTOOL~1.7\\bin\\gdalwarp.exe&quot; &quot;C:\\PROGRA~2\\FWTOOL~1.7\\bin\\GDAL_T~1.EXE&quot;
convert                     python
1 &quot;C:\\Program Files\\ImageMagick-6.6.8-Q16\\convert.exe&quot; &quot;C:\\Python27\\python.exe&quot;
saga_cmd
1 C:\\PROGRA~1\\R\\R-214~1.1\\library\\RSAGA\\saga_vc\\saga_cmd.exe</pre>
<p>This means that plotKML has managed to locate all external applications, which means that the package can be use up to 100% of its functionality. Note that, <strong>plotKML has to re-locate external applications every time new R session is started</strong>. To permanently preserve the plotKML environmental settings, you either need to save your session, or change settings in the Profile.site.</p>
<p>To access some standard parameter from plotKML, you can point to the plotKML options. For example, to obtain the default coordinate system (<a href="http://spatialreference.org/ref/epsg/4326/" target="_blank">WGS84</a>) used by Google Earth use:</p>
<pre class="R_code">&gt; get(&quot;ref_CRS&quot;, envir = plotKML.opts)</pre>
<pre class="R_env">[1] &quot;+proj=longlat +datum=WGS84&quot;</pre>
<p>To further customize the plotKML options (on-load), consider putting: <span class="R_code">library(plotKML); plotKML.env(..., show.env = FALSE)</span> in your &quot;/etc/Rprofile.site&quot;.</p>
<p>In principle, all KML parsing functions in plotKML are implemented via the corresponding <a href="http://stat.ethz.ch/R-manual/R-patched/library/methods/html/Classes.html" target="_blank">S4 classes</a>. Consequently, all <a href="kml_layer-method.html">kml_layer</a> methods require predefined structure in the data i.e. the data first needs to be converted to corresponding classes.</p>
<table width="100%" border="0" cellspacing="0" cellpadding="10">
  <tr>
    <th scope="col"><div align="left">
      <h2><a name="examples" id="examples"></a>Writing sp, raster and derived classes to KML</h2>
    </div></th>
    <th scope="col">&nbsp;</th>
    <th scope="col"><div align="right"><a href="#top">^to top</a> </div></th>
  </tr>
</table>
<h3><a name="sp_classes" id="sp_classes"></a>Point, line, polygon and gridded objects</h3>
<p>plotKML largely  mimics the existing plotting functionality available for <a href="http://r-spatial.sourceforge.net" target="_blank">spatial data in R</a>; e.g. the <a href="http://r-spatial.sourceforge.net/gallery/" target="_blank">spplot</a> functionality available via the sp package (<a href="http://www.asdar-book.org/" target="_blank">Bivand et al., 2008</a>) and raster plotting functionality available via the raster package (<a href="http://cran.r-project.org/web/packages/raster/vignettes/Raster.pdf">Hijmans, 2012</a>). For example, in the sp package, to plot points we would run:</p>
<pre class="R_code">&gt; data(eberg)
&gt; coordinates(eberg) &lt;- ~X+Y
&gt; proj4string(eberg) &lt;- CRS(&quot;+init=epsg:31467&quot;)
&gt; eberg &lt;- eberg[runif(nrow(eberg))&lt;.2,]<br />&gt; bubble(eberg[&quot;CLYMHT_A&quot;])</pre>
<p>which in plotKML looks like exactly the same: </p>
<pre class="R_code">&gt; plotKML(eberg[&quot;CLYMHT_A&quot;])</pre>
<pre class="R_env">KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  eberg__CLYMHT_A__.kml
Compressing to KMZ...</pre>
<p>But this command then opens the default KML-viewing software, which is in most of the times <a href="http://www.google.com/earth/" target="_blank">Google Earth</a>. Note that, unlike with sp and other spatial packages, before writing object to KML, plotKML tries to reproject any spatial object to the referent coordinate system. For practical purposes, the file and folder names in the KML file will be generated from the object name. The visual elements can be further customized by triggering some of the <a href="aesthetics.html">aesthetics</a> parameters such as:</p>
<ul>
  <li> <span class="R_code">colour</span> &#8212; specifies the color that is used to fill each spatial element (&quot;black&quot; if not specified otherwise);</li>
  <li> <span class="R_code">shape</span> &#8212; specifies  icons to be used to display each spatial element; </li>
  <li><span class="R_code">width</span> &#8212; determines the width  of lines (1 by default),</li>
  <li> <span class="R_code">labels</span> &#8212; specifies text to be added as labels to each spatial element; </li>
  <li><span class="R_code">altitude</span> &#8212; adds altitude to each spatial element (0 if not specified otherwise), </li>
  <li><span class="R_code">size</span> &#8212; specifies size of icons in the display; </li>
  <li><span class="R_code">balloon</span> &#8212; specifies whether to attach attribute data to each placemark; </li>
</ul>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Bubble-type plots in R and the same plot produced using the plotKML shown in Google Earth. See also: <a href="http://r-spatial.sourceforge.net/gallery/" target="_blank">sp gallery</a>.
  </caption>
  <tr>
    <th scope="col"><img src="bubble_plot.png" alt="bubble_plot.png" width="550" /></th>
  </tr>
</table>
<p>This results in a slightly richer aesthetics that the bubble plot in R. To remove the labels and fill in circles using e.g. yellow color only, we can set:</p>
<pre class="R_code">&gt; plotKML(eberg[&quot;CLYMHT_A&quot;], colour_scale=rep(&quot;#FFFF00&quot;, 2), points_names=&quot;&quot;)</pre>
<pre class="R_env">KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  eberg__CLYMHT_A__.kml
Compressing to KMZ... </pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Bubble-type plots in R after turning off labels and using a single colour display <a href="http://r-spatial.sourceforge.net/gallery/" target="_blank"></a>.
  </caption>
  <tr>
    <th scope="col"><img src="bubble_plot_yellow.png" alt="bubble_plot_yellow.png" width="550" /></th>
  </tr>
</table>
<p>Note that, by default, colors need to be submitted in the <a href="http://en.wikipedia.org/wiki/Web_colors" target="_blank">hex</a> format. A number of standard built-in GIS palettes are also <a href="SAGA_pal.html">available</a>.</p>
<p>Lines are by default plotted without any attributes: </p>
<pre class="R_code">&gt; data(eberg_contours)<br />&gt; plotKML(eberg_contours)</pre>
<pre class="R_env">KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  eberg_contours.kml
Compressing to KMZ...</pre>
<p>To plot the attribute values use e.g.:</p>
<pre class="R_code">&gt; plotKML(eberg_contours, colour=Z, altitude=Z)</pre>
<pre class="R_env">KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  eberg_contours.kml
Compressing to KMZ...</pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Contour lines with actual altitudes attached <a href="http://r-spatial.sourceforge.net/gallery/" target="_blank"></a>.
  </caption>
  <tr>
    <th scope="col"><img src="contour_plot.png" alt="contour_plot.png" width="550" /></th>
  </tr>
</table>
<p>When plotting  SpatialPolygons (as with points), both attributes and labels will be plotted by default: </p>
<p class="R_code">&gt; data(eberg_zones)<br />
&gt; plotKML(eberg_zones[&quot;ZONES&quot;])</p>
<pre class="R_env">KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  eberg_zones__ZONES__.kml
Compressing to KMZ...</pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Polygon map <a href="http://r-spatial.sourceforge.net/gallery/" target="_blank"></a>with labels.
  </caption>
  <tr>
    <th scope="col"><img src="polygon_plot.png" alt="polygon_plot.png" width="550" /></th>
  </tr>
</table>
<p>To a polygon map plot, you can also attach some attribute information vai the <span class="R_code">altitude</span> parameter, which will produce visualizations similar to the ones produced by the <a href="http://www.graphearth.com/" target="_blank">GraphEarth</a> software: </p>
<pre class="R_code">&gt; length(eberg_zones)</pre>
<pre class="R_env">[1] 11</pre>
<pre class="R_code">&gt; plotKML(eberg_zones[&quot;ZONES&quot;], altitude=runif(length(eberg_zones))*500)</pre>
<pre class="R_env">KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  eberg_zones__ZONES__.kml
Compressing to KMZ...
</pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Polygon map <a href="http://r-spatial.sourceforge.net/gallery/" target="_blank"></a>with attributes attached as altitude.
  </caption>
  <tr>
    <th scope="col"><img src="polygon_altitude_plot.png" alt="polygon_altitude_plot.png" width="550" /></th>
  </tr>
</table>
<p>To plot <span class="R_code">RasterLayer</span>, <span class="R_code">SpatialPixelsDataFrame</span>, and/or <span class="R_code">SpatialGridDataFrame</span>-class objects, you again need to specify the target layer: </p>
<pre class="R_code">&gt; data(eberg_grid)
&gt; gridded(eberg_grid) &lt;- ~x+y
&gt; proj4string(eberg_grid) &lt;- CRS(&quot;+init=epsg:31467&quot;)
&gt; data(SAGA_pal)<br />&gt; plotKML(eberg_grid[&quot;TWISRT6&quot;], colour_scale = SAGA_pal[[1]])</pre>
<pre class="R_env">KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  eberg_grid__TWISRT6__.kml
Compressing to KMZ...</pre>
<p>This figure basically mimics SAGA GIS (<a href="http://saga-gis.org/en/about/references.html" target="_blank">Böhner et al., 2006</a>) because it shows a DEM parameter derived in SAGA GIS (SAGA Topographic Wetness Index), and it uses  the default SAGA GIS legend.</p>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: SAGA GIS-derived Topographic Wetness Index visualized in Google Earth.
  </caption>
  <tr>
    <th scope="col"><img src="plot_pixels.png" alt="plot_pixels.png" width="550" /></th>
  </tr>
</table>
<p>To plot a factor-type map, you will also need attach an appropriate color legend. To plot for example land cover classes we can use:</p>
<pre class="R_code">&gt; eberg_grid$LNCCOR6 &lt;- as.factor(paste(eberg_grid$LNCCOR6))<br />&gt; levels(eberg_grid$LNCCOR6)</pre>
<pre class="R_env">[1] &quot;112 - Discontinuous urban fabric&quot; 
[2] &quot;211 - Non-irrigated arable land&quot; 
[3] &quot;231 - Pastures&quot; 
[4] &quot;242 - Complex cultivation patterns&quot;
[5] &quot;311 - Broad-leaved forest&quot; 
[6] &quot;312 - Coniferous forest&quot; 
[7] &quot;313 - Mixed forest&quot;
</pre>
<p>As you can notice, these are the classes from the <a href="http://www.eea.europa.eu/data-and-maps/data/corine-land-cover-2006-raster-1" target="_parent">Corine Land Cover 2006</a> map for Europe. We can use the built-in legend for the land cover classes:</p>
<pre class="R_code">&gt; data(worldgrids_pal)
&gt; pal = as.character(worldgrids_pal[&quot;corine2k&quot;][[1]][c(1,11,13,14,16,17,18)])
&gt; pal</pre>
<pre class="R_env">&quot;#E5481B&quot; &quot;#EEEB9A&quot; &quot;#E0DC45&quot; &quot;#F2D442&quot; &quot;#6BBB4A&quot; &quot;#00A046&quot; &quot;#46AF48&quot;</pre>
<pre class="R_code">&gt; plotKML(eberg_grid[&quot;LNCCOR6&quot;], colour_scale=pal)</pre>
<pre class="R_env">KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  eberg_grid__LNCCOR6__.kml</pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: <a href="http://www.eea.europa.eu/data-and-maps/data/corine-land-cover-2006-raster-1" target="_blank">CORINE Land Cover classes</a> plotted in Google Earth with legend added as a screen overlay.
  </caption>
  <tr>
    <th scope="col"><img src="plot_factorVar.png" alt="plot_factorVar.png" width="550" /></th>
  </tr>
</table>
<h3><a name="SpatialPhotoOverlay" id="SpatialPhotoOverlay"></a>Field photographs </h3>
<p>plotKML can also be used to visualize field photographs of e.g. soil profiles, trees, land cover and similar. This possible via the class &quot;<a href="layer.SpatialPhotoOverlay.html">SpatialPhotoOverlay</a>&quot;. If you have a photograph that can be georeferenced, you can upload it to <a href="http://commons.wikimedia.org/wiki/Special:UploadWizard" target="_blank">WikiMedia</a>, and then create an object of class SpatialPhotoOverlay and visualize it from R by running:</p>
<pre class="R_code">&gt; imagename = &quot;Soil_monolith.jpg&quot;<br />&gt; x1 &lt;- getWikiMedia.ImageInfo(imagename)
&gt; sm &lt;- spPhoto(filename = x1$url$url, exif.info = x1$metadata)
&gt; str(sm)</pre>
<pre class="R_env">  Formal class 'SpatialPhotoOverlay' [package &quot;plotKML&quot;] with 5 slots
   ..@ filename    : chr &quot;http://upload.wikimedia.org/wikipedia/commons/3/3d/Soil_monolith.jpg&quot;
   ..@ pixmap      :Formal class 'pixmapRGB' [package &quot;pixmap&quot;] with 8 slots
   .. .. ..@ red     : num[0 , 0 ] 
   .. .. ..@ green   : num[0 , 0 ] 
   .. .. ..@ blue    : num[0 , 0 ] 
   .. .. ..@ channels: chr [1:3] &quot;red&quot; &quot;green&quot; &quot;blue&quot;
   .. .. ..@ size    : int [1:2] 0 0
   .. .. ..@ cellres : num [1:2] NaN NaN
   .. .. ..@ bbox    : num [1:4] 0 0 0 0
   .. .. ..@ bbcent  : logi FALSE
   ..@ exif.info   :List of 21
   .. ..$ ImageWidth               : num 1013
   .. ..$ ImageLength              : chr &quot;4952&quot;
   .. ..$ Compression              : chr &quot;1&quot;
   .. ..$ PhotometricInterpretation: chr &quot;2&quot;
   .. ..$ ImageDescription         : chr &quot;image description                &quot;
   .. ..$ Orientation              : chr &quot;1&quot;
   .. ..$ SamplesPerPixel          : chr &quot;3&quot;
   .. ..$ XResolution              : chr &quot;1000000/10000&quot;
   .. ..$ YResolution              : chr &quot;1000000/10000&quot;
   .. ..$ ResolutionUnit           : chr &quot;2&quot;
   .. ..$ Software                 : chr &quot;Adobe Photoshop CS5 Windows&quot;
   .. ..$ DateTime                 : chr &quot;2011-05-24T11:39:04Z&quot;
   .. ..$ ColorSpace               : chr &quot;1&quot;
   .. ..$ MEDIAWIKI_EXIF_VERSION   : chr &quot;1&quot;
   .. ..$ GPSLongitude             : chr &quot;5.6657&quot;
   .. ..$ GPSLatitude              : chr &quot;51.9871&quot;
   .. ..$ ImageHeight              : num 4640
   .. ..$ GPSAltitude              : num 0
   .. ..$ ExposureTime             : chr &quot;&quot;
   .. ..$ FocalLength              : chr &quot;50 mm&quot;
   .. ..$ Flash                    : chr &quot;No Flash&quot;
   ..@ PhotoOverlay:List of 11
   .. ..$ rotation : num 0
   .. ..$ leftFov  : num -6.55
   .. ..$ rightFov : num 6.55
   .. ..$ bottomFov: num -30
   .. ..$ topFov   : num 30
   .. ..$ near     : num 50
   .. ..$ shape    : Factor w/ 1 level &quot;rectangle&quot;: 1
   .. ..$ range    : num 1000
   .. ..$ tilt     : num 90
   .. ..$ heading  : num 0
   .. ..$ roll     : num 0
   ..@ sp          :Formal class 'SpatialPoints' [package &quot;sp&quot;] with 3 slots
   .. .. ..@ coords     : num [1, 1:3] 5.67 51.99 0
   .. .. .. ..- attr(*, &quot;dimnames&quot;)=List of 2
   .. .. .. .. ..$ : NULL
   .. .. .. .. ..$ : chr [1:3] &quot;lon&quot; &quot;lat&quot; &quot;alt&quot;
   .. .. ..@ bbox       : num [1:3, 1:2] 5.67 51.99 0 5.67 51.99 ...
   .. .. .. ..- attr(*, &quot;dimnames&quot;)=List of 2
   .. .. .. .. ..$ : chr [1:3] &quot;lon&quot; &quot;lat&quot; &quot;alt&quot;
   .. .. .. .. ..$ : chr [1:2] &quot;min&quot; &quot;max&quot;
   .. .. ..@ proj4string:Formal class 'CRS' [package &quot;sp&quot;] with 1 slots
   .. .. .. .. ..@ projargs: chr &quot; +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0&quot;</pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Soil profile photograph with all <a href="http://www.sno.phy.queensu.ca/~phil/exiftool/" target="_blank">EXIF</a> information obtained via the <a href="http://www.mediawiki.org/wiki/API" target="_blank">WikiMedia API</a>.
  </caption>
  <tr>
    <th scope="col"><img src="photo_overlay.png" alt="photo_overlay.png" width="550" /></th>
  </tr>
</table>
<h3><a name="SoilProfileCollection" id="SoilProfileCollection"></a>Soil profile data</h3>
<p>Via the  <a href="http://CRAN.r-project.org/package=aqp" target="_blank">aqp</a> package, we can construct &quot;<a href="cran.r-project.org/web/packages/aqp/" target="_blank">SoilProfile</a>&quot;-class objects that can also  be visualized via plotKML as 3D objects. Soil profiles are 3D samples of soil body, hence we need to attach elevation to different depths to be able to visualize soil profile data in Google Earth. This is an example:</p>
<pre class="R_code">&gt; require(aqp)
&gt; lon = 3.90; lat = 7.50; id = &quot;ISRIC:NG0017&quot;; FAO1988 = &quot;LXp&quot;<br />&gt; top = c(0, 18, 36, 65, 87, 127) 
&gt; bottom = c(18, 36, 65, 87, 127, 181)
&gt; ORCDRC = c(18.4, 4.4, 3.6, 3.6, 3.2, 1.2)
&gt; hue = c(&quot;7.5YR&quot;, &quot;7.5YR&quot;, &quot;2.5YR&quot;, &quot;5YR&quot;, &quot;5YR&quot;, &quot;10YR&quot;)
&gt; value = c(3, 4, 5, 5, 5, 7); chroma = c(2, 4, 6, 8, 4, 3)
&gt; prof1 &lt;- join(data.frame(id, top, bottom, ORCDRC, hue, value, chroma), data.frame(id, lon, lat, FAO1988), type='inner')</pre>
<pre class="R_env">Joining by: id</pre>
<pre class="R_code">&gt; prof1$soil_color &lt;- with(prof1, munsell2rgb(hue, value, chroma))
&gt; depths(prof1) &lt;- id ~ top + bottom
&gt; site(prof1) &lt;- ~ lon + lat + FAO1988 
&gt; coordinates(prof1) &lt;- ~ lon + lat
&gt; proj4string(prof1) &lt;- CRS(&quot;+proj=longlat +datum=WGS84&quot;)
&gt; prof1</pre>
<pre class="R_env">Object of class SoilProfileCollection
Number of profiles: 1</pre>
<pre class="R_env">Horizon attributes:
id top bottom ORCDRC   hue value chroma soil_color
1 ISRIC:NG0017   0     18   18.4 7.5YR     3      2  #584537FF
2 ISRIC:NG0017  18     36    4.4 7.5YR     4      4  #7E5A3BFF
3 ISRIC:NG0017  36     65    3.6 2.5YR     5      6  #A96C4FFF
4 ISRIC:NG0017  65     87    3.6   5YR     5      8  #B06A32FF
5 ISRIC:NG0017  87    127    3.2   5YR     5      4  #9A7359FF
6 ISRIC:NG0017 127    181    1.2  10YR     7      3  #C4AC8CFF</pre>
<pre class="R_env">Sampling site attributes:
id FAO1988
1 ISRIC:NG0017     LXp</pre>
<pre class="R_env">Spatial Data:
min max
lon 3.9 3.9
lat 7.5 7.5
CRS arguments:
 +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0</pre>
<pre class="R_code">&gt; plotKML(prof1, var.name=&quot;ORCDRC&quot;, color.name=&quot;soil_color&quot;)</pre>
<pre class="R_env">KML file header opened for parsing...
Parsing to KML...
Closing  prof1.kml
Compressing to KMZ... </pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Soil profile description data shown as a block. The soil colors represent exactly the colors estimated from the <a href="http://casoilresource.lawr.ucdavis.edu/drupal/node/201" target="_blank">Munsell color chart</a> values.
  </caption>
  <tr>
    <th scope="col"><img src="soil_profile_plot.png" alt="soil_profile_plot.png" width="550" /></th>
  </tr>
</table>
<h3><a name="spacetime" id="spacetime"></a>Space-time classes (time series, trajectories)</h3>
<p>Spatial classes from the <a href="http://cran.r-project.org/web/packages/sp/" target="_blank">sp</a> package can be extended to spatio-temporal classes available via the package <a href="http://cran.r-project.org/web/packages/spacetime/" target="_blank">spacetime</a> (<a href="http://cran.r-project.org/web/packages/spacetime/spacetime.pdf">Pebesma, 2012?</a>). The next two examples show how to visualize irregular  point observations  and trajectory-type data (cycling log). See also further examples with the &quot;<a href="RasterBrickTimeSeries-class.html">RasterBrickTimeSeries</a>&quot; class.</p>
<p>To visualize time series of  measurements at meteorological stations you need to format the objects so they are of type <a href="http://cran.r-project.org/web/packages/spacetime/" target="_blank">STIDF</a> (Space-time Irregular Data Frame, or unstructured spatio-temporal data) class:</p>
<pre class="R_code">&gt; data(HRtemp08)
&gt; HRtemp08$ctime &lt;- as.POSIXct(HRtemp08$DATE, format=&quot;%Y-%m-%dT%H:%M:%SZ&quot;)
&gt; library(spacetime)
&gt; sp &lt;- SpatialPoints(HRtemp08[,c(&quot;Lon&quot;,&quot;Lat&quot;)])
&gt; proj4string(sp) &lt;- CRS(&quot;+proj=longlat +datum=WGS84&quot;)
&gt; HRtemp08.st &lt;- STIDF(sp, time = HRtemp08$ctime, data = HRtemp08[,c(&quot;NAME&quot;,&quot;TEMP&quot;)])        
&gt; HRtemp08_jan &lt;- HRtemp08.st[1:500]
&gt; str(HRtemp08_jan)</pre>
<pre class="R_env">Formal class 'STIDF' [package &quot;spacetime&quot;] with 3 slots
..@ data:'data.frame':        500 obs. of  2 variables:
.. ..$ NAME: Factor w/ 158 levels &quot;&lt;c3&gt;&lt;88&gt;akovec&quot;,..: 17 50 81 83 84 82 85 86 88 89 ...
.. ..$ TEMP: num [1:500] -3.5 -1.25 -4 NA 2.58 ...
..@ sp  :Formal class 'SpatialPoints' [package &quot;sp&quot;] with 3 slots
.. .. ..@ coords     : num [1:500, 1:2] 17.2 15.6 17.4 15.5 13.6 ...
.. .. .. ..- attr(*, &quot;dimnames&quot;)=List of 2
.. .. .. .. ..$ : NULL
.. .. .. .. ..$ : chr [1:2] &quot;Lon&quot; &quot;Lat&quot;
.. .. ..@ bbox       : num [1:2, 1:2] 13.6 42.4 19.4 46.4
.. .. .. ..- attr(*, &quot;dimnames&quot;)=List of 2
.. .. .. .. ..$ : chr [1:2] &quot;Lon&quot; &quot;Lat&quot;
.. .. .. .. ..$ : chr [1:2] &quot;min&quot; &quot;max&quot;
.. .. ..@ proj4string:Formal class 'CRS' [package &quot;sp&quot;] with 1 slots
.. .. .. .. ..@ projargs: chr &quot; +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0&quot;
..@ time:An ‘xts’ object from 2008-01-01 01:00:00 to 2008-01-04 01:00:00 containing:
Data: int [1:500, 1] 298 433 916 1198 1683 2010 2526 2932 2966 3327 ...
Indexed by objects of class: [POSIXct,POSIXt] TZ: 
xts Attributes: 
List of 3
.. ..$ tclass        : chr [1:2] &quot;POSIXct&quot; &quot;POSIXt&quot;
.. ..$ tzone         : chr &quot;&quot;
.. ..$ timeIsInterval: logi FALSE </pre>
<pre class="R_code">&gt; plotKML(HRtemp08_jan[,,&quot;TEMP&quot;], dtime = 24*3600)</pre>
<pre class="R_env">KML file header opened for parsing...
Parsing to KML...
Closing  HRtemp08_jan_,_,__TEMP__.kml
Compressing to KMZ...</pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Time-series of meteorological measurements.
  </caption>
  <tr>
    <th scope="col"><img src="plot_STIDF.png" alt="plot_STIDF.png" width="550" /></th>
  </tr>
</table>
To visualize spatial trajectories, the data needs to be formatted in the <a href="http://cran.r-project.org/web/packages/spacetime/" target="_blank">STTDF</a> (Spacetime Trajectory Data Frame) class:
<pre class="R_code">&gt; data(gpxbtour)
&gt; gpxbtour$ctime &lt;- as.POSIXct(gpxbtour$time, format=&quot;%Y-%m-%dT%H:%M:%SZ&quot;)
&gt; coordinates(gpxbtour) &lt;- ~lon+lat
&gt; proj4string(gpxbtour) &lt;- CRS(&quot;+proj=longlat +datum=WGS84&quot;)
&gt; library(fossil)
&gt; xy &lt;- as.list(data.frame(t(coordinates(gpxbtour))))
&gt; gpxbtour$dist.km &lt;- sapply(xy, function(x) { deg.dist(long1=x[1], lat1=x[2], long2=xy[[1]][1], lat2=xy[[1]][2]) } )<br />&gt; library(spacetime)
&gt; library(adehabitat)</pre>
<pre class="R_env">Loading required package: ade4</pre>
<pre class="R_env">Attaching package: ‘ade4’</pre>
<pre class="R_env">...</pre>
<pre class="R_env">Attaching package: ‘adehabitat’</pre>
<pre class="R_code">&gt; gpx.ltraj &lt;- as.ltraj(coordinates(gpxbtour), gpxbtour$ctime, id = &quot;th&quot;)
&gt; gpx.st &lt;- as(gpx.ltraj, &quot;STTDF&quot;)
&gt; gpx.st$speed &lt;- gpxbtour$speed
&gt; gpx.st@sp@proj4string &lt;- CRS(&quot;+proj=longlat +datum=WGS84&quot;)
&gt; str(gpx.st)</pre>
<pre class="R_env">Formal class 'STTDF' [package &quot;spacetime&quot;] with 4 slots
..@ data:'data.frame':        3228 obs. of  13 variables:
.. ..$ x        : num [1:3228] 5.75 5.75 5.75 5.75 5.75 ...
.. ..$ y        : num [1:3228] 52 52 52 52 52 ...
.. ..$ date     : POSIXct[1:3228], format: &quot;2010-06-25 10:35:29&quot; &quot;2010-06-25 10:35:34&quot; &quot;2010-06-25 10:35:37&quot; ...
.. ..$ dx       : num [1:3228] 0.000466 0.000282 0.00031 0.000403 0.000309 ...
.. ..$ dy       : num [1:3228] -9.5e-05 -7.0e-05 -5.8e-05 -5.5e-05 -4.9e-05 ...
.. ..$ dist     : num [1:3228] 0.000476 0.000291 0.000315 0.000407 0.000313 ...
.. ..$ dt       : num [1:3228] 5 3 3 4 3 4 3 3 3 3 ...
.. ..$ R2n      : num [1:3228] 0.00 2.26e-07 5.87e-07 1.17e-06 2.21e-06 ...
.. ..$ abs.angle: num [1:3228] -0.201 -0.243 -0.185 -0.136 -0.157 ...
.. ..$ rel.angle: num [1:3228] NA -0.0422 0.0584 0.0493 -0.0216 ...
.. ..$ burst    : Factor w/ 1 level &quot;th&quot;: 1 1 1 1 1 1 1 1 1 1 ...
.. ..$ id       : Factor w/ 1 level &quot;th&quot;: 1 1 1 1 1 1 1 1 1 1 ...
.. ..$ speed    : num [1:3228] 23.6 23.1 24 24.9 26.1 ...
.. ..- attr(*, &quot;id&quot;)= chr &quot;th&quot;
.. ..- attr(*, &quot;burst&quot;)= chr &quot;th&quot;
..@ traj:List of 1
.. ..$ :Formal class 'STI' [package &quot;spacetime&quot;] with 2 slots
.. .. .. ..@ sp  :Formal class 'SpatialPoints' [package &quot;sp&quot;] with 3 slots
.. .. .. .. .. ..@ coords     : num [1:3228, 1:2] 5.75 5.75 5.75 5.75 5.75 ...
.. .. .. .. .. .. ..- attr(*, &quot;dimnames&quot;)=List of 2
.. .. .. .. .. .. .. ..$ : NULL
.. .. .. .. .. .. .. ..$ : chr [1:2] &quot;x&quot; &quot;y&quot;
.. .. .. .. .. ..@ bbox       : num [1:2, 1:2] 5.75 51.9 7.6 52.04
.. .. .. .. .. .. ..- attr(*, &quot;dimnames&quot;)=List of 2
.. .. .. .. .. .. .. ..$ : chr [1:2] &quot;x&quot; &quot;y&quot;
.. .. .. .. .. .. .. ..$ : chr [1:2] &quot;min&quot; &quot;max&quot;
.. .. .. .. .. ..@ proj4string:Formal class 'CRS' [package &quot;sp&quot;] with 1 slots
.. .. .. .. .. .. .. ..@ projargs: chr NA
.. .. .. ..@ time:An ‘xts’ object from 2010-06-25 10:35:29 to 2010-06-25 16:49:56 containing:
Data: int [1:3228, 1] 1 2 3 4 5 6 7 8 9 10 ...
Indexed by objects of class: [POSIXct,POSIXt] TZ: 
xts Attributes: 
List of 3
.. .. .. .. ..$ tclass        : chr [1:2] &quot;POSIXct&quot; &quot;POSIXt&quot;
.. .. .. .. ..$ tzone         : chr &quot;&quot;
.. .. .. .. ..$ timeIsInterval: logi FALSE
..@ sp  :Formal class 'SpatialPoints' [package &quot;sp&quot;] with 3 slots
.. .. ..@ coords     : num [1:2, 1:2] 5.75 7.6 51.9 52.04
.. .. .. ..- attr(*, &quot;dimnames&quot;)=List of 2
.. .. .. .. ..$ : NULL
.. .. .. .. ..$ : chr [1:2] &quot;coords.x1&quot; &quot;coords.x2&quot;
.. .. ..@ bbox       : num [1:2, 1:2] 5.75 51.9 7.6 52.04
.. .. .. ..- attr(*, &quot;dimnames&quot;)=List of 2
.. .. .. .. ..$ : chr [1:2] &quot;coords.x1&quot; &quot;coords.x2&quot;
.. .. .. .. ..$ : chr [1:2] &quot;min&quot; &quot;max&quot;
.. .. ..@ proj4string:Formal class 'CRS' [package &quot;sp&quot;] with 1 slots
.. .. .. .. ..@ projargs: chr &quot; +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0&quot;
..@ time:An ‘xts’ object from 2010-06-25 10:35:29 to 2010-06-25 16:49:56 containing:
Data: int [1:2, 1] 1 2
Indexed by objects of class: [POSIXct,POSIXt] TZ: 
xts Attributes: 
List of 3
.. ..$ tclass        : chr [1:2] &quot;POSIXct&quot; &quot;POSIXt&quot;
.. ..$ tzone         : chr &quot;&quot;
.. ..$ timeIsInterval: logi FALSE
</pre>
<pre class="R_code">&gt; plotKML(gpx.st, colour=&quot;speed&quot;)</pre>
<pre class="R_env">KML file header opened for parsing...
Parsing to KML...
Closing  gpx.st.kml
Compressing to KMZ...</pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Movemement trajectory (cycling path) with  vertices (GPS logs). In this case the cycling speed has been added as a color variable.
  </caption>
  <tr>
    <th scope="col"><img src="plot_ltraj.png" alt="plot_ltraj.png" width="550" /></th>
  </tr>
</table>
<h3><a name="SpatialMetadata" id="SpatialMetadata"></a>Spatial metadata </h3>
<p>plotKML offers a set of simple functions such as <a href="spMetadata-method.html">spMetadata</a>, that allow preparation, automated generation and export of spatial metadata. It uses the The Federal Geographic Data Committee (<a href="http://www.fgdc.gov/metadata/" target="_blank">FGDC</a>) metadata XML standards to save and parse the metadata into the KML files. These metadata can then be added to the plotKML plot via the <span class="R_code">metadata</span> argument. This is an example with the <a href="http://plotkml.r-forge.r-project.org/eberg.html">Eberg&ouml;tzen</a> case study: </p>
<pre class="R_code">&gt; eberg.md &lt;- spMetadata(eberg, xml.file=system.file(&quot;eberg.xml&quot;, package=&quot;plotKML&quot;), Target_variable=&quot;SNDMHT_A&quot;)</pre>
<pre class="R_env">Reading the metadata file: C:/Program Files/R/R-2.14.1/library/plotKML/eberg.xml
Generating metadata...
Estimating the bounding box coordinates...
Reprojecting to +proj=longlat +datum=WGS84 ...</pre>
<pre class="R_code">&gt; str(eberg.md)</pre>
<pre class="R_env">Formal class 'SpatialMetadata' [package &quot;.GlobalEnv&quot;] with 4 slots
..@ xml        :Classes 'XMLInternalDocument', 'XMLAbstractDocument', 'oldClass' &lt;externalptr&gt; 
..@ field.names: chr [1:93] &quot;Attribute_accuracy_report&quot; &quot;Completeness_Report&quot; &quot;Process_Date&quot; &quot;Process_Description&quot; ...
..@ palette    :Formal class 'sp.palette' [package &quot;.GlobalEnv&quot;] with 5 slots
.. .. ..@ type  : chr &quot;numeric&quot;
.. .. ..@ bounds: num [1:177] 4.06 4.56 5.06 5.56 6.06 ...
.. .. ..@ color : chr [1:176] &quot;#2C7BB6&quot; &quot;#2F7DB7&quot; &quot;#327FB8&quot; &quot;#3581B9&quot; ...
.. .. ..@ names : chr [1:176] &quot;4.31&quot; &quot;4.81&quot; &quot;5.31&quot; &quot;5.81&quot; ...
.. .. ..@ icons : chr [1:176] &quot;&quot; &quot;&quot; &quot;&quot; &quot;&quot; ...
..@ sp         :Formal class 'Spatial' [package &quot;sp&quot;] with 2 slots
.. .. ..@ bbox       : num [1:2, 1:2] 3569323 5707618 3580992 5718874
.. .. .. ..- attr(*, &quot;dimnames&quot;)=List of 2
.. .. .. .. ..$ : chr [1:2] &quot;X&quot; &quot;Y&quot;
.. .. .. .. ..$ : chr [1:2] &quot;min&quot; &quot;max&quot;
.. .. ..@ proj4string:Formal class 'CRS' [package &quot;sp&quot;] with 1 slots
.. .. .. .. ..@ projargs: chr &quot; +init=epsg:31467 +proj=tmerc +lat_0=0 +lon_0=9 +k=1 +x_0=3500000 +y_0=0 | __truncated__&gt;
</pre>
<pre class="R_code">&gt; plotKML(eberg[&quot;CLYMHT_A&quot;], metadata=eberg.md)</pre>
<pre class="R_env">Plotting the first variable on the list
KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  eberg__CLYMHT_A__.kml
Compressing to KMZ...
</pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Adding some basic metadata to an object plot.
  </caption>
  <tr>
    <th scope="col"><img src="plot_metadata.png" alt="plot_metadata.png" width="550" /></th>
  </tr>
</table>
<p>&nbsp;</p>
<table width="100%" border="0" cellspacing="0" cellpadding="10">
  <tr>
    <th scope="col"><div align="left">
      <h2><a name="analysis_outputs" id="analysis_outputs"></a>Writing analysis outputs to KML</h2>
    </div></th>
    <th scope="col">&nbsp;</th>
    <th scope="col"><div align="right"><a href="#top">^to top</a> </div></th>
  </tr>
</table>
<p>plotKML can be used to only to visualize spatial and spatio-temporal classes, but also the results of complex spatial analysis. In this case the package will plot a series of layers and attach screen overlays, to allow direct interpretation of the analysis results. Such visualization is also implemented via specific S4 classes: &quot;<a href="RasterBrickTimeSeries-class.html">RasterBrickTimeSeries</a>&quot;, &quot;<a href="SpatialPredictions-class.html">SpatialPredictions</a>&quot;, &quot;<a href="SpatialSamplingPattern-class.html" target="_blank">SpatialSamplingPattern</a>&quot;, &quot;<a href="RasterBrickSimulations-class.html">RasterBrickSimulations</a>&quot;, &quot;<a href="SpatialVectorsSimulations-class.html">SpatialVectorsSimulations</a>&quot;, &quot;<a href="SpatialMaxEntOutput-class.html">SpatialMaxEntOutput</a>&quot; and similar. To further customize visualizations consider combining the lower level functions <span class="R_code">kml_open</span>, <span class="R_code">kml_layer</span>, <span class="R_code">kml_close</span>, <span class="R_code">kml_compress</span>, <span class="R_code">kml_screen</span> into your own wrapper function.</p>
<h3><a name="RasterBrickTimeSeries" id="RasterBrickTimeSeries"></a>Time-series of images</h3>
<p>Time series of images of the same variable can be imported into R as &quot;<a href="RasterBrickTimeSeries-class.html">RasterBrickTimeSeries</a>&quot;. This following example shows how to  visualize a time series of MODIS Land Surface Temperature (<a href="LST.html">LST</a>) images. These first need to reprojected and converted to a RasterBrick class:</p>
<pre class="R_code">&gt; data(LST)
&gt; gridded(LST) &lt;- ~x+y
&gt; proj4string(LST) &lt;- CRS(&quot;+proj=utm +zone=33 +datum=WGS84 +units=m&quot;)
&gt; dates &lt;- sapply(strsplit(names(LST), &quot;LST&quot;), function(x){x[[2]]})
&gt; datesf &lt;- format(as.Date(dates, &quot;%Y_%m_%d&quot;), &quot;%Y-%m-%dT%H:%M:%SZ&quot;)
&gt; TimeSpan.begin = as.POSIXct(unclass(as.POSIXct(datesf))-4*24*60*60, origin=&quot;1970-01-01&quot;) 
&gt; TimeSpan.end = as.POSIXct(unclass(as.POSIXct(datesf))+4*24*60*60, origin=&quot;1970-01-01&quot;)
&gt; LST_ll &lt;- reproject(LST)</pre>
<pre class="R_env">Reprojecting to +proj=longlat +datum=WGS84 ...
...
Reprojecting to +proj=longlat +datum=WGS84 ...</pre>
<pre class="R_code">&gt; pnts &lt;- HRtemp08[which(HRtemp08$NAME==&quot;Pazin&quot;)[1],]
&gt; pnts &lt;- rbind(pnts, HRtemp08[which(HRtemp08$NAME==&quot;Crni Lug - NP Risnjak&quot;)[1],])
&gt; pnts &lt;- rbind(pnts, HRtemp08[which(HRtemp08$NAME==&quot;Cres&quot;)[1],])
&gt; coordinates(pnts) &lt;- ~Lon + Lat
&gt; proj4string(pnts) &lt;- CRS(&quot;+proj=longlat +datum=WGS84&quot;)
&gt; LST_ll &lt;- brick(LST_ll)
&gt; LST_ll@title = &quot;Time series of MODIS Land Surface Temperature (8-day mosaics) images&quot;</pre>
<p>In the last step, we can construct an object of class <a href="RasterBrickTimeSeries-class.html">RasterBrickTimeSeries</a> that contains variable name, sample points, rasters and time period: </p>
<pre class="R_code">&gt; LST.ts &lt;- new(&quot;RasterBrickTimeSeries&quot;, variable = &quot;LST&quot;, sampled = pnts, rasters = LST_ll,
+   TimeSpan.begin = TimeSpan.begin, TimeSpan.end = TimeSpan.end)
&gt; data(SAGA_pal)
&gt; plotKML(LST.ts, colour_scale=SAGA_pal[[1]])</pre>
<pre class="R_env">KML file header opened for parsing...
Parsing to KML...
Parsing to KML...
Closing  LST.ts.kml
Compressing to KMZ... </pre>
<p>The output plot allows us to visualize inspect changes in temperatures by scroling the time slidebar in the upper left corner. By clicking on sample points we can also see how the values in the LST images change for each date of interest. </p>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Time series of MODIS LST images with a sample point showing the temporal changes at  a meterological station.
  </caption>
  <tr>
    <th scope="col"><img src="plot_LST.png" alt="plot_LST.png" width="550" /></th>
  </tr>
</table>
<h3><a name="SpatialPredictions" id="SpatialPredictions"></a>Geostatistical mapping</h3>
<p>The objective of geostatistical mapping is to generate spatial predictions of some target variable for a study area of interest. The outputs from geostatistical mapping are usually standard:</p>
<ul>
  <li><em>Observed values</em> (point locations)</li>
  <li><em>Geostatistical model</em> (i.e. a list of fitted parameters)</li>
  <li><em>Predicted values</em> (gridded map)</li>
  <li><em>Results of validation</em> (point locations)</li>
</ul>
<p>These can be presented in plotKML via the &quot;<a href="SpatialPredictions-class.html">SpatialPredictions</a>&quot; class. The following example (based on the GLM-kriging implemented in the <a href="http://gsif.r-forge.r-project.org/" target="_blank">GSIF</a> package) shows how to quickly visualize results of geostatistical mapping via plotKML: </p>
<pre class="R_code">&gt; data(meuse)
&gt; coordinates(meuse) &lt;- ~x+y
&gt; proj4string(meuse) &lt;- CRS(&quot;+init=epsg:28992&quot;)
&gt; data(meuse.grid)
&gt; gridded(meuse.grid) &lt;- ~x+y
&gt; proj4string(meuse.grid) &lt;- CRS(&quot;+init=epsg:28992&quot;)
&gt; library(GSIF)
&gt; omm &lt;- fit.gstatModel(observations = meuse, formulaString = om~dist, family = gaussian(log), covariates = meuse.grid)
&gt; show(omm@regModel)</pre>
<pre class="R_env">Call:  glm(formula = om ~ dist, family = family, data = rmatrix)</pre>
<pre class="R_env">Coefficients:
(Intercept)         dist 
      2.390       -1.871 </pre>
<pre class="R_env">Degrees of Freedom: 152 Total (i.e. Null);  151 Residual
(2 observations deleted due to missingness)
Null Deviance:      1791 
Residual Deviance: 1076         AIC: 738.6 </pre>
<pre class="R_code">&gt; om.rk &lt;- predict(omm, predictionLocations = meuse.grid)</pre>
<pre class="R_env">Generating predictions using the trend model (KED method)...
[using universal kriging]
...
Running 5-fold cross validation...</pre>
<pre class="R_code">&gt; show(om.rk)</pre>
<pre class="R_env">Variable           : om 
Minium value       : 1 
Maximum value      : 17 
Size               : 153 
Total area         : 4964800 
Total area (units) : square-m 
Resolution (x)     : 40 
Resolution (y)     : 40 
Resolution (units) : m 
GLM call formula   : om ~ dist 
Family             : gaussian 
Link function      : log 
Vgm model          : Exp 
Nugget (residual)  : 0.0603 
Sill (residual)    : 0.207 
Range (residual)   : 495 
RMSE (validation)  : 0.3344 
Var explained      : 54.2% 
Effective bytes    : 879 
Compression method : gzip </pre>
<pre class="R_code">&gt; plotKML(om.rk)</pre>
<pre class="R_env">KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  om.rk.kml
Compressing to KMZ...
 </pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Plotting the whole geostatistical mapping project at once: sampling locations, predictions, cross-validation correlation plot, and variograms for residuals and cross-validation residuals.
  </caption>
  <tr>
    <th scope="col"><img src="plot_geostat_mapping.png" alt="plot_geostat_mapping.png" width="550" /></th>
  </tr>
</table>
<h3><a name="SpatialSamplingPattern" id="SpatialSamplingPattern"></a>Spatial Sampling patterns</h3>
<p>Spatial samples can be generated via a number of packages in R (sp, spatstat, spcosa etc). In <a href="http://cran.r-project.org/web/packages/spcosa/" target="_blank">spcosa</a> (<a href="http://dx.doi.org/10.1016/j.cageo.2010.04.005" target="_blank">Walvoort et al, 2010</a>), for example, one can also optimize sampling design to maximize the geographical coverage of the sampling locations:</p>
<pre class="R_code">&gt; library(spcosa)</pre>
<pre class="R_env">Loading required package: rJava
Loading required package: ggplot2
Note: ‘spcosa’ requires Java (&gt;= 6.0), which is available at www.java.com</pre>
<pre class="R_env">Attaching package: ‘spcosa’</pre>
<pre class="R_code">&gt; shpFarmsum &lt;- readOGR(dsn = system.file(&quot;maps&quot;, package = &quot;spcosa&quot;), layer = &quot;farmsum&quot;)</pre>
<pre class="R_env"> OGR data source with driver: ESRI Shapefile 
 Source: &quot;C:/Program Files/R/R-2.14.1/library/spcosa/maps&quot;, layer: &quot;farmsum&quot;
 with 1 features and 4 fields
 Feature type: wkbPolygon with 2 dimensions</pre>
<pre class="R_code">&gt; myStratification &lt;- stratify(shpFarmsum, nStrata = 50)
&gt; mySamplingPattern &lt;- spsample(myStratification, n = 2)
&gt; library(RCurl)
&gt; nl.rd &lt;- getURL(&quot;http://spatialreference.org/ref/sr-org/6781/proj4/&quot;)
&gt; proj4string(mySamplingPattern@sample) &lt;- CRS(nl.rd) 
&gt; sp.domain &lt;- as.SpatialPolygons.SpatialPixels(myStratification@cells)
&gt; sp.domain &lt;- SpatialPolygonsDataFrame(sp.domain, data.frame(ID=as.factor(myStratification@stratumId)), match.ID = FALSE)
&gt; proj4string(sp.domain) &lt;- CRS(nl.rd)
&gt; mySamplingPattern.ssp &lt;- new(&quot;SpatialSamplingPattern&quot;, method = class(mySamplingPattern), 
+  pattern = mySamplingPattern@sample, sp.domain = sp.domain)</pre>
<p>This <a href="SpatialSamplingPattern-class.html" target="_blank">SpatialSamplingPattern</a> object can now be plotted: </p>
<pre class="R_code">&gt; shape = &quot;http://maps.google.com/mapfiles/kml/pal2/icon18.png&quot;<br />&gt; plotKML(mySamplingPattern.ssp, shape = shape)</pre>
<pre class="R_env">KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  mySamplingPattern.ssp.kml
Compressing to KMZ...</pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Visualizing results of sampling optimization produced using the <a href="http://cran.r-project.org/web/packages/spcosa/" target="_blank">spcosa</a> package.
  </caption>
  <tr>
    <th scope="col"><img src="plot_sampling_pattern.png" alt="plot_sampling_pattern.png" width="550" /></th>
  </tr>
</table>
<h3><a name="spatial_simulations" id="spatial_simulations"></a>Spatial simulations </h3>
<p>In some cases, the result of some (geo)statistical model will be realizations i.e. a series of spatial objects with same intrinsic properties. The following two examples show how to visualize such data via plotKML i.e. by putting the outputs of analysis to the &quot;<a href="RasterBrickSimulations-class.html">RasterBrickSimulations</a>&quot; or &quot;<a href="SpatialVectorsSimulations-class.html">SpatialVectorsSimulations</a>&quot; class object.</p>
<p>Consider for example the case with measured elevations for the <a href="baranja.html">Baranja hill</a> case study. This data set contains 6370 precise observations of elevations, which can be used to construct a Digital Elevation Model (DEM). Instead of deriving just one smooth surface, we can model the land surface as a stochastic feature:</p>
<pre class="R_code">&gt; data(barxyz)
&gt; prj = &quot;+proj=tmerc +lat_0=0 +lon_0=18 +k=0.9999 +x_0=6500000 +y_0=0 +ellps=bessel +units...&quot; ... [TRUNCATED] 
&gt; coordinates(barxyz) &lt;- ~x+y
&gt; proj4string(barxyz) &lt;- CRS(prj)
&gt; data(bargrid)
&gt; coordinates(bargrid) &lt;- ~x+y
&gt; gridded(bargrid) &lt;- TRUE
&gt; proj4string(bargrid) &lt;- CRS(prj)
&gt; Z.ovgm &lt;- vgm(psill=1352, model=&quot;Mat&quot;, range=650, nugget=0, kappa=1.2)
&gt; sel &lt;- runif(length(barxyz$Z))&lt;.2  
&gt; sims &lt;- krige(Z~1, barxyz[sel,], bargrid, model=Z.ovgm, nmax=20, nsim=10, debug.level=-1)</pre>
<p class="R_env">  drawing 10 GLS realisations of beta...<br />
  [using conditional Gaussian simulation]<br />
  ...</p>
<pre class="R_code">&gt; t1 &lt;- Line(matrix(c(bargrid@bbox[1,1],bargrid@bbox[1,2],5073012,5073012), ncol=2))
&gt; transect &lt;- SpatialLines(list(Lines(list(t1), ID=&quot;t&quot;)), CRS(prj))
&gt; bardem_sims &lt;- new(&quot;RasterBrickSimulations&quot;, variable = &quot;elevations&quot;,  sampled = transect, realizations = brick(sims))
&gt; data(R_pal)
&gt; plotKML(bardem_sims, colour_scale = R_pal[[4]])</pre>
<pre class="R_env">KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  bardem_sims.kml
Compressing to KMZ...</pre>
<p>The resulting plot can be used to inspect the uncertainty in the multiple equiprobable DEMs. Note also that, by default, plotKML adds a cross-section from the mid point West-East, that allows us to see the probability distributions in vertical dimension.</p>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Multiple equiprobable geostatistical simulations of land surface and associated uncertainty.
  </caption>
  <tr>
    <th scope="col"><img src="plot_RasterBrickSimulations.png" alt="plot_RasterBrickSimulations.png" width="550" /></th>
  </tr>
</table>
<p>Likewise, plotKML can also be used to visualize multiple realizations of vector features via the &quot;<a href="SpatialVectorsSimulations-class.html">SpatialVectorsSimulations</a>&quot; class objects. Here is an example with multiple stream networks derived using geostatistical simulations of DEMs shown previously (see <a href="http://dx.doi.org/10.5194/hess-14-1153-2010">Hengl et al, 2010</a> for more details):</p>
<pre class="R_code">&gt; data(barstr)
&gt; data(bargrid)
&gt; coordinates(bargrid) &lt;- ~ x+y
&gt; gridded(bargrid) &lt;- TRUE
&gt; cell.size = bargrid@grid@cellsize[1]
&gt; bbox = bargrid@bbox
&gt; gridT = GridTopology(cellcentre.offset=bbox[,1], cellsize=c(cell.size,cell.size), <br />+    cells.dim=c(round(abs(diff(bbox[1,])/cell.size), 0), 
+    ncols=round(abs(diff(bbox[2,])/cell.size), 0)))
&gt; bar_sum &lt;- aggregate(gridT, barstr[1:5])<br />&gt; plotKML(bar_sum, grid2poly = TRUE)</pre>

<pre class="R_env">Warning in grid2poly(obs) :
Operation not recommended for large grids (&gt;&gt;1e4 pixels).
Reprojecting to +proj=longlat +datum=WGS84 ...
KML file header opened for parsing...
Parsing to KML...
Reprojecting to +proj=longlat +datum=WGS84 ...
...
Closing  bar_sum.kml
Compressing to KMZ...</pre>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Multiple realizations of equiprobable vector-type features (streams) and the cumulative probability from blue (0) to red (1) colours (gridded).
  </caption>
  <tr>
    <th scope="col"><img src="plot_SpatialVectorsSimulations.png" alt="plot_SpatialVectorsSimulations.png" width="550" /></th>
  </tr>
</table>
<h3><a name="SpatialMaxEntOutput" id="SpatialMaxEntOutput"></a>Species distribution modeling </h3>
<p>A popular method to run the species distribution model to estimate potential distribution of a species is the MaxEnt software. Via the package dismo, one can run the modelling in R, and then visualize results in Google Earth by using:</p>
<pre class="R_code">&gt; data(bigfoot)
&gt; aea.prj &lt;- &quot;+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs&quot;
&gt; coordinates(bigfoot) &lt;- ~Lon+Lat
&gt; proj4string(bigfoot) &lt;- CRS(&quot;+proj=latlon +datum=WGS84&quot;)
&gt; bigfoot.aea &lt;- spTransform(bigfoot, CRS(aea.prj))
&gt; data(USAWgrids)
&gt; gridded(USAWgrids) &lt;- ~s1+s2
&gt; proj4string(USAWgrids) &lt;- CRS(aea.prj)
&gt; bigfoot.aea &lt;- as.ppp(spTransform(bigfoot, CRS(aea.prj)))
&gt; sel.grids &lt;- c(&quot;globedem&quot;,&quot;nlights03&quot;,&quot;sdroads&quot;,&quot;gcarb&quot;,&quot;twi&quot;,&quot;globcov&quot;)
&gt; library(GSIF)
&gt; bigfoot.me &lt;- MaxEnt(bigfoot.aea, USAWgrids, factors='globcov')
&gt; plotKML(bigfoot.smo, colour_scale = R_pal[[&quot;bpy_colors&quot;]], shape = icon)</pre>
<pre class="R_env">KML file header opened for parsing...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Reprojecting to +proj=longlat +datum=WGS84 ...
Parsing to KML...
Closing  bigfoot.smo.kml
Compressing to KMZ...</pre>
<p>Note that the result are two maps: one showing the 'ecological' probability of Bigfoot's niche, and the second map showing the predicted domain (1 or missing) i.e. areas where the occurence of the species based on cross-validation is significant. </p>
<table width="500" border="0" cellspacing="2" cellpadding="4">
  <caption class="caption" align="bottom">
    Fig: Mapping distribution of the bigfoot using the  <a href="http://www.bfro.net/news/google_earth.asp" target="_blank">BigFoot Research Organization</a> (BFRO) data.
  </caption>
  <tr>
    <th scope="col"><img src="plot_SpatialMaxEntOutput.png" alt="plot_SpatialMaxEntOutput.png" width="550" /></th>
  </tr>
</table>
<p>&nbsp;</p>
<table width="100%" border="0" cellspacing="0" cellpadding="10">
  <tr>
    <th scope="col"><div align="left">
      <h2><a name="large_data" id="large_data"></a>Working with large data sets</h2>
    </div></th>
    <th scope="col">&nbsp;</th>
    <th scope="col"><div align="right"><a href="#top">^to top</a> </div></th>
  </tr>
</table>
<p>Visualization of large datasets via plotKML and kml methods is, at the moment, simply do not recommend. Two robust procedures to export larger areas i.e. larger data sets to KML are (a) by simplifying the spatial structure or raster resolution, and (b) by tiling large grids or vector maps to regular blocks and then writing them in a loop. The following two sections provide some general info on how to achieve these.</p>
<h3><a name="map_tiling" id="map_tiling"></a>Tiling grids</h3>
<p><em>** to be continued ** </em></p>
<h3><a name="lapply" id="lapply"></a>Writing objects in loops </h3>
<p><em>** to be continued **</em></p>
<table width="100%" border="0" cellspacing="0" cellpadding="10">
  <tr>
    <th scope="col"><div align="left">
      <h2><a name="references" id="references"></a>References</h2>
    </div></th>
    <th scope="col">&nbsp;</th>
    <th scope="col"><div align="right"><a href="#top">^to top</a> </div></th>
  </tr>
</table>
<ol>
  <li>Bivand, R.S., Pebesma, E.J., and Gómez-Rubio, V., (2008) <a href="http://www.asdar-book.org/"><strong>Applied Spatial Data Analysis with R</strong></a>. Springer, 378 p.</li>
  <li>Böhner, J., McCloy, K. R. and Strobl, J. (Eds), (2006) <a href="http://saga-gis.org/en/about/references.html" target="_blank"><strong>SAGA &#8212; Analysis and Modelling Applications</strong></a>. Göttinger Geographische Abhandlungen, Heft 115. Verlag Erich Goltze GmbH, Göttingen, 117 pp.</li>
  <li>Hengl, T., Heuvelink, G. B. M., van Loon, E. E., (2010) <a href="http://dx.doi.org/10.5194/hess-14-1153-2010">On the uncertainty of stream networks derived from elevation data: the error propagation approach</a>. Hydrology and Earth System Sciences, <strong>14</strong>:1153-1165.</li>
  <li>Hijmans, R.J., Elith, J., (2012) <a href="http://cran.r-project.org/web/packages/dismo/vignettes/sdm.pdf">Species distribution modeling with R</a>. CRAN, Vignette for the dismo package, 72 p.</li>
  <li>Hijmans, R.J., (2012) <a href="http://cran.r-project.org/web/packages/raster/vignettes/Raster.pdf" target="_blank">Introduction to the 'raster' package</a>. Contributed R Achive Network (CRAN), p. 26.</li>
  <li>Pebesma, E., (2012) <a href="http://cran.r-project.org/web/packages/spacetime/spacetime.pdf" target="_blank">Classes and Methods for Spatio-Temporal Data in R</a>. Journal of Statistical Software, in press.</li>
  <li>Walvoort, D.J.J,  Brus, D.J.,  de Gruijter, J.J., (2010)  <a href="http://dx.doi.org/10.1016/j.cageo.2010.04.005">An R package for spatial coverage sampling and random sampling from compact geographical strata by k-means</a>. Computers &amp; Geosciences, <strong>36</strong>(10): 1261-1267.</li>
</ol>
<p>&nbsp; </p>
<hr />
<p><a href="http://www.isric.org" target="_blank"><img src="ISRIC_logo.jpg" alt="ISRIC - World Soil Information" width="363" height="98" border="0" longdesc="http://www.isric.org" /></a></p>
</body>
</html>
