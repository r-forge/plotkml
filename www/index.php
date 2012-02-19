
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
font-style:italic;
font-size: x-small;
}
.R_env {
font-family:"Courier New", Courier, monospace;
color:#0000FF;
font-size: x-small
}
.R_arg {
font-family:"Courier New", Courier, monospace;
color:#FF0000;
font-size: x-small;
}
-->
    </style>
</head>

<body>

<!-- R-Forge Logo -->
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr><td>
<a href="http://r-forge.r-project.org/"><img src="<?php echo $themeroot; ?>imagesrf/logo.png" border="0" alt="R-Forge Logo" /> </a> </td> </tr>
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
  <p>Plotting space-time objects in Google Earth (visualization templates)</p>
</div>
<hr />
<p class="style1">Contact: <a href="http://www.wewur.wur.nl/popups/vcard.aspx?id=HENGL001" target="_blank">Tomislav Hengl</a>, <a href="http://www.landcareresearch.co.nz/research/staff_page.asp?staff_num=2132" target="_blank">Pierre Roudier</a> &amp; <a href="http://casoilresource.lawr.ucdavis.edu/drupal/node/905" target="_blank">Dylan Beaudette</a></p>
<p> This package has been developed as a part of the <a href="http://isric.org/projects/global-soil-information-facilities-gsif" target="_blank">Global Soil Information Facilities</a>, which are developed jointly by the ISRIC Institute and collaborators. ISRIC is a non-profit organization with a mandate to serve the international community as custodian of global soil information and to increase awareness and understanding of the role of soils in major global issues. The <strong>plotKML project summary page</strong> you can find <a href="http://<?php echo $domain; ?>/projects/<?php echo $group_name; ?>/"><strong>here</strong></a>.</p>
<p>See the complete list of <strong><a href="00Index.html">functions</a></strong> and a list of <a href="settings.php"><strong>additional settings</strong></a>. </p>
<p><strong>Installation:</strong></p>
<p>To install this package from R-forge use (runs only on<strong> &gt;= R 2.14</strong>):</p>
<p class="R_code">&gt; install.packages(c(&quot;XML&quot;, &quot;RSAGA&quot;, &quot;rgdal&quot;, &quot;raster&quot;, &quot;plyr&quot;, &quot;colorspace&quot;, &quot;colorRamps&quot;, &quot;spacetime&quot;, &quot;spcosa&quot;, &quot;aqp&quot;, &quot;spatstat&quot;, &quot;ggplot2&quot;, &quot;stringr&quot;)) </p>
<p class="R_code">&gt; install.packages(&quot;plotKML&quot;, repos=c(&quot;http://R-Forge.R-project.org&quot;)) </p>
<p><strong>Documents</strong>:</p>
<ul>
  <li>Poster at UseR 2011: <a href="poster-plotKML-UseR2011.pdf">&quot;plotKML: a framework for visualization of space-time data&quot;</a> (PDF)</li>
</ul>
<hr />
<p>&nbsp;</p>
<table border="0" cellpadding="10" cellspacing="0">
  <tr valign="top">
    <td width="220"><div align="center">
      <p><a href='Fig_eberg_two_aesthetics.jpg'><img src='Fig_eberg_two_aestheticsthumb.jpg' alt='Ebergotzen two aesthetics.png' width='150' height="124" border="0"/></a></p>
      <p class="R_code"><strong><a href="layer.SpatialPoints.html">SpatialPoints</a> </strong> <a href="eberg.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td width="220"><div align="center"><p><a href='Fig_photo_overlay.jpg'><img src='Fig_photo_overlaythumb.jpg' alt='Soil monolith in Google Earth.png' width='150' height="130" border="0"/></a></p>
        <p><span class="R_code"><strong><a href="layer.SpatialPhotoOverlay.html">SpatialPhotoOverlay </a></strong> <a href="af.kmz"></a></span><a href="af.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_monolith.jpg'><img src='Fig_monoliththumb.jpg' alt='GroundPhoto in Google Earth.png' width='129' height="150" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.SpatialPhotoOverlay.html">SpatialPhotoOverlay</a> </strong> <a href="sm.kmz"></a></span><a href="sm.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_soilprofilecollection_hist.jpg'><img src='Fig_soilprofilecollection_histthumb.jpg' alt='SoilProfileCollection histogram in Google Earth.png' width='150' height="124" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.SoilProfileCollection.html">SoilProfileCollection</a> </strong> <a href="ca_bs_8_2.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
        <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_soilprofilecollection_block.jpg'><img src='Fig_soilprofilecollection_blockthumb.jpg' alt='SoilProfileCollection block visualized in Google Earth.png' width='150' height="124" border="0"/></a></p>
        <p><span class="R_code"><strong><a href="layer.SoilProfileCollection.html">SoilProfileCollection</a> </strong> <a href="ca_CEC8_2_block.kmz"> <img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="10">
  <tr valign="top">
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_eberg_lines.jpg'><img src='Fig_eberg_linesthumb.jpg' alt='Ebergotzen contour lines' width='150' height="134" border="0"/></a></p>
      <p class="R_code"> <strong> <a href="layer.SpatialLines.html">SpatialLines</a> </strong> <a href="eberg_contours.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_eberg_polygons.jpg'><img src='Fig_eberg_polygonsthumb.jpg' alt='Ebergotzen soil units polygons.png' width='150' height="124" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.SpatialPolygons.html">SpatialPolygons</a> </strong> <a href="eberg_zones.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_dem_poly.jpg'><img src='Fig_dem_polythumb.jpg' alt='DEM poly in Google Earth' width='150' height="148" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="grid2poly.html">grid2poly</a> </strong> <a href="dem_poly.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_layerRaster_legend.jpg'><img src='Fig_layerRaster_legendthumb.jpg' alt='TWI layerRaster in Google Earth' width='150' height="148" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.Raster.html">Raster</a> </strong> <a href="eberg_grid.kml"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_metadata_GoogleEarth.jpg'><img src='Fig_metadata_GoogleEarththumb.jpg' alt='Metadata in GoogleEarth.png' width='150' height="120" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="spMetadata.html">spMetadata</a> </strong> <a href="eberg_md.kmz"> <img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="10">
  <tr valign="top">
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_gpxtour.jpg'><img src='Fig_gpxtourthumb.jpg' alt='GPX bicycle Wageningen Muenster' width='150' height="150" border="0"/></a></p>
      <p class="R_code"><strong><a href="layer.STIDFtraj.html">STIDFtraj</a> </strong> <a href="gpxbtour_speed.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_STIDF_polygons.jpg'><img src='Fig_STIDF_polygonsthumb.jpg' alt='Spacetime STIDF object polygons.png' width='150' height="139" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.STIDF.html">STIDF Polygons</a> </strong> <a href="nct.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_spacetime_HRtemp08.jpg'><img src='Fig_spacetime_HRtemp08thumb.jpg' alt='Spatiotemporal changes in HRtemp08.png' width='150' height="143" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.STIDF.html">STIDF Points</a> </strong> <a href="HRtemp08_jan.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_time_series_rasters_LST.jpg'><img src='Fig_time_series_rasters_LSTthumb.jpg' alt='Time series of MODIS LST rasters in Google Earth' width='150' height="148" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.RasterBrick.html">RasterBrick</a> </strong> <a href="LST_ll.kml"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3AMetadata_in_GoogleEarth.png.jpg'></a><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_SpatialPredictions_meuse.jpg'><img src='Fig_SpatialPredictions_meusethumb.jpg' alt='SpatialPredictions in Google Earth' width='150' height="162" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="SpatialPredictions-class.html">SpatialPredictions</a> </strong> <a href="om.rk.kml"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
  </tr>
</table>
<table border="0" cellpadding="10" cellspacing="0">
  <tr valign="top">
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_simulations_streams.jpg'><img src='Fig_simulations_streamsthumb.jpg' alt='Simulated streams' width='150' height="150" border="0"/></a></p>
      <p class="R_code"><strong><a href="SpatialVectorsSimulations-class.html">VectorsSimulations</a> </strong> <a href="bar_sum.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_rasterbricksimulations.jpg'><img src='Fig_rasterbricksimulationsthumb.jpg' alt='Rasterbricksimulations' width='150' height="183" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="RasterBrickSimulations-class.html">RasterBrickSimulations</a> </strong> <a href="bardem_sims.kml"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p>&nbsp;</p>
      </div></td>
    <td width="220"><div align="center">
      <p>&nbsp;</p>
      </div></td>
    <td width="220"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3AMetadata_in_GoogleEarth.png.jpg'></a><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='Fig_SpatialPredictions_meuse.jpg'></a></p>
      <p><span class="R_code"><strong><a href="SpatialPredictions-class.html"></a> </strong> <a href="om.rk.kml"></a></span></p>
    </div></td>
  </tr>
</table>
<br />
<hr />
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <th scope="col"><div align="left"><a href="http://www.isric.org" target="_blank"><img src="http://meta.isric.org/images/ISRIC_right.png" alt="ISRIC logo" width="703" height="80" border="0" longdesc="http://www.isric.org" /></a></div></th>
  </tr>
</table>
<p class="style1"> Last update: 
  <!-- #BeginDate format:Am1 -->February 19, 2012<!-- #EndDate -->
| contact: <a href="http://www.wewur.wur.nl/popups/vcard.aspx?id=HENGL001" target="_blank">tom.hengl@wur.nl</a> | <a href="http://www.isric.org">ISRIC</a> - World Soil Information Institute </p>
</body>
</html>
