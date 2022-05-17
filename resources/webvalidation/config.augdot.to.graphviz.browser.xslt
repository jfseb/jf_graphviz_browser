<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:mp="http://schemas.sap.com/sfsf/aa/mp"
     xmlns:my="urn:sample"
     xmlns="http://www.w3.org/1999/xhtml"
     xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
     extension-element-prefixes="msxsl"
     exclude-result-prefixes="my mp"
><!-- *** this is a special variant for transformation in brower xslt processors, as they do not support

  <xsl:output method="text" /> 

It requires the following post-processing to extract the pure doc string

   var resp = xsltProcessor.transformToDocument(xdoc);
    console.log("result is " + resp);
    ct = new XMLSerializer().serializeToString(resp);
    
    start = "<div id=\"cutSTART\">cutSTART</div>";
    end = "<div id=\"cutEND\">cutEND</div>";
    ct = ct.substring(ct.indexOf(start) + start.length);
    ct = ct.substring(0,ct.indexOf(end));
    ct = ct.replaceAll("REP&lt;","<");
    ct = ct.replaceAll("REP&gt;",">");
    console.log("here ct " + ct );
    return ct;


  -->
  <xsl:output method="xml" media-type="text/html" omit-xml-declaration="yes" encoding="utf-8" doctype-system="about:legacy-compat"  indent="no"/>
  
  
<xsl:template match="PhysicalTable" mode="makeNode" xml:space="preserve">
    
    <!-- single vertical table -->
  <xsl:for-each select="." xml:space="preserve">
   
          N<xsl:value-of select="@DotNodeName"/> [
   shape=plaintext
   href="output/run_DS1_log.html#TABLE~<xsl:value-of select="@id"></xsl:value-of>"
   label=<xsl:text disable-output-escaping="no">REP&lt;</xsl:text>
     <table border='6' cellborder='1'><xsl:attribute name='bgcolor'><xsl:choose><xsl:when test="@cat='defined'">palegreen</xsl:when><xsl:otherwise>olivedrab1</xsl:otherwise></xsl:choose></xsl:attribute>
       <tr><td colspan="1">Source Table <br/><xsl:value-of select="@id"></xsl:value-of> </td></tr>
          <xsl:apply-templates select="Column" mode="trtdNameOrValue"/>
     </table>
      <xsl:text disable-output-escaping="no">REP&gt;];</xsl:text>
  
    </xsl:for-each>
  
</xsl:template>
  
      <msxsl:script language="JScript" implements-prefix="my">
       function today()
       {
          return "" + new Date(); // new Date(); 
       }
    </msxsl:script>

  <xsl:template mode="trtdNameOrValue" match="Column">
    <tr>
      <td border="1">
        <xsl:attribute name="port"><xsl:value-of select="concat('P',@DotPortName)"/></xsl:attribute>
        <xsl:value-of select="@id"></xsl:value-of>
        <xsl:if test="@value">
          ( <xsl:value-of select="@value"/>)
        </xsl:if>
      </td>
    </tr>
  </xsl:template>


  <xsl:template match="LogicalTable" mode="makeNode" xml:space="preserve">
          N<xsl:value-of select="@DotNodeName"/> [
   shape=plaintext
   href="output/run_DS1_log.html#TABLE~<xsl:value-of select="@id"></xsl:value-of>"
   label=<xsl:text disable-output-escaping="no">REP&lt;</xsl:text>
     <table border='1' cellborder='1' bgcolor='white'>
       <tr><td colspan="1">
         <xsl:if test="EntityRelationShip">
           <xsl:attribute name="port">PERBOX</xsl:attribute>  
         </xsl:if>
         <xsl:value-of select="@cat"/><br/><xsl:value-of select="@id"></xsl:value-of></td></tr>
       <xsl:apply-templates select="Column" mode="trtdNameOrValue"/><xsl:apply-templates select="JoinBox" mode="makeTable" />
     </table>
      <xsl:text disable-output-escaping="no">REP&gt;];</xsl:text>
