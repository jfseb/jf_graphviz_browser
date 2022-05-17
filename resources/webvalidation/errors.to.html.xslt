<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="nrwarn" select="10"></xsl:param>
<xsl:param name="nrerr" select="20"></xsl:param>

	<!-- format each error into a tr -->
	<xsl:template match="Error">
	<xsl:if test="count(preceding::Error) &lt; $nrerr">
		<tr>
		<td class="error">
		  <xsl:value-of select="count(preceding::Error)"/>
		</td>
			<td class="error">
				<xsl:value-of select="@rule"></xsl:value-of>
				</td>
			<td class="error">
				<xsl:value-of select="."/>
			</td>
			<td class="error_pos">
				<xsl:value-of select="@position"></xsl:value-of>
			</td>
			</tr>
	</xsl:if>
		<xsl:apply-templates />
	</xsl:template>
	
		<!-- format each error into a tr -->
	<xsl:template match="Warning">
	<xsl:if test="count(preceding::Warning) &lt; $nrwarn">
		<tr>
		<td class="warning nr">
		  <xsl:value-of select="count(preceding::Warning)"/>
		</td>
				<td class="warning">
				<xsl:value-of select="@rule"></xsl:value-of>
				</td>
			<td class="warning">
				<xsl:value-of select="."/>
			</td>
			<td class="warning_pos">
				<xsl:value-of select="@position"></xsl:value-of>
			</td>
		</tr>
		<xsl:apply-templates />
	</xsl:if>
	</xsl:template>


<!-- Template rule for root -->
	<xsl:template match="text()"></xsl:template>
	
	<!-- Template rule for root -->
	<xsl:template match="/">
		<table>
			<xsl:choose>
				<xsl:when test="count(//Error)=0">
					<tr>
						<td colspan="4" class="headerok" > Congratutions, your document is valid ( at least
							according to these checks ) </td>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td colspan="4" class="headererror"> Ooops, we think something is flawed: 
						Errors: <xsl:value-of select="count(//Error)"/> Warnings:  <xsl:value-of select="count(//Warning)"/> 
						</td>
					</tr>
					
				</xsl:otherwise>

			</xsl:choose>
			<xsl:apply-templates select="//Error" />
			<xsl:apply-templates select="//Warning" />
		</table>
	</xsl:template>

</xsl:stylesheet>