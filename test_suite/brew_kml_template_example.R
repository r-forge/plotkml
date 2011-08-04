brew(file = "LinesTemplate.xml", output = "RKMLoutput.kml" )


...and the kml template file to be used with brewer:


<?xml version="1.0" encoding="utf-8" ?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
<Folder><name>lines</name>
<% for(i in 1:nrow(seg)){ %>
  <Placemark>
  <TimeSpan>
	<begin><%= paste(1980+i, "01", "01", sep="-")%></begin>
    </TimeSpan>
          <name><%=paste(seg$x[i], ",", seg$y[i]," : ", seg$xend[i],
",", seg$yend[i], sep="")%></name>
<Style><LineStyle><color>7f9bffff</color><width>3.5</width></LineStyle></Style>
<LineString> <tessellate>1</tessellate>
                  <coordinates><%=seg[i,]$x%>, <%=seg[i,]$y%>, 0.0 
                               <%=seg[i,]$xend%>, <%=seg[i,]$yend%>, 0.0
      </coordinates></LineString>
  </Placemark>
<% } %> 
     </Folder> 
</Document></kml>