</xsl:template>
  
  
<xsl:template match="LogicalTable[@type='Generator' or @type='Function']" mode="makeNode" xml:space="preserve">

    
      <!--  vertical table two columns -->
  <xsl:for-each select="." xml:space="preserve">
   
          N<xsl:value-of select="@DotNodeName"/> [
   shape=plaintext
   href="output/run_DS1_log.html#TABLE~<xsl:value-of select="@id"></xsl:value-of>"
   label=<xsl:text disable-output-escaping="no">REP&lt;</xsl:text><table border="1" bgcolor="khaki" cellborder="1">
       <tr><td colspan="2"><xsl:value-of select="@type"/> <br/> <xsl:value-of select="@id"></xsl:value-of> </td></tr>
       <tr><td border="1"><table border="0" cellpadding="1" cellspacing="1"><tr><td border="0"></td></tr>
         <xsl:apply-templates select="Column" mode="trtdNameOrValue"/>
     </table></td>
       <td border="1"><table cellspacing="1" cellpadding="1" border="0"><tr><td border="0"></td></tr>
     <xsl:for-each select="Function/ColumnRef">
         <tr><td  border="1"><xsl:attribute name="port">P<xsl:value-of select="@DotPortName"/></xsl:attribute>
            <xsl:value-of select="@tag"/> </td>
          </tr>  
     </xsl:for-each>
     <xsl:for-each select="Generator/ColumnRef">
         <tr><td  border="1"><xsl:attribute name="port">P<xsl:value-of select="@DotPortName"/></xsl:attribute>
            <xsl:value-of select="@tag"/> </td>
          </tr>  
     </xsl:for-each>
       <tr><td> </td></tr>
         </table>
       </td>
       </tr><!-- graphviz needs at least one cell -->
     </table>
      <xsl:text disable-output-escaping="no">REP&gt;];</xsl:text>
    </xsl:for-each>
 
</xsl:template>

  <xsl:template match="FactTable[@dottag='FIN']" mode="makeTableColor"><xsl:attribute name="border"><xsl:value-of select="8"/></xsl:attribute><xsl:attribute name="bgcolor"><xsl:value-of select="'plum1'"></xsl:value-of></xsl:attribute></xsl:template>
  <xsl:template match="FactTable[@dottag='ALIAS']" mode="makeTableColor"><xsl:attribute name="bgcolor"><xsl:value-of select="'white'"></xsl:value-of></xsl:attribute>
  </xsl:template>

<xsl:template match="FactTable" mode="makeNode" xml:space="preserve">
    
    <!-- single vertical table -->
  <xsl:for-each select="." xml:space="preserve">
   
          N<xsl:value-of select="@DotNodeName"/> [
   shape=plaintext
   href="output/run_DS1_log.html#TABLE~<xsl:value-of select="@id"></xsl:value-of>"
   label=<xsl:text disable-output-escaping="no">REP&lt;</xsl:text>
     <table align="LEFT" bgcolor="mistyrose" cellborder="1"><xsl:apply-templates mode="makeTableColor" select="."/>
        <tr><td colspan="1"> <xsl:choose><xsl:when test="@dottag='ALIAS'"> Alias <br/></xsl:when><xsl:when test="@dottag='FIN'">Final Fact Table <br/></xsl:when><xsl:otherwise> Insertion Fact Tabe <br/></xsl:otherwise></xsl:choose>Fact <xsl:value-of select="@id"></xsl:value-of> </td></tr>
       <xsl:for-each select="Column">
         <tr>
         <td align="LEFT"><xsl:attribute name="port">P<xsl:value-of select="@DotPortName"/></xsl:attribute>
          <xsl:value-of select="@id"></xsl:value-of></td>
     </tr>  
     </xsl:for-each>
     </table>
      <xsl:text disable-output-escaping="no">REP&gt;];</xsl:text>
  
    </xsl:for-each>
  
