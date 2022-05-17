<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:mp="http://schemas.sap.com/sfsf/aa/mp"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  extension-element-prefixes="msxsl"
  exclude-result-prefixes="mp" xmlns:my="urn:sample"
><xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>
  <xsl:template match="/">
    <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
     xmlns:o="urn:schemas-microsoft-com:office:office"
     xmlns:x="urn:schemas-microsoft-com:office:excel"
     xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
     xmlns:html="http://www.w3.org/TR/REC-html40">
      <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
        <Author>., Shiwangi</Author>
        <LastAuthor>Forstmann, Gerd</LastAuthor>
        <Created>2020-03-03T07:20:29Z</Created>
        <LastSaved>2020-03-03T19:19:45Z</LastSaved>
        <Company>SAP</Company>
        <Version>16.00</Version>
      </DocumentProperties>
      <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
        <AllowPNG/>
      </OfficeDocumentSettings>
      <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
        <WindowHeight>15720</WindowHeight>
        <WindowWidth>18225</WindowWidth>
        <WindowTopX>5400</WindowTopX>
        <WindowTopY>540</WindowTopY>
        <ProtectStructure>False</ProtectStructure>
        <ProtectWindows>False</ProtectWindows>
      </ExcelWorkbook>
      <Styles>
        <Style ss:ID="Default" ss:Name="Normal">
          <Alignment ss:Vertical="Bottom"/>
          <Borders/>
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
          <Interior/>
          <NumberFormat/>
          <Protection/>
        </Style>
        <Style ss:ID="s16">
          <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
           ss:Bold="1"/>
        </Style>
        <Style ss:ID="s18">
          <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
        </Style>
      </Styles>
      <Worksheet ss:Name="Sheet1">
        <Table ss:ExpandedColumnCount="4" ss:ExpandedRowCount="{count(//PhysicalEntity/Column)+1}" x:FullColumns="1"
         x:FullRows="1" ss:DefaultRowHeight="15">
          <Column ss:Width="184.5"/>
          <Column ss:Width="134.25"/>
          <Column ss:Index="4" ss:Width="134.25"/>
          <Row>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Table Name</Data>
            </Cell>
            <Cell ss:StyleID="s16">
              <Data ss:Type="String">Column</Data>
            </Cell>
          </Row>
          <xsl:for-each select="//PhysicalEntity">
            <xsl:for-each select="Column">
              <Row>
               <!-- <xsl:if test="count(./preceding-sibling::Column)=0"> 
                  <Cell ss:Index="1" ss:MergeDown="{count(following-sibling::Column)}+1" ss:StyleID="s18">
                    <Data ss:Type="String"><xsl:value-of select="parent::*/@id"/></Data>
                  </Cell>
                  </xsl:if> -->
                  <Cell ss:Index="1" ss:StyleID="s18">
                    <Data ss:Type="String"><xsl:value-of select="parent::*/@id"/></Data>
                  </Cell>
                <Cell>
                  <Data ss:Index="2" ss:Type="String"><xsl:value-of select="@id"/></Data>
                </Cell>
              </Row>
            </xsl:for-each>
          </xsl:for-each>
          </Table>
        <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
          <PageSetup>
            <Header x:Margin="0.3"/>
            <Footer x:Margin="0.3"/>
            <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
          </PageSetup>
          <Print>
            <ValidPrinterInfo/>
            <HorizontalResolution>200</HorizontalResolution>
            <VerticalResolution>200</VerticalResolution>
          </Print>
          <Selected/>
          <Panes>
            <Pane>
              <Number>3</Number>
              <ActiveRow>6</ActiveRow>
              <ActiveCol>4</ActiveCol>
            </Pane>
          </Panes>
          <ProtectObjects>False</ProtectObjects>
          <ProtectScenarios>False</ProtectScenarios>
        </WorksheetOptions>
      </Worksheet>
    </Workbook>

  </xsl:template>
</xsl:stylesheet>