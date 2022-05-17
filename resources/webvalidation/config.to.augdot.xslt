<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:mp="http://schemas.sap.com/sfsf/aa/mp"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl mp xsl"
>
  <xsl:output method="xml" omit-xml-declaration="no" encoding="utf-8" indent="yes"/>
  <!-- dot directions fact table West -->
  <xsl:param name="DIR_IN" select="':e'"></xsl:param>
  <xsl:param name="DIR_OUT" select="':w'"></xsl:param>

  <xsl:variable name="eventDriverName" select="concat('DG/', //MetricPack/@prefix,'/INT/EVENTDRIVER')"></xsl:variable>

  <xsl:variable name="FACTTABLENAME" select="//FactTable/@id"></xsl:variable>
  <xsl:variable name="FACTTABLEFINNAME" select="concat(//FactTable/@id,'FIN')"></xsl:variable>
  <!-- ********************************* -->
  <xsl:template name="CopySourceColumn">
    <Column src="DA">
      <xsl:copy-of select="@id"></xsl:copy-of>
      <xsl:call-template name="DotPortName1">
        <xsl:with-param name="name" select="@id"></xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="setSemanticInfo"></xsl:call-template>
    </Column>
  </xsl:template>

  <!-- ********************************* -->



  <!-- ********************************* -->

  <xsl:template match="Column">
  <Column src="DA" name="{@id}"   >
    <xsl:copy-of select="@*"></xsl:copy-of>
    <xsl:call-template name="DotPortName1">
      <xsl:with-param name="name" select="@id"></xsl:with-param>
    </xsl:call-template>
    <xsl:for-each select="ColumnRef">
      <xsl:attribute name="columnRef">
        <xsl:value-of select="@columnRef"/>
      </xsl:attribute>
      <xsl:attribute name="entityRef">
        <xsl:value-of select="@entityRef"/>
      </xsl:attribute>
    </xsl:for-each>
  </Column>
  </xsl:template>


  <xsl:template name="CopySourceColumnWithSemantic">
    <xsl:param name="tableName"></xsl:param>
    <xsl:variable name="columnName" select="@id"></xsl:variable>
    <Column src="DA" name="{@id}"  entityRef="{parent::*/@id}" columnRef="{$columnName}">
      <xsl:copy-of select="@semanticType"/>
      <xsl:call-template name="DotPortName1">
        <xsl:with-param name="name" select="@id"></xsl:with-param>
      </xsl:call-template>
    </Column>
  </xsl:template>

  <xsl:template match="Column" mode="makefield">
    <xsl:param name="tableName"></xsl:param>
    <xsl:variable name="columnName" select="@id"></xsl:variable>
    <Column src="DA" name="{@id}"  entityRef="{parent::*/@id}" columnRef="{$columnName}">
      <xsl:copy-of select="@semanticType"/>
      <xsl:call-template name="DotPortName1">
        <xsl:with-param name="name" select="@id"></xsl:with-param>
      </xsl:call-template>
    </Column>
  </xsl:template>


  <!-- ********************************* -->
  <xsl:template name="setSemanticInfo">
    <xsl:variable name="name" select="@id"></xsl:variable>
    <xsl:if test="ancestor::LogicalTable/ColumnSemantic[@id=$name]/@semanticType">
      <xsl:copy-of select="ancestor::LogicalTable/ColumnSemantic[@id=$name]/@*"/>
    </xsl:if>
  </xsl:template>

  <!-- ********************************* -->
  <xsl:template match="MetricPack">
    <NormalizedDGMP prefix="{@prefix}" id="{@id}" name="{@id}">
      <!--  <xsl:copy-of select="@*"/> -->

      <xsl:call-template name="collectBoxes"/>

      <xsl:call-template name="makeFactTables"></xsl:call-template>

  <!--    <xsl:call-template name="collectTableDefinitions">
      </xsl:call-template> -->
        <xsl:call-template name="collectLogicalEntities"/>
        <xsl:call-template name="collectPhysicalEntities"/>
      <xsl:call-template name="collectAliasTableViews"></xsl:call-template>
      <!--
      - <others>
        <xsl:apply-templates></xsl:apply-templates>
      </others>
      -->
    </NormalizedDGMP>
  </xsl:template>



  <xsl:template name="collectLogicalEntities">
  <xsl:for-each select="//LogicalTable">
    <LogicalTable cat="VIEW" type="tableView" tablenamebearer="true">
      <xsl:copy-of select="@*"></xsl:copy-of>
      <xsl:call-template name="DotNodeName1">
        <xsl:with-param name="name" select="@id"></xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates select="Column"/>
       <!-- retain er -->
      <xsl:for-each select="JoinCriteria">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="entityRelationShipID">
            <xsl:value-of select="count(preceding::JoinCriteria)"/>
          </xsl:attribute>
        </xsl:copy>
        <!-- make join boxes -->
        <xsl:apply-templates mode="box" select="."></xsl:apply-templates>
      </xsl:for-each>
      <!-- return function-->
      <xsl:for-each select="Function">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
        <xsl:apply-templates select="ColumnRef"/>
        </xsl:copy>
      </xsl:for-each>
      <xsl:for-each select="Generator">
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates select="ColumnRef"/>
        </xsl:copy>
      </xsl:for-each>
    </LogicalTable>
  </xsl:for-each>
    
  </xsl:template>
  <!-- ********************************* -->
  <xsl:template name="collectPhysicalEntities">
    <xsl:for-each select="//PhysicalTable">
      <PhysicalTable id="{@id}" tablenamebearer="true">
        <xsl:copy-of select="@*"></xsl:copy-of>
        <xsl:call-template name="DotNodeName1">
          <xsl:with-param name="name" select="@id"></xsl:with-param>
        </xsl:call-template>
        <xsl:variable name="entityRef" select="@entityRef"></xsl:variable>
        <!-- pull in source columns (if there is a target table)-->
        <xsl:comment>Pull in source columns if any </xsl:comment>
        <xsl:for-each select="Column">
          <xsl:call-template name="CopySourceColumn"></xsl:call-template>
        </xsl:for-each>
      </PhysicalTable>
    </xsl:for-each>
  </xsl:template>


  <!-- ********************************* -->

  <xsl:template name="DotNodeName1">
    <xsl:param name="name"></xsl:param>
    <xsl:attribute name="DotNodeName">
      <xsl:value-of select="concat('N',translate($name,'/','_'))"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="DotPortName1">
    <xsl:param name="name"></xsl:param>
    <xsl:attribute name="DotPortName">
      <xsl:value-of select="concat('N',translate($name,'/','_'))"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="ColumnRef">
      <ColumnRef>
        <xsl:copy-of select="@*"></xsl:copy-of>
        <xsl:call-template name="DotPortName1">
          <xsl:with-param name="name" select="count(preceding::ColumnRef)"></xsl:with-param>
        </xsl:call-template>
      </ColumnRef>
  </xsl:template>


  <xsl:template match="JoinCriteria" mode="box">
    <JoinBox cat="join" type="box" >
      <xsl:copy-of select="@*"></xsl:copy-of>
      <xsl:copy-of select="Join/@*"></xsl:copy-of>
      <!-- For generators pull in source columns (if there is a target table)-->
      <xsl:for-each select="LogicalOperation">
        <JoinCondition>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates select=".//ColumnRef"/>
        </JoinCondition> 
      </xsl:for-each>
    </JoinBox>
    <xsl:text> 