</xsl:template>



  <!-- *************************     -->
  <!--  output either the value or "entityref"."columnref -->
  <xsl:template name="quot">
    <xsl:text disable-output-escaping="no">REP&quot;</xsl:text>
  </xsl:template>
  <xsl:template name="quotdotquot">
    <xsl:text disable-output-escaping="no">REP&quot;.&quot;</xsl:text>
  </xsl:template>

  
    <!-- *************************     -->
  <!--  output either the value or "entityref"."columnref -->
  <xsl:template match="ColumnRef" mode="nameOrValue">
    <xsl:if test="@columnRef">
      <xsl:call-template name="quot"/>
      <xsl:value-of select="@entityRef"/>
      <xsl:call-template name="quotdotquot"/>
      <xsl:value-of select="@columnRef"/>
      <xsl:call-template name="quot"/>
    </xsl:if> 
    <xsl:value-of select="@value"/>
  </xsl:template>


  <!--  output either the value or columnref -->
  <xsl:template match="ColumnRef" mode="shortNameOrValue">
    <xsl:if test="@columnRef">
      <xsl:value-of select="@columnRef"/>
    </xsl:if>
    <xsl:value-of select="@value"/>
  </xsl:template>

  <xsl:template match="JoinBox" mode="makeTable" ><xsl:for-each select="." xml:space="preserve"><tr><td colspan="1" bgcolor="lightsalmon1" port="PJOINBOX">
         Join for <xsl:value-of select="ancestor::LogicalTable/@id"/></td></tr>
           <xsl:for-each select="JoinCondition"><xsl:variable name="cond" select="@cond"/>
             <xsl:for-each select="ColumnRef[1]">
         <tr><td bgcolor="whitesmoke"><xsl:attribute name="port">P<xsl:value-of select="@DotPortName"/></xsl:attribute>
          <xsl:apply-templates mode="shortNameOrValue" select="."/>...</td> 
          </tr></xsl:for-each><tr><td border="0" color="grey"><xsl:value-of select="$cond"/></td></tr>
        <xsl:for-each select="ColumnRef[2]">
         <tr><td bgcolor="whitesmoke" border="1"><xsl:attribute name="port">P<xsl:value-of select="@DotPortName"/></xsl:attribute>
         ...<xsl:apply-templates mode="shortNameOrValue" select="."/> </td></tr></xsl:for-each></xsl:for-each>
    </xsl:for-each>
</xsl:template>

<xsl:template match="PostCalculation" mode="makeNode" xml:space="preserve">
    
  
  <xsl:if test="not(JoinBox)">
    <!--  vertical table two columns -->
  <xsl:for-each select="." xml:space="preserve">
   
          N<xsl:value-of select="@DotNodeName"/> [
   shape=plaintext
   color=black
   label=<xsl:text disable-output-escaping="no">REP&lt;</xsl:text><table border='1' cellborder="1" bgcolor='yellow'>
       <tr><td colspan="2">PostCalculation<br/><xsl:value-of select="@id"></xsl:value-of> </td></tr>
       <tr><td border="0"><table border="0"><tr><td border="0"></td></tr><xsl:for-each select="Plug[@dir='out']">
         <tr><td border="1"><xsl:attribute name="port">P<xsl:value-of select="@DotPortName"/></xsl:attribute>
          <xsl:value-of select="@tag"></xsl:value-of></td>
          </tr>  
     </xsl:for-each></table></td><td border="0"><table border="0"><tr><td border="0"></td></tr>
     <xsl:for-each select="Plug[@dir='in']">
         <tr><td><xsl:attribute name="port">P<xsl:value-of select="@DotPortName"/></xsl:attribute>
            <xsl:value-of select="@tag"/> </td>
          </tr>  
     </xsl:for-each>
         <tr><td border="0"></td></tr></table></td></tr><!-- graphviz needs at least one cell -->
     </table>
      <xsl:text disable-output-escaping="no">REP&gt;];</xsl:text>
    </xsl:for-each>
  </xsl:if>
  
</xsl:template>

  
    
    
<xsl:template match="FillStrategyBox" mode="makeNode" xml:space="preserve">
    
    <!--  vertical table two columns -->
  <xsl:for-each select="." xml:space="preserve">
   
          N<xsl:value-of select="@DotNodeName"/> [
   shape=plaintext
   color=black
   label=<xsl:text disable-output-escaping="no">REP&lt;</xsl:text><table border='1' cellborder='1' bgcolor='lightblue'>
       <tr><td colspan="2"> FillStrategy <br/> <xsl:value-of select="@id"></xsl:value-of> </td></tr>
       <tr><td border="0"><table border="0" cellpadding="1" cellspacing="1"><tr><td border="0"></td></tr><xsl:for-each select="Plug[@dir='out']">
         <tr><td border="1" ><xsl:attribute name="port">P<xsl:value-of select="@DotPortName"/></xsl:attribute>
          <xsl:value-of select="@tag"></xsl:value-of></td>
          </tr>  
     </xsl:for-each></table></td><td border="0"><table cellspacing="1" cellpadding="1" border="0"><tr><td border="0"></td></tr>
     <xsl:for-each select="Plug[@dir='in']">
         <tr><td  border="1"><xsl:attribute name="port">P<xsl:value-of select="@DotPortName"/></xsl:attribute>
            <xsl:value-of select="@tag"/> </td>
          </tr>  
     </xsl:for-each>
         </table></td></tr><!-- graphviz needs at least one cell -->
     </table>
      <xsl:text disable-output-escaping="no">REP&gt;];</xsl:text>
    </xsl:for-each>
  
