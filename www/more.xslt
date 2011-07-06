<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet
  version='1.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>


  <xsl:template name='more'>
    <xsl:param name='info'/>
    <xsl:param name='bug' select='0'/>


    <!-- percent -->
    <xsl:variable name='percent'>
      <xsl:choose>
        <xsl:when test='name($info)="case"'>

          <xsl:variable name='p1'>
            <xsl:choose>
              <xsl:when test='$info/hrsCurrEst != 0'>
                <xsl:value-of select='($info/hrsElapsedExtra + $info/hrsElapsed) div $info/hrsCurrEst * 100'/>
              </xsl:when>
              <xsl:otherwise> 0 </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:variable name='p2'>
            <xsl:choose>
              <xsl:when test='$p1 &gt; 100'>100</xsl:when>
              <xsl:otherwise>
                <xsl:value-of select='$p1'/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:value-of select='format-number($p2, "##0")'/>

        </xsl:when>
        <xsl:when test='name($info)="p"'>

          <xsl:value-of select='format-number(@percent, "##0")'/>

        </xsl:when>
      </xsl:choose>
    </xsl:variable>


    <!-- status -->
    <xsl:variable name='status'>
      <xsl:choose>
        <xsl:when test='name($info)="case"'>

          <xsl:choose>
            <xsl:when test='$info/@ixBug = $bug'>play</xsl:when>
            <xsl:otherwise>pause</xsl:otherwise>
          </xsl:choose>

        </xsl:when>
        <xsl:when test='name($info)="p"'>

          <xsl:value-of select='@status'/>

        </xsl:when>
      </xsl:choose>
    </xsl:variable>


    <!-- estimate -->
    <xsl:variable name='estimate'>

      <xsl:variable name='e'>
        <xsl:choose>
          <xsl:when test='name($info)="case"'>

            <xsl:value-of select='concat( format-number( $info/hrsCurrEst - $info/hrsElapsedExtra - $info/hrsElapsed, "##0"), "h")'/>

          </xsl:when>
          <xsl:when test='name($info)="p"'>

            <xsl:value-of select='concat( format-number( $info/@estimate, "##0"), $info/@unit)'/>

          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:if test='substring($e, 1, 1) &gt; 0'>
        <xsl:value-of select='$e'/>
      </xsl:if>

    </xsl:variable>


    <table border='0' cellpadding='0' cellspacing='0' class='info'>
      <tr>

        <td class='a1'>
          <div class='d1' style='width: 40'>
            <div class='d2' style='width: {$percent}%'>&#160;</div>
          </div>
        </td>

        <td class='b1'>
          <img src='./img/{$status}.png' class='i1'/>
        </td>

        <td class='c1'>
          <xsl:value-of select='$estimate'/>
        </td>

      </tr>
    </table>

  </xsl:template>

</xsl:stylesheet>