<?xml version="1.0" encoding="utf-8" ?>
<!--
/*
 * Copyright 2007 Abdulla G. Abdurakhmanov (abdulla.abdurakhmanov@gmail.com).
 * 
 * Licensed under the GPL, Version 2 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.gnu.org/copyleft/gpl.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * With any your questions welcome to my e-mail 
 * or blog at http://abdulla-a.blogspot.com.
 */
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsltc="http://xml.apache.org/xalan/xsltc"
    xmlns:redirect="http://xml.apache.org/xalan/redirect"
    extension-element-prefixes="xsltc redirect"
>
    <xsl:output method="text" encoding="UTF-8" indent="no"/>

    <xsl:template name="componentDefaults">
	<xsl:param name="typeName"/>
	<xsl:choose>
	<xsl:when test="typeReference">
            <xsl:if test="typeReference/isSequence = 'true'">
                <xsl:for-each select="typeReference">
            		<xsl:call-template name="elementDefaults"/>
	    	</xsl:for-each>
	    </xsl:if>
	</xsl:when>
	<xsl:otherwise>
	<xsl:variable name="found">
    		<xsl:for-each select="//module/asnTypes/sequenceSets">
			<xsl:variable name="dName"><xsl:call-template name="doMangleIdent"><xsl:with-param name='input' select="name"/></xsl:call-template></xsl:variable>
			<xsl:if test="$dName = $typeName">
            			<xsl:call-template name="elementDefaults">
					<xsl:with-param name="typeName" select="$typeName"/>
				</xsl:call-template>
			</xsl:if>
	    	</xsl:for-each>
	</xsl:variable>	
	
	<xsl:value-of select="$found"/>

	<xsl:if test="string-length($found)&lt;1">
		<!-- Trying to find redefined sequence -->
    		<xsl:for-each select="//module/asnTypes/defineds">
			<xsl:variable name="dName"><xsl:call-template name="doMangleIdent"><xsl:with-param name='input' select="name"/></xsl:call-template></xsl:variable>
			<xsl:if test="$dName = $typeName">
				<xsl:call-template name="componentDefaults"><xsl:with-param name="typeName" select="typeName"/></xsl:call-template>
			</xsl:if>
    		</xsl:for-each>
	</xsl:if>
	</xsl:otherwise>
	</xsl:choose>

    </xsl:template>

</xsl:stylesheet>