</xsl:template>

    
<xsl:template match="EventBox" mode="makeNode" xml:space="preserve">
    
    <!-- single vertical table -->
  <xsl:for-each select="." xml:space="preserve">
   
          N<xsl:value-of select="@DotNodeName"/> [
   shape=plaintext
   color=black
   href="output/run_DS1_log.html"
   style=dotted
   label=<xsl:text disable-output-escaping="no">REP&lt;</xsl:text>
     <table border="1"  bgcolor='paleturquoise1'>
       <tr><td colspan="2">Event Driver <br/> <xsl:value-of select="@id"></xsl:value-of> </td></tr>
      <tr><td border="0">  
        <table border="0" cellpadding="1" cellspacing="1">
       <xsl:for-each select="Column[@dir='out']">
         <tr>
         <td border="1"><xsl:attribute name="port">P<xsl:value-of select="@DotPortName"/></xsl:attribute>
          <xsl:value-of select="@id"></xsl:value-of></td>
     </tr></xsl:for-each>
     </table>
      </td><td border="0">
          <table border="0">
       <xsl:for-each select="Plug[@dir='in']">
         <tr>
         <td border="1"><xsl:attribute name="port">P<xsl:value-of select="@DotPortName"/></xsl:attribute>
          <xsl:value-of select="@tag"></xsl:value-of></td>
     </tr></xsl:for-each>
     </table>
       </td></tr>
     </table>
      <xsl:text disable-output-escaping="no">REP&gt;];</xsl:text>
  
    </xsl:for-each>
  
</xsl:template>
  
  
<xsl:template name="edgeStyle">
<xsl:param name="sourceType"></xsl:param>
  <xsl:variable name="thisTableType" select="local-name(parent::*)"/>
  
    
    <xsl:variable name="edgestyles">
     |0 style=dashed, color=red |
     |1 style=dashed, color=blue |
     |2 style=dashed, color=gold |
     |3 style=dashed, color=orange |
     |4 style=dashed, color=cyan |
     |5 style=dashed, color=magenta |
     |6 style=dashed, color=green |
     |7 style=dashed, color=purple |
     |8 style=dashed, color=skyblue |
     |9 style=dashed, color=greenyellow |
     |10 style=dashed, color=gray |
     |11 style=dotted, color=blue |
     |12 style=dotted, color=gold |
     |13 style=dotted, color=orange |
     |14 style=dotted, color=cyan |
     |15 style=dotted, color=magenta |
     |16 style=dotted, color=green |
     |17 style=dotted, color=purple |
     |18 style=dotted, color=skyblue |
     |19 style=dotted, color=greenyellow |
     |20 style=solid, color=gray |
     |21 style=solid, color=blue |
     |22 style=solid, color=gold |
     |23 style=solid, color=orange |
     |24 style=solid, color=cyan |
     |25 style=solid, color=magenta |
     |26 style=solid, color=green |
     |27 style=solid, color=purple |
     |28 style=solid, color=skyblue |
     |29 style=solid, color=greenyellow |
     |30 style=solid, color=gray |
  
  </xsl:variable>


  <xsl:variable name="edgestylesAlternatingBlueish">
    |0 style=solid, color=blue |
    |1 style=solid, color=deepskyblue |
    |2 style=solid, color=dodgerblue4 |
    |3 style=solid, color=darkturquoise |
    |4 style=dashed, color=cyan |
    |5 style=dashed, color=magenta |
    |6 style=dashed, color=green |
  </xsl:variable>
  
   <xsl:variable name="edgestylesAlternatingRedish">
    |0 style=solid, color=brown |
    |1 style=solid, color=darkorange |
    |2 style=solid, color=red |
    |3 style=solid, color=magenta |
    |4 style=dashed, color=cyan |
    |5 style=dashed, color=magenta |
    |6 style=dashed, color=green |
  </xsl:variable>
    
