<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:fotex="http://www.tug.org/fotex"
   xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
   xmlns="http://www.w3.org/1999/XSL/Format" xmlns:rng="http://relaxng.org/ns/structure/1.0"
   xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:teix="http://www.tei-c.org/ns/Examples"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="fotex a rng tei teix"
   version="2.0">
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p> TEI stylesheet dealing with elements from the textstructure module, making XSL-FO
            output. </p>
         <p>This software is dual-licensed: 1. Distributed under a Creative Commons
            Attribution-ShareAlike 3.0 Unported License
            http://creativecommons.org/licenses/by-sa/3.0/ 2.
            http://www.opensource.org/licenses/BSD-2-Clause All rights reserved. Redistribution and
            use in source and binary forms, with or without modification, are permitted provided
            that the following conditions are met: * Redistributions of source code must retain the
            above copyright notice, this list of conditions and the following disclaimer. *
            Redistributions in binary form must reproduce the above copyright notice, this list of
            conditions and the following disclaimer in the documentation and/or other materials
            provided with the distribution. This software is provided by the copyright holders and
            contributors "as is" and any express or implied warranties, including, but not limited
            to, the implied warranties of merchantability and fitness for a particular purpose are
            disclaimed. In no event shall the copyright holder or contributors be liable for any
            direct, indirect, incidental, special, exemplary, or consequential damages (including,
            but not limited to, procurement of substitute goods or services; loss of use, data, or
            profits; or business interruption) however caused and on any theory of liability,
            whether in contract, strict liability, or tort (including negligence or otherwise)
            arising in any way out of the use of this software, even if advised of the possibility
            of such damage. </p>
         <p>Author: See AUTHORS</p>
         <p>Id: $Id: textstructure.xsl 9646 2011-11-05 23:39:08Z rahtz $</p>
         <p>Copyright: 2011, TEI Consortium</p>
      </desc>
   </doc>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process elements * in inner mode</desc>
   </doc>
   <xsl:template match="*" mode="innertext">
      <xsl:apply-templates select="."/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:*" mode="heading">
      <xsl:apply-templates/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:TEI">
      <root>
         <xsl:call-template name="setupPagemasters"/>
         <xsl:call-template name="mainAction"/>
      </root>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:back">
      <xsl:comment>Back matter</xsl:comment>
      <xsl:choose>
         <xsl:when test="ancestor::tei:group">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <page-sequence format="{$formatBackpage}" text-align="{$alignment}"
               hyphenate="{$hyphenate}" language="{$language}">
               <xsl:call-template name="choosePageMaster">
                  <xsl:with-param name="where">
                     <xsl:value-of select="$backMulticolumns"/>
                  </xsl:with-param>
               </xsl:call-template>
               <!-- static areas -->
               <xsl:choose>
                  <xsl:when test="$twoSided='true'">
                     <xsl:call-template name="headers-footers-twoside-back"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="headers-footers-oneside-back"/>
                  </xsl:otherwise>
               </xsl:choose>
               <!-- now start the main flow -->
               <flow flow-name="xsl-region-body" font-family="{$bodyFont}" font-size="{$bodySize}">
                  <xsl:apply-templates/>
                  <xsl:call-template name="afterBodyHook"/>
               </flow>
            </page-sequence>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:body">
      <xsl:choose>
         <xsl:when test="ancestor::tei:floatingText">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="ancestor::tei:p">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="ancestor::tei:group">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <!-- start page sequence -->

            <!-- cover -->
            <page-sequence hyphenate="{$hyphenate}" language="{$language}"
               force-page-count="no-force">
               <xsl:call-template name="choosePageMaster">
                  <xsl:with-param name="where">
                     <xsl:value-of select="$frontMulticolumns"/>
                  </xsl:with-param>
               </xsl:call-template>
               <static-content flow-name="xsl-region-before">
                  <block/>
               </static-content>
               <static-content flow-name="xsl-region-after">
                  <block/>
               </static-content>
               <flow flow-name="xsl-region-body" font-family="{$bodyFont}" text-align="center">

                  <block text-align="center">
                     <external-graphic width="100%" content-width="scale-to-fit" scaling="uniform"
                        content-height="100%"
                        src="url(http://www.digiliblt.unipmn.it/img/logo_digiliblt.jpg)"/>
                  </block>

                  <block font-size="25pt" space-before="20mm">
                     <xsl:call-template name="generateAuthor"/>
                  </block>

                  <block font-size="30pt" font-weight="bold" space-before="30pt" space-after="20pt">
                     <xsl:call-template name="generateTitle"/>
                  </block>


               </flow>
            </page-sequence>

            <!-- titlePage -->
            <page-sequence format="{$formatFrontpage}" hyphenate="{$hyphenate}"
               language="{$language}" initial-page-number="1" force-page-count="no-force">
               <xsl:call-template name="choosePageMaster">
                  <xsl:with-param name="where">
                     <xsl:value-of select="$frontMulticolumns"/>
                  </xsl:with-param>
               </xsl:call-template>
               <static-content flow-name="xsl-region-before">
                  <block/>
               </static-content>
               <static-content flow-name="xsl-region-after">
                  <block/>
               </static-content>
               <flow flow-name="xsl-region-body" font-family="{$bodyFont}">
                  <xsl:call-template name="Header"/>

                  <block break-before="page" id="toc">
                     <xsl:call-template name="mainTOC"/>
                  </block>
               </flow>
            </page-sequence>


            <page-sequence format="{$formatBodypage}" text-align="{$alignment}"
               hyphenate="{$hyphenate}" language="{$language}" initial-page-number="1">
               <xsl:call-template name="choosePageMaster">
                  <xsl:with-param name="where">
                     <xsl:value-of select="$bodyMulticolumns"/>
                  </xsl:with-param>
               </xsl:call-template>
               <!-- static areas -->
               <xsl:choose>
                  <xsl:when test="$twoSided='true'">
                     <xsl:call-template name="headers-footers-twoside"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="headers-footers-oneside"/>
                  </xsl:otherwise>
               </xsl:choose>
               <!-- now start the main  flow -->
               <flow flow-name="xsl-region-body" font-family="{$bodyFont}" font-size="{$bodySize}">
                  <xsl:if test="not($flowMarginLeft='')">
                     <xsl:attribute name="margin-left">
                        <xsl:value-of select="$flowMarginLeft"/>
                     </xsl:attribute>
                  </xsl:if>
                  <!--include front matter if there is no separate titlepage -->
                  <xsl:if test="not($titlePage='true') and not(preceding-sibling::tei:front)">
                     <xsl:call-template name="Header"/>
                  </xsl:if>
                  <block>
                     <xsl:apply-templates/>
                  </block>
                  <xsl:if test=".//tei:note[@place='end']">
                     <block>
                        <xsl:call-template name="setupDiv2"/>
                        <xsl:text>Notes</xsl:text>
                     </block>
                     <xsl:apply-templates select=".//tei:note[@place='end']" mode="endnote"/>
                  </xsl:if>
               </flow>
            </page-sequence>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:closer">
      <block space-before.optimum="4pt" space-after.optimum="4pt" end-indent="{$exampleMargin}"
         start-indent="{$exampleMargin}">
         <xsl:apply-templates/>
      </block>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:dateline">
      <block text-align="end">
         <xsl:apply-templates/>
      </block>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>

         <p xmlns="http://www.w3.org/1999/XSL/Format"> Normal headings </p>

      </desc>
   </doc>
   <xsl:template match="tei:div">
      <xsl:text>&#10;</xsl:text>
      <xsl:choose>
         <xsl:when test="@type='bibliog'">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="@type='abstract'">
            <block keep-with-next.within-page="always" end-indent="{$exampleMargin}"
               start-indent="{$exampleMargin}">
               <xsl:attribute name="text-align">center</xsl:attribute>
               <xsl:call-template name="setupDiv2"/>
               <inline font-style="italic">Abstract</inline>
            </block>
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="@type='ack'">
            <block keep-with-next.within-page="always">
               <xsl:attribute name="text-align">start</xsl:attribute>
               <xsl:call-template name="setupDiv3"/>
               <inline font-style="italic">Acknowledgements</inline>
            </block>
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <!-- behaviour depends on the nesting level of <div> elements -->
            <xsl:variable name="divlevel" select="count(ancestor::tei:div)"/>
            <xsl:call-template name="NumberedHeading">
               <xsl:with-param name="level">
                  <xsl:value-of select="$divlevel"/>
               </xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>

         <p xmlns="http://www.w3.org/1999/XSL/Format"> headings in TOC </p>

      </desc>
   </doc>
   <xsl:template match="tei:div" mode="toc">
      <xsl:variable name="divlevel">
         <xsl:value-of select="count(ancestor::tei:div)"/>
      </xsl:variable>
      <xsl:call-template name="tocheading">
         <xsl:with-param name="level">
            <xsl:value-of select="$divlevel"/>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:div" mode="xref">
      <xsl:variable name="divlevel" select="count(ancestor::tei:div)"/>
      <xsl:call-template name="xheading">
         <xsl:with-param name="level">div<xsl:value-of select="$divlevel"/>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:div1|tei:div2|tei:div3|tei:div4|tei:div5">
      <xsl:call-template name="NumberedHeading">
         <xsl:with-param name="level">
            <xsl:value-of select="substring-after(local-name(),'div')"/>
         </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process elements tei:div1|tei:div2|tei:div3|tei:div4|tei:div5 (toc mode)</desc>
   </doc>
   <xsl:template match="tei:div1|tei:div2|tei:div3|tei:div4|tei:div5" mode="toc">
      <xsl:call-template name="tocheading">
         <xsl:with-param name="level">
            <xsl:value-of select="substring-after(local-name(),'div')"/>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template mode="xref" match="tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5">
      <xsl:call-template name="xheading">
         <xsl:with-param name="level">
            <xsl:value-of select="local-name()"/>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:div[@type='canto']">
      <xsl:variable name="divlevel" select="count(ancestor::tei:div)"/>
      <xsl:call-template name="NumberedHeading">
         <xsl:with-param name="level">
            <xsl:value-of select="$divlevel"/>
         </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates/>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p xmlns="http://www.w3.org/1999/XSL/Format">Table of contents </p>
      </desc>
   </doc>
   <xsl:template match="tei:divGen">
      <xsl:choose>
         <xsl:when test="@type='toc' and ancestor::tei:text/tei:group">
            <xsl:call-template name="bookTOC"/>
         </xsl:when>
         <xsl:when test="@type='toc'">
            <xsl:call-template name="mainTOC"/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:front"/>
   <!--      <xsl:comment>Front matter</xsl:comment>
      <xsl:choose>
         <xsl:when test="ancestor::tei:floatingText">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="ancestor::tei:p">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="ancestor::tei:group">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="$titlePage='true'">
               <page-sequence format="{$formatFrontpage}" force-page-count="end-on-even" hyphenate="{$hyphenate}" language="{$language}">
                  <xsl:call-template name="choosePageMaster">
                     <xsl:with-param name="where">
                        <xsl:value-of select="$frontMulticolumns"/>
                     </xsl:with-param>
                  </xsl:call-template>
                  <static-content flow-name="xsl-region-before">
                     <block/>
                  </static-content>
                  <static-content flow-name="xsl-region-after">
                     <block/>
                  </static-content>
                  <flow flow-name="xsl-region-body" font-family="{$bodyFont}">
                     <xsl:call-template name="Header"/>
                  </flow>
               </page-sequence>
            </xsl:if>
            <page-sequence format="{$formatFrontpage}" text-align="{$alignment}" hyphenate="{$hyphenate}" language="{$language}"
               initial-page-number="1">
               <xsl:call-template name="choosePageMaster">
                  <xsl:with-param name="where">
                     <xsl:value-of select="$frontMulticolumns"/>
                  </xsl:with-param>
               </xsl:call-template>
               <!-\- static areas -\->
               <xsl:choose>
                  <xsl:when test="$twoSided='true'">
                     <xsl:call-template name="headers-footers-twoside"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="headers-footers-oneside"/>
                  </xsl:otherwise>
               </xsl:choose>
               <!-\- now start the main flow -\->
               <flow flow-name="xsl-region-body" font-family="{$bodyFont}" font-size="{$bodySize}">
                  <xsl:for-each select="tei:*">
                     <xsl:comment>Start <xsl:value-of select="name(.)"/>
                     </xsl:comment>
                     <xsl:apply-templates select="."/>
                     <xsl:comment>End <xsl:value-of select="name(.)"/>
                     </xsl:comment>
                  </xsl:for-each>
               </flow>
            </page-sequence>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
