<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:transform
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">
  <xsl:output method="xml" indent="yes"/>

<xsl:template match="link/function">
<xref-func><xsl:value-of select="."/></xref-func>
</xsl:template>

<xsl:template match="link/type">
<xref-type><xsl:value-of select="."/></xref-type>
</xsl:template>

<xsl:template match="xref">
<xref-other><xsl:value-of select="@linkend"/></xref-other>
</xsl:template>

<xsl:template match="emphasis">
<emphasis><xsl:value-of select="."/></emphasis>
</xsl:template>

<xsl:template match="literal">
<literal><xsl:value-of select="."/></literal>
</xsl:template>

<xsl:template match="parameter">
<arg><xsl:value-of select="."/></arg>
</xsl:template>

<xsl:template match="para[not(example) and not(informalexample)]">
<para><xsl:apply-templates/></para>
</xsl:template>

<xsl:template match="para[informalexample]">
<para><xsl:apply-templates select="node()[name()!='informalexample']"/></para>
<xsl:apply-templates select="informalexample"/>
</xsl:template>

<xsl:template match="para[example]">
<para><xsl:apply-templates select="node()[name()!='example']"/></para>
<xsl:apply-templates select="example"/>
</xsl:template>

<xsl:template match="varlistentry">
<definition>
	<term><xsl:value-of select="term"/></term>
	<xsl:apply-templates select="listitem/para/child::node()"/>
</definition>
</xsl:template>

<xsl:template match="itemizedlist/listitem/para">
<listitem><xsl:apply-templates/></listitem>
</xsl:template>

<xsl:template match="section | refsect2">
<section>
	<title><xsl:value-of select="title"/></title>
	<xsl:apply-templates select="para | programlisting | example"/>
</section>
</xsl:template>

<xsl:template match="example">
<example>
	<title><xsl:value-of select="title"/></title>
	<xsl:apply-templates select="para | programlisting"/>
</example>
</xsl:template>

<xsl:template match="programlisting">
<programlisting><xsl:value-of select="."/></programlisting>
</xsl:template>

<xsl:template match="footnote"></xsl:template>

<xsl:template match="/">
  <apidoc>
  <module>
    <name><xsl:value-of select="/book/refentry/refnamediv/refname"/></name>
    <summary><xsl:value-of select="/book/refentry/refnamediv/refpurpose"/></summary>
    <description>
      <xsl:for-each select="/book/refentry/refsect1[title='Description']">
        <xsl:apply-templates select="para | section | refsect2"/>
      </xsl:for-each>
    </description>
    <object-hierarchy>
      <xsl:for-each select="/book/refentry/refsect1[title='Object Hierarchy']/synopsis">
        <xsl:copy-of select="text() | link"/>
      </xsl:for-each>
    </object-hierarchy>
  </module>
  <xsl:for-each select="/book/refentry/refsect1[title='Details']/refsect2[contains(title,' ()')]">
    <function>
      <name><xsl:value-of select="indexterm/primary"/></name>
      <since>
               <xsl:value-of select="normalize-space(substring-after(para[starts-with(text(),'Since')], 'Since'))"/>
      </since>
      <doc>
	<xsl:apply-templates select="para[not(starts-with(text(),'Since')) and normalize-space(text())!='']"/>
      </doc>
    </function>
  </xsl:for-each>
  </apidoc>
</xsl:template>
</xsl:transform>

