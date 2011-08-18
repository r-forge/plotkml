
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
  <p>Plotting of space-time objects in Google Earth (visualization templates)</p>
</div>
<table width="600" border="0" cellspacing="0" cellpadding="10">
  <tr valign="top">
    <td><div align="center">
      <p><img src="Fig_plotKML_bubble_1_s.jpg" alt="Bubble plot (points)" width="198" height="200" border="0" /></p>
      <p class="R_code"><strong>kml</strong>(meuse, file = <span class="R_arg">&quot;meuse_zinc.kml&quot;</span>, <span class="R_env"> size=</span>zinc, <span class="R_env">label</span>=zinc) </p>
      </div></td>
    <td><p><a href="http://globalsoilmap.net/content/animated-display-uncertainty-mapping-soil-classes"><img src="Fig_plotKML_anime_1_s.jpg" alt="Animations using spatial grids" width="162" height="200" border="0" /></a></p></td>
    <td><div align="center"><p><a href="http://globalsoilmap.net/content/prediction-or-organic-matter-geo-gif-kml"><img src="Fig_plotKML_grid_om_s.jpg" alt="Results of spatial prediction" width="174" height="200" border="0" /></a></p></div></td>
    <td><div align="center"><p><img src="Fig_plotKML_geopath_s.jpg" alt="Geopath (between two points)" width="171" height="200" border="0" /></p></div></td>
    <td><div align="center"><p><a href="http://globalsoilmap.net/content/soil-horizons-and-values-organic-carbon-visualized-google-earth"><img src="Fig_plotKML_soilblock_s.jpg" alt="Soil profiles as 3D blocks" width="170" height="200" border="0" /></a></p></div></td>
  </tr>
</table>
<p class="style1">Contact: <a href="http://www.wewur.wur.nl/popups/vcard.aspx?id=HENGL001" target="_blank">Tomislav Hengl</a>, <a href="http://www.landcareresearch.co.nz/research/staff_page.asp?staff_num=2132" target="_blank">Pierre Roudier</a> &amp; <a href="http://casoilresource.lawr.ucdavis.edu/drupal/node/905" target="_blank">Dylan Beaudette</a></p>

<p> The <strong>project summary page</strong> you can find <a href="http://<?php echo $domain; ?>/projects/<?php echo $group_name; ?>/"><strong>here</strong></a>.</p>
<p class="style1">Poster at UseR 2011: <a href="poster-plotKML-UseR2011.pdf">&quot;plotKML: a framework for visualization of space-time data&quot;</a> (PDF) </p>
<hr />
<table width="500" border="0" cellspacing="5" cellpadding="10">
  <caption class="style1">
    Some common plotKML icons
  </caption>
  <tr>
    <td class="R_arg"><div align="center">cross</div></td>
    <td class="R_arg"><div align="center">3Dball</div></td>
    <td class="R_arg"><div align="center">3Dballred</div></td>
    <td class="R_arg"><div align="center">3Dballyellow</div></td>
    <td class="R_arg"><div align="center">circle</div></td>
    <td class="R_arg"><div align="center">hexagon</div></td>
    <td class="R_arg"><div align="center">triangle</div></td>
    <td class="R_arg"><div align="center">square</div></td>
    <td class="R_arg"><div align="center">golfhole</div></td>
    <td class="R_arg"><div align="center">pointer</div></td>
  </tr>
  <tr>
    <td>      <p align="center"><img src="cross.png" alt="cross.png" width="45" height="45" /><br />
      </p></td>
    <td><div align="center"><img src="3Dball.png" alt="3Dball.png" width="45" height="45" /></div></td>
    <td><div align="center"><img src="3Dballred.png" alt="3Dballred" width="45" height="45" /></div></td>
    <td><div align="center"><img src="3Dballyellow.png" alt="3Dballyellow" width="45" height="45" /></div></td>
    <td><div align="center"><img src="circle.png" alt="circle.png" width="45" height="45" /></div></td>
    <td><div align="center"><img src="hexagon.png" alt="hexagon.png" width="45" height="52" /></div></td>
    <td><div align="center"><img src="triangle.png" alt="triangle.png" width="55" height="48" /></div></td>
    <td><div align="center"><img src="square.png" alt="square.png" width="50" height="50" /></div></td>
    <td><div align="center"><img src="golfhole.png" alt="glofhole.png" width="45" height="63" /></div></td>
    <td><div align="center"><img src="pointer.png" alt="pointer.png" width="35" height="65" /></div></td>
  </tr>
</table>
<hr />
<table width="500" border="0" cellspacing="5" cellpadding="10" summary="To load a color pallete use "data(saga_pal)="data(saga_pal)"" method.">
  <caption class="style1">
    Color palettes
  </caption>
  <tr>
    <td><div align="center" class="R_arg">SAGA_pal[['n']]</div></td>
    <td><div align="center"><span class="R_arg">R_pal[['n']]</span></div></td>
    <td><div align="center"><span class="R_arg">worldgrids_pal[['n']]</span></div></td>
  </tr>
  <tr>
    <td><div align="center"><img src="SAGA_pal.png" alt="SAGA_pal.png" width="238" height="1020" /></div></td>
    <td><div align="center"><img src="R_pal.png" alt="R_pal.png" width="238" height="1020" /></div></td>
    <td><div align="center"><img src="worldgrids_pal.png" alt="worldgrids_pal.png" width="238" height="1020" /></div></td>
  </tr>
</table>
<hr />
<p>&nbsp;</p>
</body>
</html>