-->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:group/tei:text">
      <xsl:variable name="N">
         <xsl:number/>
      </xsl:variable>
      <page-sequence format="1" text-align="{$alignment}" hyphenate="{$hyphenate}"
         language="{$language}" master-reference="twoside1">
         <xsl:attribute name="initial-page-number">
            <xsl:choose>
               <xsl:when test="$N = 1">1</xsl:when>
               <xsl:otherwise>auto-odd</xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:call-template name="grouptextStatic"/>
         <flow flow-name="xsl-region-body" font-family="{$bodyFont}">
            <xsl:call-template name="textTitle">
               <xsl:with-param name="N" select="$N"/>
            </xsl:call-template>
            <xsl:apply-templates select="tei:body"/>
            <xsl:apply-templates select="tei:back"/>
         </flow>
      </page-sequence>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:group/tei:text/tei:body">
      <xsl:apply-templates/>
      <xsl:if test=".//tei:note[@place='end']">
         <block>
            <xsl:call-template name="setupDiv2"/>
            <xsl:text>Notes</xsl:text>
         </block>
         <xsl:apply-templates select=".//tei:note[@place='end']" mode="endnote"/>
      </xsl:if>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>

         <p xmlns="http://www.w3.org/1999/XSL/Format"> Simple head </p>

      </desc>
   </doc>
   <xsl:template match="tei:head" mode="section">
      <xsl:variable name="text">
         <xsl:apply-templates/>
      </xsl:variable>
      <xsl:value-of select="normalize-space($text)"/>
   </xsl:template>


   <xsl:template name="autoMakeHead">
      <xsl:param name="toc"/>
      <xsl:param name="display"/>
      <xsl:choose>
         <xsl:when test="tei:head">
            <xsl:apply-templates select="tei:head" mode="section"/>
         </xsl:when>
         <xsl:when test="@n">
            <xsl:choose>
               <xsl:when test="@n='pr'"><xsl:if test="$toc='yes'">[pr]</xsl:if>&#160;</xsl:when>
               <xsl:when test="@n='index'"><xsl:if test="$toc='yes'"
                  >[index]</xsl:if>&#160;</xsl:when>
               <xsl:when test="@n='ptext'"><xsl:if test="$toc='yes'"
                  >[ptext]</xsl:if>&#160;</xsl:when>
               <xsl:when test="@type='par'">[<xsl:value-of select="@n"/>]</xsl:when>
               <xsl:when test="@type='MSS'">(<xsl:value-of select="@n"/>)</xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="@n"/>
               </xsl:otherwise>
            </xsl:choose>

         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="count(preceding-sibling::tei:div)=0 and $toc='yes'">
               <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
            </xsl:if>
            <xsl:if test="not(count(preceding-sibling::tei:div)=0) and $toc='yes'">
               <xsl:text>[...]</xsl:text>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element head in heading mode</desc>
   </doc>
   <xsl:template match="tei:head" mode="makeheading">
      <xsl:apply-templates/>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>

         <p xmlns="http://www.w3.org/1999/XSL/Format"> unqualified &lt;head&gt; </p>

      </desc>
   </doc>
   <xsl:template match="tei:head"/>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:opener">
      <block space-before.optimum="4pt" space-after.optimum="4pt" end-indent="{$exampleMargin}"
         start-indent="{$exampleMargin}">
         <xsl:apply-templates/>
      </block>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>

         <p xmlns="http://www.w3.org/1999/XSL/Format"> headings when cross-referenced </p>

      </desc>
   </doc>
   <xsl:template match="tei:text" mode="xref">
      <xsl:choose>
         <xsl:when test="@n">
            <xsl:value-of select="@n"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:number/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:text">
      <xsl:choose>
         <xsl:when test="parent::tei:TEI">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="parent::tei:group">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <block text-align="start" text-indent="0pt" end-indent="{$exampleMargin}"
               start-indent="{$exampleMargin}" font-size="{$exampleSize}" border-top-style="solid"
               border-bottom-style="solid" space-before.optimum="{$exampleBefore}"
               space-after.optimum="{$exampleAfter}">
               <xsl:apply-templates mode="innertext"/>
            </block>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:text" mode="toc">
      <block>
         <xsl:attribute name="font-weight">bold</xsl:attribute>
         <xsl:number/>
         <xsl:text> </xsl:text>
         <inline>
            <xsl:choose>
               <xsl:when test="tei:front/tei:docTitle[@n]">
                  <xsl:value-of select="tei:front/tei:docTitle/@n"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="tei:front/tei:docTitle"/>
               </xsl:otherwise>
            </xsl:choose>
         </inline>
         <leader rule-thickness="0pt"/>
         <inline>
            <xsl:call-template name="linkStyle"/>
            <xsl:variable name="pagref">
               <xsl:choose>
                  <xsl:when test="@xml:id">
                     <xsl:value-of select="@xml:id"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="generate-id()"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <basic-link internal-destination="{$pagref}">
               <page-number-citation ref-id="{$pagref}"/>
            </basic-link>
         </inline>
      </block>
      <block font-style="italic" space-after="10pt" space-before="6pt">
         <xsl:apply-templates select="tei:front//tei:docAuthor" mode="heading"/>
      </block>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:titlePage">
      <block text-align="center">
         <xsl:apply-templates/>
      </block>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:titlePage//tei:titlePart[@type='main']">
      <block font-size="{$titleSize}" space-after="8pt" text-align="center">
         <xsl:apply-templates/>
      </block>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:titlePage//tei:titlePart[@type='sub']">
      <block>
         <block font-size="{$authorSize}" space-after="8pt" text-align="center">
            <xsl:apply-templates/>
         </block>
      </block>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:titlePart">
      <xsl:apply-templates/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:titlePart[@type='running']"/>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:trailer">
      <block>
         <xsl:apply-templates/>
      </block>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process elements text()</desc>
   </doc>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] </desc>
   </doc>
   <!--  <xsl:template name="Header">
      <block font-size="12pt" padding-before="6pt">
         <inline>
	           <xsl:value-of select="$institution"/>
         </inline>
      </block>
    
      <block font-size="12pt" font-weight="bold">
         <xsl:call-template name="generateTitle"/>
      </block>
    
      <block>
         <xsl:call-template name="generateAuthor"/>
      </block>
    
      <block padding-after="6pt">
         <xsl:call-template name="generateDate"/>
      </block>
  </xsl:template>-->

   <xsl:template name="Header">
      <block font-size="12pt" padding-before="6pt" id="head">

         <block space-before="5mm">
            <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:projectDesc/tei:p[1]"/>
         </block>
         <block space-before="1mm">
            <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:projectDesc/tei:p[2]"/>
         </block>
         <block space-before="5mm">
            <xsl:call-template name="generateAuthor"/>
         </block>

         <block font-size="14pt" font-weight="bold">
            <xsl:call-template name="generateTitle"/>
         </block>


         <block space-before="10mm">
            <xsl:for-each select="//tei:respStmt">
               <block>
                  <inline font-style="italic">
                     <xsl:value-of select="tei:resp"/>
                  </inline>
                  <inline>: </inline>
                  <inline>
                     <xsl:value-of select="tei:name"/>
                  </inline>
               </block>

            </xsl:for-each>
         </block>



         <block space-before="10mm">
            <xsl:call-template name="generateDate"/><xsl:text> </xsl:text>
            <xsl:value-of select="//tei:publicationStmt/tei:publisher"/>, <xsl:value-of
               select="//tei:publicationStmt/tei:pubPlace"/>
         </block>
         
         
         <block font-weight="bold" space-before="10mm">Fonte</block>
         <block>
            <xsl:apply-templates select="//tei:fileDesc/tei:sourceDesc"/>
         </block>



         <block text-align="center" space-before="50mm">
            <external-graphic src=" url(https://licensebuttons.net/l/by-nc-sa/3.0/it/88x31.png)"/>
         </block>

         <block font-size="10pt" text-align="center">Licenza Creative Commons Attribuzione - Non
            commerciale - Condividi allo stesso modo 3.0 Italia</block>

         


      </block>
      <block break-before="page">
         <block font-size="14pt" font-weight="bold" space-after="10mm">Nota al testo</block>
         <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:editorialDecl"
         />
      </block>

   </xsl:template>


   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] <param name="level">level</param>
      </desc>
   </doc>
   <xsl:template name="NumberedHeading">
      <xsl:param name="level"/>
      <block keep-with-next.within-page="always">
         <xsl:variable name="divid">
            <xsl:choose>
               <xsl:when test="@xml:id">
                  <xsl:value-of select="@xml:id"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="generate-id()"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:attribute name="id">
            <xsl:value-of select="$divid"/>
         </xsl:attribute>
         <xsl:attribute name="text-align">start</xsl:attribute>
         <xsl:attribute name="font-family">
            <xsl:value-of select="$divFont"/>
         </xsl:attribute>
         <xsl:choose>
            <xsl:when test="$level=0">
               <xsl:call-template name="setupDiv0"/>
            </xsl:when>
            <xsl:when test="$level=1">
               <xsl:call-template name="setupDiv1"/>
            </xsl:when>
            <xsl:when test="$level=2">
               <xsl:call-template name="setupDiv2"/>
            </xsl:when>
            <xsl:when test="$level=3">
               <xsl:call-template name="setupDiv3"/>
            </xsl:when>
            <xsl:when test="$level=4">
               <xsl:call-template name="setupDiv4"/>
            </xsl:when>
            <xsl:when test="$level=5">
               <xsl:call-template name="setupDiv5"/>
            </xsl:when>
            <xsl:when test="$level=6">
               <xsl:call-template name="setupDiv6"/>
            </xsl:when>
         </xsl:choose>
         <xsl:call-template name="blockStartHook"/>
         <xsl:variable name="Number">
            <xsl:if test="$numberHeadings='true' and $numberHeadingsDepth &gt; $level">
               <xsl:call-template name="calculateNumber">
                  <xsl:with-param name="numbersuffix">
                     <xsl:call-template name="headingNumberSuffix"/>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:variable>
         <!--
