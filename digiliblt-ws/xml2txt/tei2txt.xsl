<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:key name="chname" match="//*:char" use="@xml:id"/>

    <xsl:template match="*:TEI">
        <doc body-width="70">
            <xsl:apply-templates/>
        </doc>
    </xsl:template>

    <xsl:template match="*:teiHeader">


        <block>
            <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:projectDesc/tei:p[1]"
            />
        </block>
        <block>
            <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:projectDesc/tei:p[2]"
            />
        </block>

        <block bottom-border="_" bottom-border-length="70"/>

        <block>
            <xsl:value-of select="*:fileDesc/*:titleStmt/*:title"/>
        </block>
        <block>
            <xsl:value-of select="*:fileDesc/*:titleStmt/*:author"/>
        </block>


        <xsl:for-each select="//tei:respStmt">
            <block>
                <xsl:value-of select="tei:resp"/>
                <xsl:text>: </xsl:text>
                <xsl:value-of select="tei:name"/>
            </block>

        </xsl:for-each>

        <block>
            <xsl:value-of select="*:fileDesc/*:publicationStmt/*:date"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="//tei:publicationStmt/tei:publisher"/>, <xsl:value-of
                select="//tei:publicationStmt/tei:pubPlace"/>
        </block>

        <block>Fonte: <xsl:value-of select="*:fileDesc/*:sourceDesc/*:p"/></block>

        <block>Licenza Creative Commons Attribuzione - Non commerciale - Condividi allo stesso modo
            3.0 Italia</block>

        <block bottom-border="_" bottom-border-length="70"/>

        <block>

            <block>Le formattazioni sono riprodotte dalla seguente codifica:</block>
            <block>Corsivo: {€testo€}</block>
            <block>Doppia spaziatura di caratteri: {%testo%}</block>
            <block>Grassetto: {$testo$}</block>
            <block>Testo in formato minore: {@testo@}</block>
            <block>Sottolineato: {#testo#}</block>
            <block>Figura: {Fig: didascalia}</block>


        </block>
        <block bottom-border="_" bottom-border-length="70"/>

    </xsl:template>

    <xsl:template match="*:g">
        <xsl:apply-templates/>
        <xsl:text>[</xsl:text><xsl:value-of
            select=" key('chname', substring-after(@ref,'#'))/*:charName"/>]</xsl:template>

    <xsl:template match="*:lg|*:q[@rend='block']">
        <block/>
        <block left-indent="5">
            <xsl:apply-templates/>
        </block>
        <block/>
    </xsl:template>


    <xsl:template match="*:p">
        <block>
            <xsl:apply-templates/>
        </block>
    </xsl:template>


    <xsl:template match="*:l">
        <block new-lines-before="0" new-lines-after="1" left-indent="5">
            <xsl:apply-templates/>
        </block>
    </xsl:template>

    <xsl:template match="*:front"/>


    <xsl:template match="*:div/*:head">
        <block space-after="2" space-before="1">
            <xsl:apply-templates/>
        </block>
    </xsl:template>



    <xsl:template match="*:milestone">


        <xsl:if test="@unit='cap'">
            <xsl:value-of select="@n"/>. </xsl:if>

        <xsl:if test="@unit='par' or @unit='page'">[<xsl:value-of select="@n"/>]</xsl:if>
        <xsl:if test="@unit='subpar' or @unit='MSS'">(<xsl:value-of select="@n"/>)</xsl:if>

    </xsl:template>

    <xsl:template match="*:lb">
        <block new-lines-after="1"> </block>
    </xsl:template>


    <xsl:template match="*:div">

        <xsl:if test="not(*:head) and @n and @type='MSS'">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>). </xsl:text>
        </xsl:if>


        <xsl:if
            test="not(*:head) and @n and not(@type='pr' or @type='index' or @type='ptext' or @type='MSS')">
            <xsl:value-of select="@n"/>
            <xsl:text>. </xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="*:del">[<xsl:apply-templates/>]</xsl:template>

    <xsl:template match="*:corr">&lt;<xsl:apply-templates/>&gt;</xsl:template>


    <xsl:template match="*:unclear">
        <xsl:text>†</xsl:text>
        <xsl:apply-templates/>
        <xsl:if test=" child::node()">†</xsl:if>
    </xsl:template>
    <xsl:template match="*:supplied">&lt;<xsl:apply-templates/>&gt;</xsl:template>



    <xsl:template match="*:gap">
        <xsl:choose>
            <xsl:when test="parent::*:supplied">...</xsl:when>
            <xsl:otherwise>[...]</xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="*:hi">
        <xsl:choose>
            <xsl:when test="@rend='bold'">{$<xsl:apply-templates/>$}</xsl:when>
            <xsl:when test="@rend='italic'">{€<xsl:apply-templates/>€}</xsl:when>
            <xsl:when test="@rend='enlarged'">{%<xsl:apply-templates/>%}</xsl:when>
            <xsl:when test="@rend='expanded'">{%<xsl:apply-templates/>%}</xsl:when>
            <xsl:when test="@rend='small'">{@<xsl:apply-templates/>@}</xsl:when>
            <xsl:when test="@rend='underline'">{#<xsl:apply-templates/>#}</xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*:figure">
        <block new-lines-before="1">
            <xsl:text>{Fig: </xsl:text>
            <xsl:choose>
                <xsl:when test="*:head">
                    <xsl:value-of select="*:head"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="*:figDesc"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>}</xsl:text>
        </block>
    </xsl:template>

    <xsl:template match="*:num">
        <xsl:apply-templates/>
        <xsl:text>(</xsl:text>
        <xsl:value-of select="@value"/>
        <xsl:text>)</xsl:text>
    </xsl:template>

</xsl:stylesheet>