<xsl:choose>
<xsl:when test="$sourceType='FactTable'"> 
 [ penwidth=3, <xsl:value-of select="substring-before(substring-after($edgestylesAlternatingRedish,(count(preceding::*) mod 4)),'|')"></xsl:value-of>]
</xsl:when>
  <xsl:when test="$sourceType='JoinData'">
 [penwidth=2, color=darkgreen]  
</xsl:when>
  <xsl:when test="contains($sourceType,'EventBox')">
 [ penwidth=2, <xsl:value-of select="substring-before(substring-after($edgestylesAlternatingBlueish,(string-length($sourceType) mod 4)),'|')"></xsl:value-of>]
</xsl:when>
<xsl:when test="$sourceType='JoinCond'">
 [ penwidth=2, <xsl:value-of select="substring-before(substring-after($edgestylesAlternatingRedish,(count(preceding::*) mod 4)),'|')"></xsl:value-of>]
</xsl:when>
<xsl:when test="$sourceType='Generator' or $sourceType='Function'">
 [penwidth=3, color=orange]  
</xsl:when>
<xsl:when test="$sourceType='LogicalTable' and $thisTableType='PhysicalTable'">
 [ penwidth=2, <xsl:value-of select="substring-before(substring-after($edgestyles,(count(preceding::*) mod 30)),'|')"></xsl:value-of>]
</xsl:when>
<xsl:otherwise>
 [ penwidth=2, <xsl:value-of select="substring-before(substring-after($edgestyles,(count(preceding::*) mod 30)),'|')"></xsl:value-of>]
</xsl:otherwise>
</xsl:choose>
  </xsl:template>
  
<!-- ****************************** -->
<xsl:template match="LogicalTable" mode="makeEdges">

  <xsl:for-each select="." xml:space="preserve">

    <xsl:variable name="myNodeName" select="@DotNodeName"></xsl:variable>
    <xsl:for-each select="Column">
      <xsl:variable name="entityRef" select="@entityRef"></xsl:variable>
      <xsl:variable name="columnRef" select="@columnRef"></xsl:variable>
      <xsl:variable name="myPortName" select="concat('N',$myNodeName, ':P', @DotPortName, ':', 'e')"></xsl:variable>

      <xsl:for-each select="//Column[@id=$columnRef and ./parent::*[@id=$entityRef]]">
        <xsl:variable name="hisPortName" select="concat('N',parent::*/@DotNodeName,':P',@DotPortName,':','w')"></xsl:variable>
        <xsl:value-of select="$myPortName"/> <xsl:text disable-output-escaping="no"> -REP&gt; </xsl:text>
        <xsl:value-of select="$hisPortName"/>  <xsl:call-template name="edgeStyle">
          <xsl:with-param name="sourceType" select="'LogicalTable'"/>
        </xsl:call-template>;
      </xsl:for-each>
            
    </xsl:for-each>
    <xsl:for-each select="*[local-name()='Function' or local-name()='Generator']/ColumnRef">
      <xsl:variable name="entityRef" select="@entityRef"></xsl:variable>
      <xsl:variable name="columnRef" select="@columnRef"></xsl:variable>
      <xsl:variable name="myPortName" select="concat('N',$myNodeName, ':P', @DotPortName, ':', 'e')"></xsl:variable>
      <xsl:for-each select="//Column[@id=$columnRef and ./parent::*[@id=$entityRef]]">
        <xsl:variable name="hisPortName" select="concat('N',parent::*/@DotNodeName,':P',@DotPortName,':','w')"></xsl:variable>
        <xsl:value-of select="$myPortName"/> <xsl:text disable-output-escaping="no"> -REP&gt; </xsl:text>
        <xsl:value-of select="$hisPortName"/>  <xsl:call-template name="edgeStyle">
          <xsl:with-param name="sourceType" select="'Generator'"/>
        </xsl:call-template>;
      </xsl:for-each>
    </xsl:for-each>
      </xsl:for-each>