<xsl:message>**  Calculated   [<xsl:value-of select="$Number"/>] [<xsl:value-of select="$headingNumberSuffix"/>] for <xsl:value-of select="@xml:id"/></xsl:message>
-->
         <xsl:value-of select="$Number"/>

         <xsl:call-template name="autoMakeHead"/>

         <xsl:if test="$divRunningheads='true'">
            <!-- markers for use in running heads -->
            <xsl:choose>
               <xsl:when test="$level=0">
                  <marker marker-class-name="section1"/>
                  <marker marker-class-name="section2"/>
                  <marker marker-class-name="section3"/>
                  <marker marker-class-name="section4"/>
                  <marker marker-class-name="section5"/>
               </xsl:when>
               <xsl:when test="$level=1">
                  <marker marker-class-name="section2"/>
                  <marker marker-class-name="section3"/>
                  <marker marker-class-name="section4"/>
                  <marker marker-class-name="section5"/>
               </xsl:when>
               <xsl:when test="$level=2">
                  <marker marker-class-name="section3"/>
                  <marker marker-class-name="section4"/>
                  <marker marker-class-name="section5"/>
               </xsl:when>
               <xsl:when test="$level=3">
                  <marker marker-class-name="section4"/>
                  <marker marker-class-name="section5"/>
               </xsl:when>
               <xsl:when test="$level=4">
                  <marker marker-class-name="section5"/>
               </xsl:when>
               <xsl:when test="$level=5"/>
            </xsl:choose>
            <marker marker-class-name="section{$level}">
               <xsl:if test="$numberHeadings='true'">
                  <xsl:value-of select="$Number"/>
                  <xsl:call-template name="headingNumberSuffix"/>
               </xsl:if>
               <xsl:call-template name="autoMakeHead"/>
            </marker>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="$foEngine='passivetex'">
               <!-- Passive TeX extension, to get PDF bookmarks -->
               <fotex:bookmark fotex-bookmark-level="{$level}" fotex-bookmark-label="{$divid}">
                  <xsl:if test="$numberHeadings='true'">
                     <xsl:value-of select="$Number"/>
                  </xsl:if>
                  <xsl:value-of select="tei:head"/>
               </fotex:bookmark>
            </xsl:when>
         </xsl:choose>
      </block>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] </desc>
   </doc>
   <xsl:template name="bookTOC">
      <page-sequence format="1" initial-page-number="{$tocStartPage}" master-reference="twoside1">
         <xsl:call-template name="headers-footers-twoside">
            <xsl:with-param name="runeven">even page running head</xsl:with-param>
            <xsl:with-param name="runodd">&#160;odd page running head</xsl:with-param>
         </xsl:call-template>
         <flow flow-name="xsl-region-body" font-family="{$bodyFont}">
            <block text-align="center">
               <xsl:attribute name="font-size">
                  <xsl:value-of select="$tocSize"/>
               </xsl:attribute>
               <xsl:attribute name="text-indent">
                  <xsl:value-of select="$headingOutdent"/>
               </xsl:attribute>
               <xsl:attribute name="font-weight">bold</xsl:attribute>
               <xsl:attribute name="space-after">24pt</xsl:attribute>
               <xsl:attribute name="space-before.optimum">24pt</xsl:attribute>
               <xsl:text>Contents</xsl:text>
            </block>
            <xsl:for-each select="ancestor::tei:text/tei:group/tei:text">
               <xsl:apply-templates select="." mode="toc"/>
            </xsl:for-each>
         </flow>
      </page-sequence>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] <param name="where">where</param>
         <param name="force">force</param>
      </desc>
   </doc>
   <xsl:template name="choosePageMaster">
      <xsl:param name="where"/>
      <xsl:param name="force"/>
      <xsl:variable name="mn">
         <xsl:choose>
            <xsl:when test="$forcePageMaster">
               <xsl:value-of select="$forcePageMaster"/>
            </xsl:when>
            <xsl:when test="not($where='')">
               <xsl:choose>
                  <xsl:when test="$twoSided='true'">twoside2</xsl:when>
                  <xsl:otherwise>oneside2</xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <xsl:choose>
                  <xsl:when test="$twoSided='true'">twoside1</xsl:when>
                  <xsl:otherwise>oneside1</xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:attribute name="master-reference">
         <xsl:value-of select="$mn"/>
      </xsl:attribute>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] </desc>
   </doc>
   <xsl:template name="grouptextStatic">
      <static-content flow-name="xsl-region-after-right">
         <block text-align="end" font-size="{$bodySize}">
            <page-number/>
         </block>
      </static-content>
      <static-content flow-name="xsl-region-after-left">
         <block text-align="start" font-size="{$bodySize}">
            <page-number/>
         </block>
      </static-content>
      <static-content flow-name="xsl-region-before-left">
         <block text-indent="0em" background-color="blue" font-weight="bold" padding="3pt"
            color="white" font-family="{$runFont}" text-align="justify" font-size="{$runSize}">
            <inline>
               <xsl:number/>
            </inline>
            <leader rule-thickness="0pt"/>
            <inline>
               <xsl:choose>
                  <xsl:when test="front/tei:docTitle[@n]">
                     <xsl:value-of select="tei:front/tei:docTitle[@n]"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="tei:front/tei:docTitle"/>
                  </xsl:otherwise>
               </xsl:choose>
            </inline>
         </block>
      </static-content>
      <static-content flow-name="xsl-region-before-right">
         <block background-color="blue" text-indent="0em" font-weight="bold" padding="3pt"
            color="white" text-align="left" font-family="{$runFont}" font-size="{$runSize}">
            <xsl:value-of select="tei:front//tei:docAuthor"/>
         </block>
      </static-content>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] <param name="runhead">runhead</param>
      </desc>
   </doc>
   <xsl:template name="headers-footers-oneside">
      <xsl:param name="runhead"/>
      <static-content flow-name="xsl-region-before" font-family="{$runFont}" font-size="{$runSize}">
         <block>
            <xsl:choose>
               <xsl:when test="$runhead='true'">
                  <xsl:value-of select="$runhead"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="runninghead-author"/>
               </xsl:otherwise>
            </xsl:choose>
         </block>
      </static-content>
      <static-content flow-name="xsl-region-after" font-family="{$runFont}" font-size="{$runSize}">
         <block text-align="center">
            <page-number/>
         </block>
      </static-content>
      <static-content flow-name="xsl-region-before-first" font-family="{$runFont}"
         font-size="{$runSize}"> </static-content>
      <static-content flow-name="xsl-region-after-first" font-family="{$runFont}"
         font-size="{$runSize}">
         <block text-align="center">
            <page-number/>
         </block>
      </static-content>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] <param name="runhead">runhead</param>
      </desc>
   </doc>
   <xsl:template name="headers-footers-oneside-back">
      <xsl:param name="runhead"/>
      <xsl:call-template name="headers-footers-oneside">
         <xsl:with-param name="runhead">
            <xsl:value-of select="$runhead"/>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] <param name="runodd">odd page running head</param>
         <param name="runeven">even page running head</param>
      </desc>
   </doc>
   <xsl:template name="headers-footers-twoside">
      <xsl:param name="runodd"/>
      <xsl:param name="runeven"/>
      <static-content flow-name="xsl-region-before-right" font-family="{$runFont}"
         font-size="{$runSize}">
         <block text-align="end">
            <xsl:choose>
               <xsl:when test="$runodd">
                  <xsl:value-of select="$runodd"/>
               </xsl:when>
               <xsl:when test="$sectionHeaders='true'">
                  <block>
                     <xsl:if test="$divRunningheads='true'">
                        <inline>
                           <retrieve-marker retrieve-class-name="section1"/>
                        </inline>
                     </xsl:if>
                     <leader rule-thickness="0pt"/>
                     <inline> </inline>
                  </block>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="runninghead-title"/>
               </xsl:otherwise>
            </xsl:choose>
         </block>
      </static-content>
      <static-content flow-name="xsl-region-before-left" font-family="{$runFont}"
         font-size="{$runSize}">
         <block text-align="start">
            <xsl:choose>
               <xsl:when test="$runeven">
                  <xsl:value-of select="$runeven"/>
               </xsl:when>
               <xsl:when test="$sectionHeaders='true'">
                  <block>
                     <inline> </inline>
                     <leader rule-thickness="0pt"/>
                     <xsl:if test="$divRunningheads='true'">
                        <inline>
                           <retrieve-marker retrieve-class-name="section0"/>
                        </inline>
                     </xsl:if>
                  </block>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="runninghead-author"/>
               </xsl:otherwise>
            </xsl:choose>
         </block>
      </static-content>
      <static-content flow-name="xsl-region-before-first" font-family="{$runFont}"
         font-size="{$runSize}">
         <block/>
      </static-content>
      <static-content flow-name="xsl-region-after-right" font-family="{$runFont}"
         font-size="{$runSize}">
         <block text-align="justify" text-align-last="justify">
            <inline>digilibLT</inline>
            <xsl:text> </xsl:text>
            <leader leader-pattern="space" leader-length="auto"/>
            <xsl:text> </xsl:text>
            <page-number/>
         </block>
      </static-content>
      <static-content flow-name="xsl-region-after-left" font-family="{$runFont}"
         font-size="{$runSize}">
         <block text-align="justify" text-align-last="justify">
            <page-number/>
            <leader leader-pattern="space" leader-length="auto"/>
            <inline>digilibLT</inline>
         </block>
      </static-content>
      <static-content flow-name="xsl-region-after-first" font-family="{$runFont}"
         font-size="{$runSize}">
         <block text-align="justify" text-align-last="justify">
            <inline>digilibLT</inline>
            <leader leader-pattern="space" leader-length="auto"/>
            <page-number/>
         </block>
      </static-content>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] <param name="runodd">odd page running head</param>
         <param name="runeven">even page running head</param>
      </desc>
   </doc>
   <xsl:template name="headers-footers-twoside-back">
      <xsl:param name="runodd"/>
      <xsl:param name="runeven"/>
      <xsl:call-template name="headers-footers-twoside">
         <xsl:with-param name="runeven">
            <xsl:value-of select="$runeven"/>
         </xsl:with-param>
         <xsl:with-param name="runodd">
            <xsl:value-of select="$runodd"/>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] </desc>
   </doc>
   <xsl:template name="mainAction">
      <xsl:choose>
         <xsl:when test="tei:text/tei:group">
            <xsl:apply-templates select="tei:text/tei:front"/>
            <xsl:apply-templates select="tei:text/tei:group"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates select="tei:text/tei:front"/>
            <xsl:apply-templates select="tei:text/tei:body"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="tei:text/tei:back"/>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] </desc>
   </doc>
   <xsl:template name="mainTOC">
      <block>
         <xsl:call-template name="setupDiv0"/>Sommario</block>
      <!--         <xsl:call-template name="i18n">
            <xsl:with-param name="word">Contents</xsl:with-param>
         </xsl:call-template>-->

      <xsl:choose>
         <xsl:when test="ancestor::tei:text/tei:group">
            <xsl:for-each select="ancestor::tei:text/tei:group">
               <xsl:apply-templates select="tei:text" mode="toc"/>
            </xsl:for-each>
         </xsl:when>
         <xsl:when test="ancestor::tei:text/tei:body/tei:div1">
            <xsl:if test="$tocFront='true'">
               <xsl:for-each
                  select="ancestor::tei:text/tei:front/tei:div1|ancestor::tei:text/tei:front//tei:div2|ancestor::tei:text/tei:front//tei:div3">
                  <xsl:apply-templates mode="toc" select="(.)"/>
               </xsl:for-each>
            </xsl:if>
            <xsl:for-each
               select="ancestor::tei:text/tei:body/tei:div|ancestor::tei:text/tei:body/tei:div1|ancestor::tei:text/tei:body//tei:div2|ancestor::tei:text/tei:body//tei:div3">
               <xsl:apply-templates mode="toc" select="(.)"/>
            </xsl:for-each>
            <xsl:if test="$tocBack='true'">
               <xsl:for-each
                  select="ancestor::tei:text/tei:back/tei:div1|ancestor::tei:text/tei:back//tei:div2|ancestor::tei:text/tei:back//tei:div3">
                  <xsl:apply-templates mode="toc" select="(.)"/>
               </xsl:for-each>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="tocBits"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] </desc>
   </doc>
   <xsl:template name="runninghead-author">
      <xsl:choose>
         <xsl:when test="ancestor::tei:text[1]/tei:front//tei:docAuthor[@type='running']">
            <xsl:apply-templates
               select="ancestor-or-self::tei:text[1]/tei:front//tei:docAuthor[@type='running']"
               mode="heading"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author[1]"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] </desc>
   </doc>
   <xsl:template name="runninghead-title">
      <xsl:comment>Running Head: title</xsl:comment>
      <xsl:choose>
         <xsl:when
            test="ancestor-or-self::tei:text[1]/tei:front//tei:docTitle[1]/tei:titlePart[@type='running']">
            <xsl:apply-templates
               select="/tei:text[1]/tei:front//tei:docTitle[1]/tei:titlePart[@type='running']"
               mode="heading"/>
         </xsl:when>
         <xsl:otherwise>
            <!--            <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>-->
            <xsl:variable name="text"
               select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
            <xsl:variable name="max-text-length" select="90"/>
            <xsl:value-of select="substring($text,1,$max-text-length)"/>
            <!-- truncate the text node to $max-text-length -->
            <xsl:if test="string-length($text) &gt; $max-text-length">
               <!-- add an ellipsis if necessary -->
               <xsl:text>...</xsl:text>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] </desc>
   </doc>
   <xsl:template name="setupPagemasters">
      <layout-master-set>
         <!-- one sided, single column -->
         <simple-page-master master-name="simple1" page-width="{$pageWidth}"
            page-height="{$pageHeight}" margin-top="{$pageMarginTop}"
            margin-bottom="{$pageMarginBottom}" margin-left="{$pageMarginLeft}"
            margin-right="{$pageMarginRight}">
            <region-body margin-bottom="{$bodyMarginBottom}" margin-top="{$bodyMarginTop}"/>
            <region-before extent="{$regionBeforeExtent}"/>
            <region-after extent="{$regionAfterExtent}"/>
         </simple-page-master>
         <!-- for left-hand/tei:even pages in twosided mode, single column -->
         <simple-page-master master-name="left1" page-width="{$pageWidth}"
            page-height="{$pageHeight}" margin-top="{$pageMarginTop}"
            margin-bottom="{$pageMarginBottom}" margin-left="{$pageMarginLeft}"
            margin-right="{$pageMarginRight}">
            <region-body margin-bottom="{$bodyMarginBottom}" margin-top="{$bodyMarginTop}"/>
            <region-before region-name="xsl-region-before-left" extent="{$regionBeforeExtent}"/>
            <region-after region-name="xsl-region-after-left" extent="{$regionAfterExtent}"/>
         </simple-page-master>
         <!-- for right-hand/tei:odd pages in twosided mode, single column -->
         <simple-page-master master-name="right1" page-width="{$pageWidth}"
            page-height="{$pageHeight}" margin-top="{$pageMarginTop}"
            margin-bottom="{$pageMarginBottom}" margin-left="{$pageMarginLeft}"
            margin-right="{$pageMarginRight}">
            <region-body margin-bottom="{$bodyMarginBottom}" margin-top="{$bodyMarginTop}"/>
            <region-before region-name="xsl-region-before-right" extent="{$regionBeforeExtent}"/>
            <region-after region-name="xsl-region-after-right" extent="{$regionAfterExtent}"/>
         </simple-page-master>
         <!-- special case of first page in either mode, single column -->
         <simple-page-master master-name="first1" page-width="{$pageWidth}"
            page-height="{$pageHeight}" margin-top="{$pageMarginTop}"
            margin-bottom="{$pageMarginBottom}" margin-left="{$pageMarginLeft}"
            margin-right="{$pageMarginRight}">
            <region-body margin-bottom="{$bodyMarginBottom}" margin-top="{$bodyMarginTop}"/>
            <region-before region-name="xsl-region-before-first" extent="{$regionBeforeExtent}"/>
            <region-after region-name="xsl-region-after-first" extent="{$regionAfterExtent}"/>
         </simple-page-master>
         <!-- for pages in one-side mode, 2 column -->
         <simple-page-master master-name="simple2" page-width="{$pageWidth}"
            page-height="{$pageHeight}" margin-top="{$pageMarginTop}"
            margin-bottom="{$pageMarginBottom}" margin-left="{$pageMarginLeft}"
            margin-right="{$pageMarginRight}">
            <region-body column-count="{$columnCount}" margin-bottom="{$bodyMarginBottom}"
               margin-top="{$bodyMarginTop}"/>
            <region-before extent="{$regionBeforeExtent}"/>
            <region-after extent="{$regionAfterExtent}"/>
         </simple-page-master>
         <!-- for left-hand/tei:even pages in twosided mode, 2 column -->
         <simple-page-master master-name="left2" page-width="{$pageWidth}"
            page-height="{$pageHeight}" margin-top="{$pageMarginTop}"
            margin-bottom="{$pageMarginBottom}" margin-left="{$pageMarginLeft}"
            margin-right="{$pageMarginRight}">
            <region-body column-count="{$columnCount}" margin-bottom="{$bodyMarginBottom}"
               margin-top="{$bodyMarginTop}"/>
            <region-before region-name="xsl-region-before-left" extent="{$regionBeforeExtent}"/>
            <region-after region-name="xsl-region-after-left" extent="{$regionAfterExtent}"/>
         </simple-page-master>
         <!-- for right-hand/tei:odd pages in twosided mode, 2 column -->
         <simple-page-master master-name="right2" page-width="{$pageWidth}"
            page-height="{$pageHeight}" margin-top="{$pageMarginTop}"
            margin-bottom="{$pageMarginBottom}" margin-left="{$pageMarginLeft}"
            margin-right="{$pageMarginRight}">
            <region-body column-count="{$columnCount}" margin-bottom="{$bodyMarginBottom}"
               margin-top="{$bodyMarginTop}"/>
            <region-before region-name="xsl-region-before-right" extent="{$regionBeforeExtent}"/>
            <region-after region-name="xsl-region-after-right" extent="{$regionAfterExtent}"/>
         </simple-page-master>
         <!-- special case of first page in either mode -->
         <simple-page-master master-name="first2" page-width="{$pageWidth}"
            page-height="{$pageHeight}" margin-top="{$pageMarginTop}"
            margin-bottom="{$pageMarginBottom}" margin-left="{$pageMarginLeft}"
            margin-right="{$pageMarginRight}">
            <region-body column-count="{$columnCount}" margin-bottom="{$bodyMarginBottom}"
               margin-top="{$bodyMarginTop}"/>
            <region-before region-name="xsl-region-before-first" extent="{$regionBeforeExtent}"/>
            <region-after region-name="xsl-region-after-first" extent="{$regionAfterExtent}"/>
         </simple-page-master>
         <!-- setup for double-sided, 1 column, no first page -->
         <page-sequence-master master-name="twoside1nofirst">
            <repeatable-page-master-alternatives>
               <conditional-page-master-reference master-reference="right1" odd-or-even="odd"/>
               <conditional-page-master-reference master-reference="left1" odd-or-even="even"/>
            </repeatable-page-master-alternatives>
         </page-sequence-master>
         <!-- setup for double-sided, 1 column -->
         <page-sequence-master master-name="twoside1">
            <repeatable-page-master-alternatives>
               <conditional-page-master-reference master-reference="first1" page-position="first"/>
               <conditional-page-master-reference master-reference="right1" odd-or-even="odd"/>
               <conditional-page-master-reference master-reference="left1" odd-or-even="even"/>
            </repeatable-page-master-alternatives>
         </page-sequence-master>
         <!-- setup for single-sided, 1 column -->
         <page-sequence-master master-name="oneside1">
            <repeatable-page-master-alternatives>
               <conditional-page-master-reference master-reference="first1" page-position="first"/>
               <conditional-page-master-reference master-reference="simple1"/>
            </repeatable-page-master-alternatives>
         </page-sequence-master>
         <!-- setup for double-sided, 2 column -->
         <page-sequence-master master-name="twoside2">
            <repeatable-page-master-alternatives>
               <conditional-page-master-reference master-reference="first2" page-position="first"/>
               <conditional-page-master-reference master-reference="right2" odd-or-even="odd"/>
               <conditional-page-master-reference master-reference="left2" odd-or-even="even"/>
            </repeatable-page-master-alternatives>
         </page-sequence-master>
         <!-- setup for single-sided, 2 column -->
         <page-sequence-master master-name="oneside2">
            <repeatable-page-master-alternatives>
               <conditional-page-master-reference master-reference="first2" page-position="first"/>
               <conditional-page-master-reference master-reference="simple2"/>
            </repeatable-page-master-alternatives>
         </page-sequence-master>
         <xsl:call-template name="pageMasterHook"/>
      </layout-master-set>
      <xsl:if test="$foEngine='xep'">
         <!-- PDF bookmarks using XEP -->
         <outline xmlns="http://www.renderx.com/XSL/Extensions">
            <xsl:for-each select="/tei:TEI/tei:text/tei:front/tei:div">
               <xsl:call-template name="makeBookMark"/>
            </xsl:for-each>
            <xsl:for-each select="/tei:TEI/tei:text/tei:body/tei:div">
               <xsl:call-template name="makeBookMark"/>
            </xsl:for-each>
            <xsl:for-each select="/tei:TEI/tei:text/tei:back/tei:div">
               <xsl:call-template name="makeBookMark"/>
            </xsl:for-each>
            <!-- now try numbered divs -->
            <xsl:for-each select="/tei:TEI/tei:text/tei:front/tei:div1">
               <xsl:call-template name="makeBookMarkN"/>
            </xsl:for-each>
            <xsl:for-each select="/tei:TEI/tei:text/tei:body/tei:div1">
               <xsl:call-template name="makeBookMarkN"/>
            </xsl:for-each>
            <xsl:for-each select="/tei:TEI/tei:text/tei:back/tei:div1">
               <xsl:call-template name="makeBookMarkN"/>
            </xsl:for-each>
         </outline>
      </xsl:if>

      <xsl:if test="$foEngine='fop'">
         <bookmark-tree>
            <bookmark internal-destination="head">
               <bookmark-title>Frontespizio</bookmark-title>
            </bookmark>
            <bookmark internal-destination="toc">
               <bookmark-title>Sommario</bookmark-title>
            </bookmark>
            <xsl:apply-templates select="//tei:body/tei:div" mode="bookmark"/>
            <!--            <xsl:for-each select="/tei:TEI/tei:text/tei:body/tei:div">
               <bookmark>
                  <xsl:attribute name="internal-destination">
                     <xsl:value-of select="generate-id()"/>
                  </xsl:attribute>
                  <bookmark-title font-weight="bold">
                     <xsl:call-template name="autoMakeHead">
                        <xsl:with-param name="toc">yes</xsl:with-param>
                     </xsl:call-template>
                  </bookmark-title>
               </bookmark>
            </xsl:for-each>-->
         </bookmark-tree>
      </xsl:if>
   </xsl:template>

   <xsl:template match="tei:div" mode="bookmark">
      <bookmark>
         <xsl:attribute name="internal-destination">
            <xsl:value-of select="generate-id()"/>
         </xsl:attribute>
         <bookmark-title font-weight="bold">
            <xsl:call-template name="autoMakeHead">
               <xsl:with-param name="toc">yes</xsl:with-param>
            </xsl:call-template>
         </bookmark-title>
         <xsl:apply-templates select="tei:div" mode="bookmark"/>
      </bookmark>

   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] Make an XEP bookmark</desc>
   </doc>
   <xsl:template name="makeBookMark">
      <xsl:if test="tei:head">
         <bookmark xmlns="http://www.renderx.com/XSL/Extensions">
            <xsl:variable name="depth" select="count(ancestor::tei:div)"/>
            <xsl:attribute name="internal-destination">
               <xsl:choose>
                  <xsl:when test="@xml:id">
                     <xsl:value-of select="@xml:id"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="generate-id()"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <bookmark-label>
               <xsl:if test="$numberHeadings='true' and $numberHeadingsDepth &gt; $depth">
                  <xsl:call-template name="calculateNumber">
                     <xsl:with-param name="numbersuffix">
                        <xsl:call-template name="headingNumberSuffix"/>
                     </xsl:with-param>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
               </xsl:if>
               <xsl:value-of select="tei:head"/>
            </bookmark-label>
            <xsl:for-each select="tei:div">
               <xsl:call-template name="makeBookMark"/>
            </xsl:for-each>
         </bookmark>
      </xsl:if>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] Make an XEP bookmark for numbered divs</desc>
   </doc>
   <xsl:template name="makeBookMarkN">
      <xsl:if test="tei:head">
         <xsl:variable name="depth" select="substring-after(local-name(.),'div')"/>
         <bookmark xmlns="http://www.renderx.com/XSL/Extensions">
            <xsl:attribute name="internal-destination">
               <xsl:choose>
                  <xsl:when test="@xml:id">
                     <xsl:value-of select="@xml:id"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="generate-id()"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <bookmark-label>
               <xsl:if test="$numberHeadings='true' and $numberHeadingsDepth &gt; $depth">
                  <xsl:call-template name="calculateNumber">
                     <xsl:with-param name="numbersuffix">
                        <xsl:call-template name="headingNumberSuffix"/>
                     </xsl:with-param>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
               </xsl:if>
               <xsl:value-of select="tei:head"/>
            </bookmark-label>
            <xsl:choose>
               <xsl:when test="$depth='0'">
                  <xsl:for-each select="tei:div1">
                     <xsl:call-template name="makeBookMarkN"/>
                  </xsl:for-each>
               </xsl:when>
               <xsl:when test="$depth='1'">
                  <xsl:for-each select="tei:div2">
                     <xsl:call-template name="makeBookMarkN"/>
                  </xsl:for-each>
               </xsl:when>
               <xsl:when test="$depth='2'">
                  <xsl:for-each select="tei:div3">
                     <xsl:call-template name="makeBookMarkN"/>
                  </xsl:for-each>
               </xsl:when>
               <xsl:when test="$depth='3'">
                  <xsl:for-each select="tei:div4">
                     <xsl:call-template name="makeBookMarkN"/>
                  </xsl:for-each>
               </xsl:when>
               <xsl:when test="$depth='4'">
                  <xsl:for-each select="tei:div5">
                     <xsl:call-template name="makeBookMarkN"/>
                  </xsl:for-each>
               </xsl:when>
               <xsl:when test="$depth='5'">
                  <xsl:for-each select="tei:div6">
                     <xsl:call-template name="makeBookMarkN"/>
                  </xsl:for-each>
               </xsl:when>
            </xsl:choose>
         </bookmark>
      </xsl:if>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] </desc>
   </doc>
   <xsl:template name="tocBits">
      <xsl:if test="$tocFront='true'">
         <xsl:for-each select="ancestor::tei:text/tei:front//tei:div">
            <xsl:apply-templates mode="toc" select="(.)"/>
         </xsl:for-each>
      </xsl:if>
      <xsl:for-each select="ancestor::tei:text/tei:body//tei:div">
         <xsl:apply-templates mode="toc" select="(.)"/>
      </xsl:for-each>
      <xsl:if test="$tocBack='true'">
         <xsl:for-each select="ancestor::tei:text/tei:back//tei:div">
            <xsl:apply-templates mode="toc" select="(.)"/>
         </xsl:for-each>
      </xsl:if>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] <param name="level">level</param>
      </desc>
   </doc>
   <xsl:template name="tocheading">
      <xsl:param name="level"/>
      <xsl:variable name="tocindent">
         <xsl:choose>
            <xsl:when test="$level='0'">
               <xsl:value-of select="$div0Tocindent"/>
            </xsl:when>
            <xsl:when test="$level='1'">
               <xsl:value-of select="$div1Tocindent"/>
            </xsl:when>
            <xsl:when test="$level='2'">
               <xsl:value-of select="$div2Tocindent"/>
            </xsl:when>
            <xsl:when test="$level='3'">
               <xsl:value-of select="$div3Tocindent"/>
            </xsl:when>
            <xsl:when test="$level='4'">
               <xsl:value-of select="$div4Tocindent"/>
            </xsl:when>
            <xsl:when test="$level='5'">
               <xsl:value-of select="$div5Tocindent"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$div1Tocindent"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <block width="100%" text-align-last="justify" font-size="10pt">
         <xsl:if test="$level='0'">
            <xsl:attribute name="font-weight">bold</xsl:attribute>
         </xsl:if>
         <xsl:attribute name="start-indent">
            <xsl:value-of select="$tocindent"/>
         </xsl:attribute>
         <xsl:variable name="Number">
            <xsl:if test="$numberHeadings='true' and $numberHeadingsDepth &gt; $level">
               <xsl:call-template name="calculateNumber">
                  <xsl:with-param name="numbersuffix" select="$tocNumberSuffix"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:variable>
         <xsl:value-of select="$Number"/>
         <xsl:text> </xsl:text>
         <inline>
            <xsl:call-template name="autoMakeHead">
               <xsl:with-param name="toc">yes</xsl:with-param>
            </xsl:call-template>
         </inline>
         <xsl:text/>
         <leader leader-pattern="space" leader-length="auto"/>
         <xsl:text/>
         <inline>
            <xsl:call-template name="linkStyle"/>
            <xsl:variable name="pagref">
               <xsl:choose>
                  <xsl:when test="@xml:id">
                     <xsl:value-of select="@xml:id"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="generate-id()"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <basic-link internal-destination="{$pagref}">
               <page-number-citation ref-id="{$pagref}"/>
            </basic-link>
         </inline>
      </block>
   </xsl:template>
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] <param name="level">level</param>
      </desc>
   </doc>
   <xsl:template name="xheading">
      <xsl:param name="level"/>
      <xsl:if test="$numberHeadings='true'">
         <xsl:call-template name="calculateNumber"/>
      </xsl:if>
      <xsl:call-template name="divXRefHeading"/>
   </xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[fo] Work out the number of a section <param name="numbersuffix">suffix to add after
            number (typically ". ")</param>
      </desc>
   </doc>
   <xsl:template name="calculateNumber">
      <xsl:param name="numbersuffix"/>
      <xsl:choose>
         <xsl:when test="$prenumberedHeadings='true' and @n">
            <xsl:value-of select="@n"/>
            <xsl:value-of select="$numbersuffix"/>
         </xsl:when>
         <xsl:when test="ancestor::tei:front">
            <xsl:if test="not($numberFrontHeadings='')">
               <xsl:number count="tei:div|tei:div1|tei:div2|tei:div3|tei:div4"
                  format="{$numberFrontHeadings}" from="tei:front" level="multiple"/>
               <xsl:value-of select="$numbersuffix"/>
            </xsl:if>
         </xsl:when>
         <xsl:when test="ancestor::tei:back">
            <xsl:if test="not($numberBackHeadings='')">
               <xsl:call-template name="i18n">
                  <xsl:with-param name="word">appendixWords</xsl:with-param>
               </xsl:call-template>
               <xsl:text> </xsl:text>
               <xsl:number count="tei:div|tei:div1|tei:div2|tei:div3|tei:div4"
                  format="{$numberBackHeadings}" from="tei:back" level="multiple"/>
               <xsl:value-of select="$numbersuffix"/>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:number count="tei:div|tei:div1|tei:div2|tei:div3|tei:div4" from="tei:body"
               level="multiple"/>
            <xsl:value-of select="$numbersuffix"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>
