
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
font-size: x-small
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
<p> This package has been developed as a part of the <a href="http://isric.org/projects/global-soil-information-facilities-gsif" target="_blank">Global Soil Information Facilities</a> project, which is run jointly by the ISRIC Institute and collaborators. ISRIC is a non-profit organization with a mandate to serve the international community as custodian of global soil information and to increase awareness and understanding of the role of soils in major global issues. The <strong>plotKML project summary page</strong> you can find <a href="http://<?php echo $domain; ?>/projects/<?php echo $group_name; ?>/"><strong>here</strong></a>.</p>
<p>See the complete list of <strong><a href="00Index.html">functions</a></strong> and a list of <a href="settings.php"><strong>additional settings</strong></a>. </p>
<p><strong>Documents</strong>:</p>
<ul>
  <li>Poster at UseR 2011: <a href="poster-plotKML-UseR2011.pdf">&quot;plotKML: a framework for visualization of space-time data&quot;</a> (PDF)</li>
</ul>
<hr />
<p>&nbsp;</p>
<table width="1020" border="0" cellspacing="0" cellpadding="10">
  <tr valign="top">
    <td><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3AEbergotzen_two_aesthetics.png.jpg'><img width='240' alt='Ebergotzen two aesthetics.png' src='http://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Ebergotzen_two_aesthetics.png.jpg/240px-Ebergotzen_two_aesthetics.png.jpg'/></a></p>
      <p class="R_code"><strong><a href="layer.SpatialPoints.html">SpatialPoints</a> </strong> <a href="eberg.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
      </div></td>
    <td><div align="center"><p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3ASoil_monolith_in_Google_Earth.png.jpg'><img src='http://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Soil_monolith_in_Google_Earth.png.jpg/240px-Soil_monolith_in_Google_Earth.png.jpg' alt='Soil monolith in Google Earth.png' width='240' border="0"/></a></p>
        <p><span class="R_code"><strong><a href="layer.SpatialPhotoOverlay.html">SpatialPhotoOverlay</a> </strong> <a href="sm.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3AGroundPhoto_in_Google_Earth.png.jpg'><img width='240' alt='GroundPhoto in Google Earth.png' src='http://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/GroundPhoto_in_Google_Earth.png.jpg/240px-GroundPhoto_in_Google_Earth.png.jpg'/></a></p>
      <p><span class="R_code"><strong><a href="layer.SpatialPhotoOverlay.html">SpatialPhotoOverlay</a> </strong> <a href="af.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3ASoilProfileCollection_histogram_in_Google_Earth.png.jpg'><img width='240' alt='SoilProfileCollection histogram in Google Earth.png' src='http://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/SoilProfileCollection_histogram_in_Google_Earth.png.jpg/240px-SoilProfileCollection_histogram_in_Google_Earth.png.jpg'/></a></p>
      <p><span class="R_code"><strong><a href="layer.SoilProfileCollection.html">SoilProfileCollection</a> </strong> <a href="ca_bs_8_2.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td><div align="center">
        <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3ASoilProfileCollection_block_visualized_in_Google_Earth.png.jpg'><img width='240' alt='SoilProfileCollection block visualized in Google Earth.png' src='http://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/SoilProfileCollection_block_visualized_in_Google_Earth.png.jpg/240px-SoilProfileCollection_block_visualized_in_Google_Earth.png.jpg'/></a></p>
        <p><span class="R_code"><strong><a href="layer.SoilProfileCollection.html">SoilProfileCollection</a> </strong> <a href="ca_CEC8_2_block.kmz"> <img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
  </tr>
