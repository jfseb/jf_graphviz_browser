<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:mp="http://schemas.sap.com/sfsf/aa/mp"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	extension-element-prefixes="msxsl" exclude-result-prefixes="mp"
	xmlns:my="urn:sample">
	<xsl:output method="xml" omit-xml-declaration="no"
		encoding="utf-8" indent="yes" />

	<!-- this template extracts the da relevant parts from a config xml -->

	<!-- ********************************* -->
	<!-- ********************************* -->
	<xsl:template match="*">
			<xsl:apply-templates></xsl:apply-templates>
	</xsl:template>


	<xsl:template match="text()">
	</xsl:template>

	<xsl:template match="comment()">
	</xsl:template>

	<!-- ********************************* -->

	<xsl:template match="PhysicalTable[@serviceLayer='DA']">
		<sourceTable _asArrayMember="true" id="{@id}" name="{@id}" label="{@label}">
		  <xsl:for-each select="Column">
			<sourceColumn _asArrayMember="true" id="{@id}" name="{@id}" label="{@label}" dataType="{@dataType}" />
			<!--  what about _precision="{@precision}"  _scale -->
		  </xsl:for-each>
		</sourceTable>
	</xsl:template>

  <!--  root node rule  -->

	<xsl:template match="/">
		<ConfigModel version="v1.0">
		   <MetricPacks>
		      <MetricPack>
		      	<Dataset>
		         	<xsl:apply-templates></xsl:apply-templates>
		      	</Dataset>
		      </MetricPack>
		   </MetricPacks>
		</ConfigModel>
	</xsl:template>


</xsl:stylesheet>
