<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet
  version='1.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>


  <xsl:variable name='d' select='/developer/d[@id = /developer/@id]'/>


  <xsl:template match='/developer'>
    <xsl:choose>
      <xsl:when test='@login'>
        <xsl:call-template name='login'>
          <xsl:with-param name='developer' select='.'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name='main'>
          <xsl:with-param name='developer' select='.'/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <xsl:template name='main'>
    <xsl:param name='developer'/>

    <p style='margin-left: 20; color: gray'>
      Welcome <xsl:value-of select='$d/@name'/>
    </p>

    <xsl:for-each select='$developer/d'>
      <xsl:sort select='@new' data-type='number'/>
      <xsl:sort select='@name'/>

      <table class='block' border='0' cellpadding='2' cellspacing='0'>
        <caption class='caption1' style='background-color: {property/p[@name="background-color"]/@value}; color: {property/p[@name="color"]/@value}'>
          <xsl:choose>
            <xsl:when test='@delete'><xsl:value-of select='@delete'/></xsl:when>
            <xsl:otherwise><xsl:value-of select='@name'/></xsl:otherwise>
          </xsl:choose>

        </caption>

        <xsl:for-each select='project/p'>
          <xsl:sort select='@id' data-type='number'/>

          <xsl:variable name='p' select='.'/>

          <tr class='z1'>
            <xsl:attribute name='class'>
              <xsl:choose>
                <xsl:when test='position() mod 2 = 1'>z1</xsl:when>
                <xsl:otherwise>z2</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>

            <td class='l'>
              <input type='text' class='t2' value='{@name}' disabled='true'/>
            </td>

            <td class='r'>
              <xsl:choose>
                <xsl:when test='/developer/@more="info"'>
                  <xsl:call-template name='more'>
                    <xsl:with-param name='info' select='.'/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <span class='{@status}'>
                    <xsl:value-of select='//status/s[@status=$p/@status]/@icon'/>
                  </span>
                </xsl:otherwise>
              </xsl:choose>
            </td>

          </tr>
        </xsl:for-each>

        <tr>
          <td class='logout'>
            <xsl:if test='@id = $d/@id'>
              <a href='javascript:logout()' style='color: gray'>Logout</a>
            </xsl:if>
          </td>

          <td class='edit'>
            <xsl:if test='($d/@is_admin="true") or (@id = $d/@id)'>
              <a href='javascript:edit({@id})'>Edit</a>
            </xsl:if>
          </td>
        </tr>
      </table>

    </xsl:for-each>


    <div style='clear: both; text-align: center'>

      <xsl:choose>
        <xsl:when test='/developer/@more="info"'> More </xsl:when>
        <xsl:otherwise>
          <a href='javascript:more()'>More</a>
        </xsl:otherwise>
      </xsl:choose> |

      <xsl:choose>
        <xsl:when test='not(/developer/@more="info")'> Less </xsl:when>
        <xsl:otherwise>
          <a href='javascript:less()'>Less</a>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test='$d/@is_admin="true"'>
        <xsl:call-template name='admin'/>
      </xsl:if>

    </div>
  </xsl:template>


  <xsl:template name='login'>
    <xsl:param name='developer'/>

    <table class='big' border='0' style='width: 100%; height: 100%'>
      <tr>
        <td>

          <table cellpadding='5' cellspacing='0' width='100' align='center' style='border: 1px solid gray; padding: 7; margin-top: -150'>
            <caption style='padding: 7; color: #aaa'> Login as </caption>

            <xsl:for-each select='$developer/d'>
              <xsl:sort select='@name'/>
              <tr>
                <td nowrap='' onmouseover='this.className="z5"' onclick='document.forms["{@name}"].submit()'>

                  <xsl:attribute name='class'>
                    <xsl:choose>
                      <xsl:when test='position() mod 2 = 0'>z3</xsl:when>
                      <xsl:otherwise>z4</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>

                  <xsl:attribute name='onmouseout'>
                    <xsl:choose>
                      <xsl:when test='position() mod 2 = 0'>this.className='z3'</xsl:when>
                      <xsl:otherwise>this.className='z4'</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>

                  <xsl:value-of select='@name'/>

                  <form method='post' action='virtual_standup.php' id='{@name}' style='display: none'>
                    <input type='hidden' name='cmd' value='cookie'/>
                    <input type='hidden' name='id' value='{@id}'/>
                  </form>
                </td>
              </tr>
            </xsl:for-each>
          </table>

        </td>
      </tr>
    </table>

  </xsl:template>


  <xsl:template name='more'>
    <xsl:param name='info'/>

    <table border='0' cellpadding='0' cellspacing='0' class='info'>
      <tr>
        <td class='a'>
          <div class='d1' style='width: 40'>
            <div class='d2' style='width: {$info/@percent}%'>&#160;</div>
          </div>
        </td>
        <td class='b'>
          <img src='./img/{$info/@status}.png' class='i1'/>
        </td>
        <td class='c'>
          <xsl:if test='$info/@estimate != 0'>
            <xsl:value-of select='concat($info/@estimate, $info/@unit)'/>
          </xsl:if>
        </td>
      </tr>
    </table>

  </xsl:template>


  <xsl:template name='admin'>

    | <a id='add1' href='javascript:show("add")' style='color: green'>Add</a>

    <span id='add2' style='display: none'>
      <a href='javascript:hide("add")'>Cancel</a> &#160;

      <input type='text' id='developer' size='9' class='t1'/>

      &#160; <a href='javascript:add_developer()' style='color: green'>Add</a>
    </span>


    | <a id='remove1' href='javascript:show("remove")' style='color: red'>Remove</a>

    <span id='remove2' style='display: none'>
      <a href='javascript:hide("remove")'>Cancel</a> &#160;

      <select id='remove'>
        <xsl:for-each select='/developer/d[@id != $d/@id]'>
          <xsl:sort select='@name'/>

          <option value='{@id}'>
            <xsl:value-of select='@name'/>
          </option>
        </xsl:for-each>
      </select>

      &#160; <a href='javascript:delete_developer()' style='color: red'>Remove</a>
    </span>

  </xsl:template>

</xsl:stylesheet>