</table>
<table width="1020" border="0" cellspacing="0" cellpadding="10">
  <tr valign="top">
    <td><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3AEbergotzen_contour_lines.jpg'><img width='240' alt='Ebergotzen contour lines' src='http://upload.wikimedia.org/wikipedia/commons/thumb/5/51/Ebergotzen_contour_lines.jpg/240px-Ebergotzen_contour_lines.jpg'/></a></p>
      <p class="R_code"> <strong> <a href="layer.SpatialLines.html">SpatialLines</a> </strong> <a href="eberg_contours.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3AEbergotzen_soil_units_polygons.png.jpg'><img width='240' alt='Ebergotzen soil units polygons.png' src='http://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Ebergotzen_soil_units_polygons.png.jpg/240px-Ebergotzen_soil_units_polygons.png.jpg'/></a></p>
      <p><span class="R_code"><strong><a href="layer.SpatialPolygons.html">SpatialPolygons</a> </strong> <a href="eberg_zones.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3ADEM_poly_in_Google_Earth.jpg'><img width='240' alt='DEM poly in Google Earth' src='http://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/DEM_poly_in_Google_Earth.jpg/240px-DEM_poly_in_Google_Earth.jpg'/></a></p>
      <p><span class="R_code"><strong><a href="grid2poly.html">grid2poly</a> </strong> <a href="dem_poly.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3ATWI_layerRaster_in_Google_Earth.jpg'><img width='240' alt='TWI layerRaster in Google Earth' src='http://upload.wikimedia.org/wikipedia/commons/thumb/2/22/TWI_layerRaster_in_Google_Earth.jpg/240px-TWI_layerRaster_in_Google_Earth.jpg'/></a></p>
      <p><span class="R_code"><strong><a href="layer.Raster.html">Raster</a> </strong> <a href="eberg_grid.kml"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3AMetadata_in_GoogleEarth.png.jpg'><img width='240' alt='Metadata in GoogleEarth.png' src='http://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Metadata_in_GoogleEarth.png.jpg/240px-Metadata_in_GoogleEarth.png.jpg'/></a></p>
      <p><span class="R_code"><strong><a href="spMetadata.html">spMetadata</a> </strong> <a href="eberg_md.kmz"> <img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
  </tr>
</table>
<table width="1020" border="0" cellspacing="0" cellpadding="10">
  <tr valign="top">
    <td><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3AGPX_bicycle_Wageningen_Muenster.jpg'><img width='240' alt='GPX bicycle Wageningen Muenster' src='http://upload.wikimedia.org/wikipedia/commons/thumb/7/7d/GPX_bicycle_Wageningen_Muenster.jpg/240px-GPX_bicycle_Wageningen_Muenster.jpg'/></a></p>
      <p class="R_code"><strong><a href="layer.STIDFtraj.html">STIDFtraj</a> </strong> <a href="gpxbtour_speed.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3ASpacetime_STIDF_object_polygons.png.jpg'><img width='240' alt='Spacetime STIDF object polygons.png' src='http://upload.wikimedia.org/wikipedia/commons/7/7e/Spacetime_STIDF_object_polygons.png.jpg'/></a></p>
      <p><span class="R_code"><strong><a href="layer.STIDF.html">STIDF Polygons</a> </strong> <a href="nct.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3ASpatiotemporal_changes_in_HRtemp08.png.jpg'><img width='240' alt='Spatiotemporal changes in HRtemp08.png' src='http://upload.wikimedia.org/wikipedia/commons/thumb/d/db/Spatiotemporal_changes_in_HRtemp08.png.jpg/240px-Spatiotemporal_changes_in_HRtemp08.png.jpg'/></a></p>
      <p><span class="R_code"><strong><a href="layer.STIDF.html">STIDF Points</a> </strong> <a href="HRtemp08_jan.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3ATime_series_of_MODIS_LST_rasters_in_Google_Earth.jpg'><img width='240' alt='Time series of MODIS LST rasters in Google Earth' src='http://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Time_series_of_MODIS_LST_rasters_in_Google_Earth.jpg/240px-Time_series_of_MODIS_LST_rasters_in_Google_Earth.jpg'/></a></p>
      <p><span class="R_code"><strong><a href="layer.RasterBrick.html">RasterBrick</a> </strong> <a href="LST_ll.kml"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="240"><div align="center">
      <p><a title='By Tomislav Hengl (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0)], via Wikimedia Commons' href='http://commons.wikimedia.org/wiki/File%3AMetadata_in_GoogleEarth.png.jpg'></a></p>
      </div></td>
  </tr>
</table>
<p>&nbsp;</p>
<hr />
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <th scope="col"><div align="left"><a href="http://www.isric.org" target="_blank"><img src="http://meta.isric.org/images/ISRIC_right.png" alt="ISRIC logo" width="703" height="80" border="0" longdesc="http://www.isric.org" /></a></div></th>
  </tr>
</table>
<p class="style1"> Last update: 
  <!-- #BeginDate format:Am1 -->December 7, 2011<!-- #EndDate -->
| contact: <a href="http://www.wewur.wur.nl/popups/vcard.aspx?id=HENGL001" target="_blank">tom.hengl@wur.nl</a> | <a href="http://www.isric.org">ISRIC</a> - World Soil Information Institute </p>
</body>
</html>
