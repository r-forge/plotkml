
<!-- This is the project specific website template -->
<!-- It can be changed as liked or replaced by other content -->

<?php

$domain=ereg_replace('[^\.]*\.(.*)$','\1',$_SERVER['HTTP_HOST']);
$group_name=ereg_replace('([^\.]*)\..*$','\1',$_SERVER['HTTP_HOST']);
$themeroot='http://r-forge.r-project.org/themes/rforge/';

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
  <p>Visualization of spatial and spatio-temporal objects in Google Earth</p>
</div>
<hr />
<p class="style1">Contact: <a href="http://www.wewur.wur.nl/popups/vcard.aspx?id=HENGL001" target="_blank">Tomislav Hengl</a>, </p>
<p class="style1">Contributions by: <a href="http://www.landcareresearch.co.nz/research/staff_page.asp?staff_num=2132" target="_blank">Pierre Roudier</a>, <a href="http://casoilresource.lawr.ucdavis.edu/drupal/node/905" target="_blank">Dylan Beaudette</a> &amp; <a href="http://ifgi.uni-muenster.de/staff/edzer-pebesma" target="_blank">Edzer Pebesma</a></p>
<p>This package has been developed as a part of the <a href="http://isric.org/projects/global-soil-information-facilities-gsif" target="_blank">Global Soil Information Facilities</a>, which are developed jointly by the ISRIC Institute and collaborators. ISRIC is a non-profit organization with a mandate to serve the international community as custodian of global soil information and to increase awareness and understanding of the role of soils in major global issues.</p>
<p>The <strong>plotKML project summary page</strong> you can find <a href="http://<?php echo $domain; ?>/projects/<?php echo $group_name; ?>/"><strong>here</strong></a>. See the complete list of <strong><a href="00Index.html">functions</a></strong> and a list of <a href="settings.php"><strong>additional settings</strong></a>. To submit a software bug, use the official <a href="http://r-forge.r-project.org/tracker/?group_id=1106" target="_blank"><strong>package tracker</strong></a>. The fastest way to learn how plotKML works is to follow this <a href="http://gsif.isric.org/doku.php?id=wiki:tutorial_plotkml" target="_blank"><strong>tutorial</strong></a>.</p>
<p>To submit a bug or future request please use the <strong><a href="https://r-forge.r-project.org/tracker/?group_id=1106" target="_blank">package tracker</a></strong>. The package is continuously updated and it is expected to become fully operational by early 2013. </p>
<p><strong>Installation:</strong></p>
<p>Get the <a href="http://cran.at.r-project.org/package=plotKML" target="_blank"><strong>stable release from CRAN</strong></a>. </p>
<p>To install this package from <a href="https://r-forge.r-project.org/R/?group_id=1106" target="_blank">R-forge</a> use (works only on<strong> &gt;= R 2.14!</strong>):</p>
<pre class="R_code">&gt; install.packages(&quot;plotKML&quot;, repos=c(&quot;http://R-Forge.R-project.org&quot;)) </pre>
<p>Alternatively, you can install the most recent snapshot of the package directly from the source by using e.g.:</p>
<pre class="R_code">&gt; download.file(&quot;http://plotkml.r-forge.r-project.org/plotKML_0.3-3.tar.gz&quot;, &quot;plotKML_0.3-3.tar.gz&quot;)
&gt; system(&quot;R CMD INSTALL plotKML_0.3-3.tar.gz&quot;) </pre>
<p><iframe src="https://docs.google.com/present/embed?id=dhbpzjb4_91cvx3x2f2" frameborder="0" width="410" height="342"></iframe></p>
<p><strong>News:</strong></p>
<ul>
  <li>Marc 20 2013: added <a href="http://gsif.isric.org/doku.php?id=wiki:tutorial_plotkml" target="_blank">tiling examples</a> to the plotKML tutorial; </li>
  <li>Feb 15 2013: plotKML article (JSS 1079) submitted to the Journal of Statistical Software (special issue 
    spatial and spatio-temporal data); </li>
  <li>Nove 26, 2012: plotKML version 03 sent to CRAN (package now 90% complete / but with still some bugs); </li>
  <li>Sept 10-12, 2012: <a href="http://www.geostat-course.org/R_development_workshop" target="_blank">R development workshop</a>  at IfGI Muenster (<a href="http://www.geostat-course.org/R_development_workshop" target="_blank"></a>sign-up to join this workshop); </li>
  <li>Aug 2012: added a <a href="tutorial.php"><strong>plotKML tutorial</strong></a>; </li>
  <li>Jun 20, 2012: <strong>the package has been published via <a href="http://cran.r-project.org/web/packages/plotKML/" target="_blank">CRAN</a></strong>;  </li>
  <li>May 2012: fixed some bugs with writing PNG (kml_layer.Raster); </li>
  <li>Feb 2012: the package is at the moment in the pre-alpha version; 10% missing functionality and validity checking required; </li>
</ul>
<p><strong>Documents</strong>:</p>
<ul>
  <li>Poster at DSM 2012 conference: <a href="poster_plotKML_DSM2012.pdf">&quot;plotKML: a platform for scientific visualization of 2D and 3D soil
  data in Google Earth&quot;</a> (PDF)</li>
  <li>Poster at UseR 2011: <a href="poster-plotKML-UseR2011.pdf">&quot;plotKML: a framework for visualization of space-time data&quot;</a> (PDF)</li>
</ul>
<hr />
<p>&nbsp;</p>
<table border="0" cellpadding="10" cellspacing="0">
  <tr valign="top">
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_eberg_two_aesthetics.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=99&amp;t=1362682050&amp;media=wiki:fig_eberg_two_aesthetics.jpg' alt='Ebergotzen two aesthetics.png' width='120' height="99" border="0"/></a></p>
      <p class="R_code"><strong><a href="layer.SpatialPoints.html">SpatialPoints</a> </strong> <a href="eberg.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td width="220"><div align="center"><p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_photo_overlay.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=119&amp;h=104&amp;t=1362682152&amp;media=wiki:fig_photo_overlay.jpg' alt='Soil monolith in Google Earth.png' width='119' height="104" border="0"/></a></p>
        <p><span class="R_code"><strong><a href="layer.SpatialPhotoOverlay.html">SpatialPhotoOverlay </a></strong> <a href="af.kmz"></a></span><a href="af.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_monolith.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=103&amp;h=120&amp;t=1361983802&amp;media=wiki:fig_monolith.jpg' alt='GroundPhoto in Google Earth.png' width='103' height="120" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.SpatialPhotoOverlay.html">SpatialPhotoOverlay</a> </strong> <a href="sm.kmz"></a></span><a href="sm.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_soilprofilecollection_hist.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=99&amp;t=1362682237&amp;media=wiki:fig_soilprofilecollection_hist.jpg' alt='SoilProfileCollection histogram in Google Earth.png' width='120' height="99" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.SoilProfileCollection.html">SoilProfileCollection</a> </strong> <a href="ca_bs_8_2.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
        <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_soilprofilecollection_block.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=99&amp;t=1361983123&amp;media=wiki:fig_soilprofilecollection_block.jpg' alt='SoilProfileCollection block visualized in Google Earth.png' width='120' height="99" border="0"/></a></p>
        <p><span class="R_code"><strong><a href="layer.SoilProfileCollection.html">SoilProfileCollection</a> </strong> <a href="ca_CEC8_2_block.kmz"> <img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="10">
  <tr valign="top">
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_eberg_lines.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=107&amp;t=1363802022&amp;media=wiki:fig_eberg_lines.jpg' alt='Ebergotzen contour lines' width='120' height="107" border="0"/></a></p>
      <p class="R_code"> <strong> <a href="layer.SpatialLines.html">SpatialLines</a> </strong> <a href="eberg_contours.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_eberg_polygons.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=99&amp;t=1362682030&amp;media=wiki:fig_eberg_polygons.jpg' alt='Ebergotzen soil units polygons.png' width='120' height="99" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.SpatialPolygons.html">SpatialPolygons</a> </strong> <a href="eberg_zones.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href="http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_dem_poly.jpg"><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=118&amp;t=1361983078&amp;media=wiki:fig_dem_poly.jpg' alt='DEM poly in Google Earth' width='120' height="118" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="grid2poly.html">grid2poly</a> </strong> <a href="dem_poly.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_layerraster_legend.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=118&amp;t=1362682103&amp;media=wiki:fig_layerraster_legend.jpg' alt='TWI layerRaster in Google Earth' width='120' height="118" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.Raster.html">Raster</a> </strong> <a href="eberg_grid.kml"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_metadata_googleearth.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=95&amp;t=1362682125&amp;media=wiki:fig_metadata_googleearth.jpg' alt='Metadata in GoogleEarth.png' width='120' height="95" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="spMetadata.html">spMetadata</a> </strong> <a href="eberg_md.kmz"> <img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="10">
  <tr valign="top">
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_gpxtour.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=120&amp;t=1362682080&amp;media=wiki:fig_gpxtour.jpg' alt='GPX bicycle Wageningen Muenster' width='120' height="120" border="0"/></a></p>
      <p class="R_code"><strong><a href="layer.STTDF.html">STTDF</a> </strong> <a href="gpxbtour_speed.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_stidf_polygons.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=111&amp;t=1362682325&amp;media=wiki:fig_stidf_polygons.jpg' alt='Spacetime STIDF object polygons.png' width='120' height="111" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.STIDF.html">STIDF Polygons</a> </strong> <a href="nct.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_spacetime_hrtemp08.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=114&amp;t=1362682251&amp;media=wiki:fig_spacetime_hrtemp08.jpg' alt='Spatiotemporal changes in HRtemp08.png' width='120' height="114" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.STIDF.html">STIDF Points</a> </strong> <a href="HRtemp08_jan.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_time_series_rasters_lst.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=118&amp;t=1362682340&amp;media=wiki:fig_time_series_rasters_lst.jpg' alt='Time series of MODIS LST rasters in Google Earth' width='120' height="118" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="layer.RasterBrick.html">RasterBrick</a> </strong> <a href="LST_ll.kml"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_spatialpredictions_meuse.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=111&amp;h=120&amp;t=1362682290&amp;media=wiki:fig_spatialpredictions_meuse.jpg' alt='SpatialPredictions in Google Earth' width='111' height="120" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="SpatialPredictions.html">SpatialPredictions</a> </strong> <a href="om.rk.kml"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
  </tr>
</table>
<table border="0" cellpadding="10" cellspacing="0">
  <tr valign="top">
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:fig_simulations_streams.jpg'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=119&amp;t=1362682203&amp;media=wiki:fig_simulations_streams.jpg' alt='Simulated streams' width='120' height="119" border="0"/></a></p>
      <p class="R_code"><strong><a href="SpatialVectorsSimulations.html">VectorsSimulations</a> </strong> <a href="bar_sum.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:plot_rasterbricksimulations.png'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=117&amp;t=1362682448&amp;media=wiki:plot_rasterbricksimulations.png' alt='Rasterbricksimulations' width='120' height="117" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="RasterBrickSimulations.html">RasterBrickSimulations</a> </strong> <a href="bardem_sims.kml"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:plot_lst.png'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=117&amp;t=1362682410&amp;media=wiki:plot_lst.png' alt='RasterBrickTimeSeries' width='120' height="117" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="RasterBrickTimeSeries.html">RasterBrickTimeSeries</a> </strong> <a href="LST.ts.kml"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:plot_spatialmaxentoutput.png'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=116&amp;t=1362682473&amp;media=wiki:plot_spatialmaxentoutput.png' alt='SpatialMaxEntOutput' width='120' height="116" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="SpatialMaxEntOutput.html">SpatialMaxEntOutput</a> </strong> <a href="bigfoot.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
    <td width="220"><div align="center">
      <p><a href='http://gsif.isric.org/lib/exe/fetch.php?media=wiki:plot_sampling_pattern.png'><img src='http://gsif.isric.org/lib/exe/fetch.php?w=120&amp;h=117&amp;t=1362682461&amp;media=wiki:plot_sampling_pattern.png' alt='SpatialSamplingPattern' width='120' height="117" border="0"/></a></p>
      <p><span class="R_code"><strong><a href="SpatialSamplingPattern.html">SpatialSamplingPattern</a> </strong> <a href="mySamplingPattern.kmz"><img src="ge_icon.png" alt="GE_icon" width="24" height="24" border="0" /></a></span></p>
    </div></td>
  </tr>
</table>
<br />
<hr />
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <th scope="col"><div align="left"><a href="http://isric.org/projects/global-soil-information-facilities-gsif" target="_blank"><img src="ISRIC_logo.jpg" alt="ISRIC logo" width="363" height="98" border="0" longdesc="http://www.isric.org" /></a></div></th>
  </tr>
</table>
<p class="style1"> Last update: 
  <!-- #BeginDate format:Am1 -->March 21, 2013<!-- #EndDate -->
| contact: <a href="http://www.wewur.wur.nl/popups/vcard.aspx?id=HENGL001" target="_blank">tom.hengl@wur.nl</a> | <a href="http://www.isric.org">ISRIC</a> - World Soil Information Institute </p>
</body>
</html>