</xsl:template>

  
<!-- ****************************** -->
<xsl:template match="FactTable" mode="makeEdges">
  
<xsl:for-each select="." xml:space="preserve">
  
    
    <!--
    <xsl:for-each select="Column">
    <xsl:variable name="entityRef" select="@entityRef"></xsl:variable>
    <xsl:variable name="columnRef" select="@columnRef"></xsl:variable>
    <xsl:variable name="myNodeName" select="parent::*/@DotNodeName"></xsl:variable>
    <xsl:variable name="myPortName" select="concat('N',$myNodeName, ':P', @DotPortName, ':', 'e')"></xsl:variable>
    <xsl:for-each select="//Column[@id=$columnRef and ./ancestor::*[@tablenamebearer='true' and @id=$entityRef]]">
      <xsl:variable name="isSuppressedNode"><xsl:choose><xsl:when  test="./ancestor::PostCalculation[@tablenamebearer='true' and @id=$entityRef]/JoinBox"><xsl:value-of select="true"/></xsl:when><xsl:otherwise><xsl:value-of select="0"/></xsl:otherwise></xsl:choose></xsl:variable>
      <xsl:variable name="hisNodeName"><xsl:choose><xsl:when  test="$isSuppressedNode != 0"><xsl:value-of select="./ancestor::PostCalculation[@tablenamebearer='true' and @id=$entityRef]/JoinBox/@DotNodeName"/></xsl:when><xsl:otherwise><xsl:value-of select="ancestor::*[@tablenamebearer='true']/@DotNodeName"/></xsl:otherwise></xsl:choose></xsl:variable>
      <xsl:variable name="hisBarePortName" ><xsl:choose><xsl:when test="$isSuppressedNode != 0"><xsl:value-of select="parent::*/JoinBox/Plug[@id=$columnRef]/@DotPortName"/></xsl:when><xsl:otherwise><xsl:value-of select="@DotPortName"/></xsl:otherwise></xsl:choose></xsl:variable>
      <xsl:variable name="hisPortName" select="concat('N',$hisNodeName,':P',$hisBarePortName,':','w')"></xsl:variable>
      <xsl:value-of select="$myPortName"/> <xsl:text disable-output-escaping="no"> -REP&gt; </xsl:text>
      <xsl:value-of select="$hisPortName"/>  <xsl:call-template name="edgeStyle">
        <xsl:with-param name="sourceType" select="'FactTable'"/>
      </xsl:call-template>;
    </xsl:for-each>
  </xsl:for-each>
  
   -->

  <xsl:for-each select="Column">
    <xsl:variable name="entityRef" select="@entityRef"></xsl:variable>
    <xsl:variable name="columnRef" select="@columnRef"></xsl:variable>
    <xsl:variable name="myNodeName" select="parent::*/@DotNodeName"></xsl:variable>
    <xsl:variable name="myPortName" select="concat('N',$myNodeName, ':P', @DotPortName, ':', 'e')"></xsl:variable>

    <xsl:for-each select="//Column[@id=$columnRef and ./ancestor::*[@tablenamebearer='true' and @id=$entityRef]]">
      <xsl:variable name="isSuppressedNode"><xsl:choose><xsl:when  test="./ancestor::PostCalculation[@tablenamebearer='true' and @id=$entityRef]/JoinBox"><xsl:value-of select="true"/></xsl:when><xsl:otherwise><xsl:value-of select="0"/></xsl:otherwise></xsl:choose></xsl:variable>
      <xsl:variable name="hisNodeName"><xsl:choose><xsl:when  test="$isSuppressedNode != 0"><xsl:value-of select="./ancestor::PostCalculation[@tablenamebearer='true' and @id=$entityRef]/JoinBox/@DotNodeName"/></xsl:when><xsl:otherwise><xsl:value-of select="ancestor::*[@tablenamebearer='true']/@DotNodeName"/></xsl:otherwise></xsl:choose></xsl:variable>
      <xsl:variable name="hisBarePortName" ><xsl:choose><xsl:when test="$isSuppressedNode != 0"><xsl:value-of select="parent::*/JoinBox/Plug[@id=$columnRef]/@DotPortName"/></xsl:when><xsl:otherwise><xsl:value-of select="@DotPortName"/></xsl:otherwise></xsl:choose></xsl:variable>
      <xsl:variable name="hisPortName" select="concat('N',$hisNodeName,':P',$hisBarePortName,':','w')"></xsl:variable>
      <xsl:value-of select="$myPortName"/> <xsl:text disable-output-escaping="no"> -REP&gt; </xsl:text>
      <xsl:value-of select="$hisPortName"/>  <xsl:call-template name="edgeStyle">
        <xsl:with-param name="sourceType" select="'DGFactTableSource'"/>
      </xsl:call-template>;
    </xsl:for-each>

  
  </xsl:for-each>
  
