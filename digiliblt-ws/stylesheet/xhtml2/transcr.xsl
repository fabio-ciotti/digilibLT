<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
   xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
   xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:rng="http://relaxng.org/ns/structure/1.0"
   xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:teix="http://www.tei-c.org/ns/Examples"
   xmlns:html="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   exclude-result-prefixes="a fo rng tei teix" version="2.0">
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p> TEI stylesheet dealing with elements from the transcr module, making HTML output. </p>
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
         <p>Id: $Id: transcr.xsl 9646 2011-11-05 23:39:08Z rahtz $</p>
         <p>Copyright: 2011, TEI Consortium</p>
      </desc>
   </doc>


   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:key name="chname" match="//*:char" use="@xml:id"/>
   <xsl:template match="tei:unclear">
      <xsl:text>†</xsl:text>
      <xsl:apply-templates/>
      <xsl:if test=" child::node()">†</xsl:if>
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc/>
   </doc>
   <xsl:template match="tei:del">[<xsl:apply-templates/>]</xsl:template>

   <xsl:template match="*:g">
      <xsl:apply-templates/>
      <xsl:text>[</xsl:text><xsl:value-of
         select=" key('chname', substring-after(@ref,'#'))/*:charName"/>]</xsl:template>


   <xsl:template match="*:milestone">
      <xsl:if test="@unit='cap'">
         <b>
            <xsl:value-of select="@n"/>
         </b>
      </xsl:if>
      <xsl:if test="@unit='par' or @unit='page'">[<xsl:value-of select="@n"/>]</xsl:if>
      <xsl:if test="@unit='subpar' or @unit='MSS'">(<xsl:value-of select="@n"/>)</xsl:if>
   </xsl:template>

   <xsl:template match="tei:corr">&lt;<xsl:apply-templates/>&gt;</xsl:template>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc> Does not do anything yet. </desc>
   </doc>
   <xsl:template match="tei:supplied">&lt;<xsl:apply-templates/>&gt;</xsl:template>
   
   <xsl:template match="tei:gap">
      <span class="gap">
         <xsl:if test="tei:desc">
            <xsl:attribute name="title">
               <xsl:value-of select="tei:desc"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="parent::*:supplied">...</xsl:when>
            <xsl:otherwise>[...]</xsl:otherwise>
            
         </xsl:choose>
      </span>
   </xsl:template>
   
   <xsl:template match="tei:foreign[@xml:lang='grc']">
      <span style="font-family: Cardo, 'Times New Roman', 'Arial Unicode MS', serif;">
         <xsl:call-template name="rendToClass"/>
         <xsl:apply-templates/>
      </span>
   </xsl:template>
   
   <xsl:template match="*:num">
      <xsl:apply-templates/>(<xsl:value-of select="@value"/>)
   </xsl:template>
   
</xsl:stylesheet>