</xsl:text>
  </xsl:template>


  <!-- ********************************* -->
  <xsl:template name="collectAliasTableViews">

    <xsl:for-each  select="//BaseTableRef[@alias]">
      <xsl:variable name="alias" select="@alias"></xsl:variable>
      <xsl:variable name="entityRef" select="@entityRef"></xsl:variable>
    <!-- if a join uses an alias, e.g. a self join, we generate two "fact" tables with -->
      <LogicalTable dottag="ALIAS" id="{@alias}" tablenamebearer="true" DotNodeName="{concat('AliasLE',count(preceding::*))}">
        <xsl:for-each select="ancestor::LogicalTable//*[@entityRef=$alias]/@columnRef">
          <Column id="{.}" entityRef="{$entityRef}" columnRef="{.}" DotPortName="{concat('DCA',generate-id())}" />
        </xsl:for-each>
        <!-- this generates slightly too many -->
      </LogicalTable>
    </xsl:for-each>
  </xsl:template>


  <!-- ********************************* -->
  <xsl:template name="collectBoxes">
    <EventBox name="{$eventDriverName}" type="box" DotNodeName="EventBox" tablenamebearer="true">
      <xsl:comment>
        connects to all SemanticViews and Generators
        These ports can take multiple inputs!
      </xsl:comment>
      <Column dir="out" name="KEY" DotPortName="TGT_KEY" targetTableName="DG/EM/FACT" targetColumnName="PERSON_ID"/>
      <Column dir="out" name="EVENT_DATE" DotPortName="TGT_EVENT_DATE" targetTableName="DG/EM/FACT" targetColumnName="START_DATE"/>
      <Column dir="out" name="NORM_EVENT" DotPortName="TGT_NORM_EVENT" targetTableName="DG/EM/FACT" targetColumnName="NORM_EVENT"/>
      <Plug dir="in" tag="IN_KEY" DotPortName="IN_KEY" semanticType="KEY"/>
      <Plug dir="in" tag="IN_START_DATE" DotPortName="IN_START_DATE" semanticType="START_DATE"/>
      <Plug dir="in" tag="IN_END_DATE" DotPortName="IN_END_DATE" semanticType="END_DATE"/>
      <Plug dir="in" tag="IN_SEQ_NR" DotPortName="IN_SEQ_NR" semanticType="SEQ_NR"/>
      <Plug dir="in" tag="IN_NORM_EVENT" DotPortName="IN_NORM_EVENT" semanticType="NORM_EVENT"/>
      <Plug dir="in" tag="IN_NORM_EVENT_PRIO" DotPortName="IN_NORM_EVENT_PRIO" semanticType="NORM_EVENT_PRIO"/>
    </EventBox>
  </xsl:template>

  <xsl:template name="getResultTable">
    <xsl:choose>
      <xsl:when test="ancestor::EventBinding">
        <xsl:value-of select="ancestor::EventBinding/TableDefinition/@id"/>
      </xsl:when>
      <xsl:when test="ancestor::PostCalculation">
        <xsl:value-of select="//FactTable/@id"></xsl:value-of>
      </xsl:when>
      <xsl:when test="ancestor::LogicalTable">
        <xsl:value-of select="ancestor::LogicalTable/@id"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text disable-output-escaping="yes"><![CDATA[have noclue]]></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- ********************************* -->
  <xsl:template name="makeFactTables">
     <FactTable id="{$FACTTABLEFINNAME}" cat="table" dottag="FIN" tablenamebearer="true" DotNodeName="{concat('FACT_',count(preceding::*),'FIN')}">
      <xsl:call-template name="collectDimensionsAndMeasuresFIN">
        <xsl:with-param name="FINAL"></xsl:with-param>
      </xsl:call-template>
    </FactTable>
     <FactTable id="{$FACTTABLENAME}" cat="table" tablenamebearer="true" DotNodeName="{concat('FACT_',count(preceding::*),'')}">
      <xsl:call-template name="collectDimensionsAndMeasures">
        <xsl:with-param name="PREPC"></xsl:with-param>
      </xsl:call-template>
      <xsl:for-each select="//DGFactTable/ColumnSemantic">
        <Column id="{@id}" entityRef="{Source/@entityRef}" columnRef="{Source/@columnRef}">
          <xsl:copy-of select="@*"/>
          <xsl:call-template name="DotPortName1">
            <xsl:with-param name="name" select="@id"></xsl:with-param>
          </xsl:call-template>
        </Column>
      </xsl:for-each>
    </FactTable>
  </xsl:template>

  <!-- ********************************* -->
  <!-- ********************************* -->
  <xsl:template name="collectDimensionsAndMeasures">
  <!--  and not postcalc -->
    <xsl:for-each select=".//FactTable/Column">

      <xsl:variable name="measureRef" select="@measureRef"/>
      <xsl:variable name="dimensionRef" select="@dimensionRef"/>
      <xsl:variable name="isPostCalc" select="//*[(local-name() = 'Dimension' or local-name()='BaseMeasure') and ( @id=$dimensionRef or @id=$measureRef ) and @eventStrategyRef = 'POSTCALC' ]"></xsl:variable>
      <xsl:variable name="source" select="//*[(local-name() = 'Dimension' or local-name()='BaseMeasure') and ( @id=$dimensionRef or @id=$measureRef ) and @eventStrategyRef = 'POSTCALC' ]/ColumnRef"></xsl:variable>

      <xsl:choose>
        <xsl:when test="$isPostCalc"/>
        <xsl:when test="@semanticType='KEY'">
          <Column id="{@id}" dataType="{@dataType}" type="DIM" entityRef="{$eventDriverName}" columnRef="KEY">
            <xsl:call-template name="DotPortName1">
              <xsl:with-param name="name" select="@id"></xsl:with-param>
            </xsl:call-template>
          </Column>
        </xsl:when>
        <xsl:when test="@semanticType='START_DATE'">
          <Column id="{@id}" dataType="{@dataType}" type="DIM" entityRef="{$eventDriverName}" columnRef="EVENT_DATE">
            <xsl:call-template name="DotPortName1">
              <xsl:with-param name="name" select="@id"></xsl:with-param>
            </xsl:call-template>
          </Column>
        </xsl:when>
        <xsl:when test="@semanticType='NORM_EVENT'">
          <Column id="{@id}" dataType="{@dataType}" type="DIM" entityRef="{$eventDriverName}" columnRef="NORM_EVENT">
            <xsl:call-template name="DotPortName1">
              <xsl:with-param name="name" select="@id"></xsl:with-param>
            </xsl:call-template>
          </Column>
        </xsl:when>
        <xsl:otherwise>
          <Column id="{@id}" dataType="{@dataType}" type="DIM" >
              <xsl:call-template name="DotPortName1">
                <xsl:with-param name="name" select="@id"></xsl:with-param>
              </xsl:call-template>
            <xsl:for-each select="//Dimension[@id=$dimensionRef]">
              <xsl:copy-of select="ColumnRef/@entityRef"/>
              <xsl:copy-of select="ColumnRef/@columnRef"/>
              <xsl:copy-of select="EventRef/ColumnRef/@entityRef"/>
              <xsl:copy-of select="EventRef/ColumnRef/@columnRef"/>
            </xsl:for-each>
            <xsl:for-each select="//BaseMeasure [@id=$measureRef]">
              <xsl:copy-of select="ColumnRef/@entityRef"/>
              <xsl:copy-of select="ColumnRef/@columnRef"/>
              <xsl:copy-of select="EventRef/ColumnRef/@entityRef"/>
              <xsl:copy-of select="EventRef/ColumnRef/@columnRef"/>
            </xsl:for-each>
           </Column>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- ********************************* -->
  <xsl:template name="collectDimensionsAndMeasuresFIN">
    <!-- points to fact table unless postcalculation-->
    <xsl:for-each select=".//FactTable/Column[not(@semanticType = 'POSTCALCULATION_BASE')]">
      
      <xsl:variable name="measureRef" select="@measureRef"/>
      <xsl:variable name="dimensionRef" select="@dimensionRef"/>

      <xsl:variable name="isPostCalc" select="//*[(local-name() = 'Dimension' or local-name()='BaseMeasure') and ( @id=$dimensionRef or @id=$measureRef ) and @eventStrategyRef = 'POSTCALC' ]"></xsl:variable>
      <xsl:variable name="sourcePost" select="//*[(local-name() = 'Dimension' or local-name()='BaseMeasure') and ( @id=$dimensionRef or @id=$measureRef ) and @eventStrategyRef = 'POSTCALC' ]/ColumnRef"></xsl:variable>
      <xsl:variable name="sourceEntity" select="$sourcePost/entityRef"/>

      <xsl:variable name="isPostCalcBase" select="//LogicalTable[@id=$sourceEntity and type='PostCalculation']"/>
      
      <xsl:choose>
        <xsl:when test="$isPostCalcBase"/>
        <xsl:when test="@semanticType='KEY'">
          <Column id="{@id}" dataType="{@dataType}" type="DIM" entityRef="{$FACTTABLENAME}" columnRef="{@id}">
            <xsl:call-template name="DotPortName1">
              <xsl:with-param name="name" select="@id"></xsl:with-param>
            </xsl:call-template>
          </Column>
        </xsl:when>
        <xsl:when test="@semanticType='START_DATE'">
          <Column id="{@id}" dataType="{@dataType}" type="DIM" entityRef="{$FACTTABLENAME}" columnRef="{@id}">
            <xsl:call-template name="DotPortName1">
              <xsl:with-param name="name" select="@id"></xsl:with-param>
            </xsl:call-template>
          </Column>
        </xsl:when>
        <xsl:when test="@semanticType='NORM_EVENT'">
          <Column id="{@id}" dataType="{@dataType}" type="DIM" entityRef="{$FACTTABLENAME}" columnRef="{@id}">
            <xsl:call-template name="DotPortName1">
              <xsl:with-param name="name" select="@id"></xsl:with-param>
            </xsl:call-template>
          </Column>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$isPostCalc">
              <Column id="{@id}" dataType="{@dataType}" type="DIM" entityRef="{$sourcePost/@entityRef}"  columnRef="{$sourcePost/@columnRef}">
                <xsl:call-template name="DotPortName1">
                  <xsl:with-param name="name" select="@id"></xsl:with-param>
                </xsl:call-template>
                TH IS IS PostCALC 
              </Column>
            </xsl:when>
            <xsl:otherwise>
              <Column id="{@id}" dataType="{@dataType}" type="DIM" entityRef="{$FACTTABLENAME}"  columnRef="{@id}">
                <xsl:call-template name="DotPortName1">
                  <xsl:with-param name="name" select="@id"></xsl:with-param>
                </xsl:call-template>
              </Column>


            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>


  <!-- ********************************* -->
 
</xsl:stylesheet>