</xsl:for-each>
    
</xsl:template>
  

<!-- ****************************** -->
<xsl:template match="JoinBox" mode="makeEdges">
  
<xsl:for-each select="." xml:space="preserve">

    <xsl:variable name="myNodeName" select="ancestor::*[@tablenamebearer='true']/@DotNodeName"></xsl:variable>
      <!-- draw join condition links -->
  <xsl:for-each select="JoinCondition/ColumnRef[@entityRef]">
    <xsl:variable name="entityRef" select="@entityRef"></xsl:variable>
    <xsl:variable name="columnRef" select="@columnRef"></xsl:variable>
    <xsl:variable name="myPortName" select="concat('N',$myNodeName, ':P', @DotPortName, ':', 'e')"></xsl:variable>
    <xsl:for-each select="//Column[@id=$columnRef and ./ancestor::*[@tablenamebearer='true' and @id=$entityRef]]">
      <xsl:variable name="hisPortName" select="concat('N',parent::*/@DotNodeName,':P',@DotPortName,':','w')"></xsl:variable>
      <xsl:value-of select="$myPortName"/> <xsl:text disable-output-escaping="no"> -REP&gt; </xsl:text>
      <xsl:value-of select="$hisPortName"/>  <xsl:call-template name="edgeStyle">
        <xsl:with-param name="sourceType" select="'JoinCond'"/>
      </xsl:call-template>;
    </xsl:for-each>
  </xsl:for-each>
    </xsl:for-each>
</xsl:template>
  

  <!-- ****************************** -->
  
  <!-- ****************************** -->
  <xsl:template match="EventBox" mode="makeEdges">

    <xsl:for-each select="." xml:space="preserve">

  <xsl:for-each select="Plug[@dir='in']">
    <xsl:variable name="semanticType" select="@semanticType"></xsl:variable>
    <xsl:variable name="columnRef" select="@columnRef"></xsl:variable>
    <xsl:variable name="myNodeName" select="parent::*/@DotNodeName"></xsl:variable>
    <xsl:variable name="myPortName" select="concat('N',$myNodeName, ':P', @DotPortName, ':', 'e')"></xsl:variable>

    <xsl:for-each select="//LogicalTable/Column[@semanticType=$semanticType]">
      <xsl:variable name="hisPortName" select="concat('N',parent::*/@DotNodeName,':P',@DotPortName,':','w')"></xsl:variable>
      <xsl:value-of select="$myPortName"/> <xsl:text disable-output-escaping="no"> -REP&gt; </xsl:text>
      <xsl:value-of select="$hisPortName"/>  <xsl:call-template name="edgeStyle">
        <xsl:with-param name="sourceType" select="concat('EventBox',@semanticType)"/>
      </xsl:call-template>;
    </xsl:for-each>

   </xsl:for-each>
  </xsl:for-each>
  </xsl:template>

    
<xsl:template name="doit" >

  <xsl:apply-templates mode="makeNode" select="//FactTable"></xsl:apply-templates>
  <xsl:apply-templates mode="makeNode" select="//PostCalculation"></xsl:apply-templates>
  <xsl:apply-templates mode="makeNode" select="//EventBox"></xsl:apply-templates>
  <xsl:apply-templates mode="makeNode" select="//LogicalTable"></xsl:apply-templates>
  <xsl:apply-templates mode="makeNode" select="//PhysicalTable"></xsl:apply-templates>

  
  <xsl:apply-templates mode="makeEdges" select="//FactTable"></xsl:apply-templates>
  <xsl:apply-templates mode="makeEdges" select="//PostCalculation"></xsl:apply-templates>
  <xsl:apply-templates mode="makeEdges" select="//LogicalTable"></xsl:apply-templates>
  <xsl:apply-templates mode="makeEdges" select="//JoinBox"></xsl:apply-templates>
  <xsl:apply-templates mode="makeEdges" select="//EventBox"></xsl:apply-templates>
 
 


  
  <xsl:text xml:space='preserve'>
      
    
 
  
  
  </xsl:text>
  
  
  
  </xsl:template>
      
      
      
      
        
        
        
        
          
          
<xsl:template match="NormalizedDGMP" xml:space="preserve">
    
    <html>
    <body>
    <div id="cutSTART">cutSTART</div>
    digraph H { href="output/run_DS1_log.html"
     label=<xsl:text disable-output-escaping="no">REP&lt;</xsl:text><font point-size="30"><table border="0"><tr><td bgcolor="black" colspan="2"></td></tr>
       <tr><td colspan="2">Data Generation flow for Fact table for metric pack &quot;<xsl:value-of select="@id"></xsl:value-of>&quot;</td></tr>
       <tr><td>dbprefix=<xsl:value-of select="@prefix"></xsl:value-of></td><td> id=<xsl:value-of select="@id"></xsl:value-of> </td></tr>
       <tr><td colspan="2"><font point-size="22"><table cellspacing="0" cellpadding="4"><tr><td colspan="5"> </td><td> <xsl:if test="element-available('my:today')"><xsl:value-of select="my:today()"/></xsl:if> </td></tr>
         <tr><td>(Fat border):  Persisted Table</td><td> (White): Views </td>        
           <td> (Filled lean border: Computations) 
           </td>
        <td bgcolor="lightsalmon1"> Joins </td>
         <td bgcolor="khaki" >Generator</td>
         <td bgcolor ="yellow">Post Event Calculation</td>
        </tr>
        <tr>
        <td bgcolor="plum1">Fact table</td>
        <td bgcolor="olivedrab1"> Source tables</td>
        <td bgcolor="palegreen"> Config table</td>
           <td></td>
           <td bgcolor="paleturquoise1" >EventDriver </td>
          <td bgcolor="lightblue"> FillStrategy</td>
  </tr></table></font></td></tr>
       <tr><td colspan="2"><font point-size="22"><table cellspacing="0" cellpadding="4">
         <tr><td bgcolor="grey"> namespace example </td><td bgcolor="grey"> Meaning </td><td bgcolor="grey"> Used for</td></tr>
         <tr><td> no namespace or DA/EM/ </td><td> Owned by Data Aquisition service</td><td> tables, views ...</td></tr>
         <tr><td> DG/EM/ </td><td> Owned by Data Generation servcie</td><td> tables/views ...</td></tr>
         <tr><td> DG/EM/VW/ </td><td> Query or view, not actual table</td><td> view</td></tr>
         <tr><td> DG/EM/GEN/ </td><td> Generated, code view, not in DB</td><td> non-db</td></tr>
         <tr><td> DG/EM/DIM/ </td><td> dimension tables or views used in constructions </td><td> non-db</td></tr>
         <tr><td> DG/GL/DIM/ </td><td> Global objects</td><td> non-db</td></tr>
         <tr><td> /DG/EM/ </td><td> column calculated in data generation,not in original table</td><td> column</td></tr>
         <tr><td> &lt; no namespace&gt; </td><td> plain column presentin source table</td><td>both </td></tr>
          </table></font></td></tr>
     <tr><td bgcolor="black" colspan="2"></td></tr></table></font><xsl:text disable-output-escaping="no">REP&gt;</xsl:text>
      labelloc=top;
      overlap=false;
      rankdir=LR;
      splines=true;
        labeljust=left;
  
  <xsl:call-template name="doit"></xsl:call-template>
    
    }
    <div id="cutEND">cutEND</div>
    </body>
    </html>
    


  
</xsl:template>
  <!-- ********************************* -->
  <xsl:template match="*">
    <ABC>
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates></xsl:apply-templates>
    </xsl:copy>
    </ABC>
  </xsl:template>
  <!-- ********************************* -->
</xsl:stylesheet>
