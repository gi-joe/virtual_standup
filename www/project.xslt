<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet
  version='1.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>


  <xsl:template match='/developer/d[@id = /developer/@selected]'>

    <xsl:variable name='p1' select='property/p[@name="background-color"]'/>
    <xsl:variable name='p2' select='property/p[@name="color"]'/>


    <table border='0' cellpadding='0' cellspacing='3'>
      <caption style='padding: 7; color: gray'> Header </caption>

      <tr>
        <td class='right2'> name </td>
        <td>
          <input type='text' class='t1' value='{@name}' onchange='update({@id}, "developer", "name")' id='{concat(@id, "developer", "name")}'/>
        </td>
      </tr>
      <tr>
        <td class='right2'> background-color </td>
        <td>
          <input type='text' class='t1' value='{$p1/@value}' onchange='update({$p1/@id}, "property", "value", "{$p1/@name}")' id='{concat($p1/@id, "property", "value")}'/>
        </td>
      </tr>
      <tr>
        <td class='right2'> font-color </td>
        <td>
          <input type='text' class='t1' value='{$p2/@value}' onchange='update({$p2/@id}, "property", "value", "{$p2/@name}")' id='{concat($p2/@id, "property", "value")}'/>
        </td>
      </tr>

    </table>
    <br/>


    <table border='0' cellpadding='0' cellspacing='5'>

      <tr>
        <th colspan='6' class='caption2' style='background-color: {$p1/@value}; color: {$p2/@value}' id='{concat("developer", "name")}'>
          <xsl:value-of select='@name'/>
        </th>
      </tr>

      <xsl:if test='count(project/p) &gt; 0'>
        <tr>
          <th>             Project  </th>
          <th colspan='2'> Progress </th>
          <th>             Status   </th>
          <th colspan='2'> To Go    </th>
        </tr>

        <xsl:for-each select='project/p'>
          <xsl:sort select='@new' data-type='number'/>
          <xsl:sort select='@id'  data-type='number'/>

          <xsl:variable name='p' select='.'/>

          <tr id='{@id}'>
            <td>
              <input type='text' class='t1' value='{@name}' onchange='update({@id}, "project", "name")' id='{concat(@id, "project", "name")}' size='30'/>
            </td>

            <td>
              <input type='text' class='t1 right' value='{@percent}' onchange='update({@id}, "project", "percent")' id='{concat(@id, "project", "percent")}' size='3'/>
            </td>

            <td>
              <div class='d1' style='width: 250'>
                <div class='d2' style='width: {@percent}%' id='{concat(@id, "project", "percent", "div")}'>
                  <xsl:choose>
                    <xsl:when test='@percent &gt; 15'>
                      <xsl:value-of select='concat(@percent, "%")'/>
                    </xsl:when>
                    <xsl:otherwise> &#160; </xsl:otherwise>
                  </xsl:choose>
                </div>
              </div>
            </td>

            <td>
              <select onchange='update({@id}, "project", "status")' id='{concat(@id, "project", "status")}'>
                <xsl:for-each select='/developer/misc/status/s'>
                  <xsl:sort select='@position' data-type='number'/>

                  <option value='{@status}'>
                    <xsl:if test='./@status = $p/@status'>
                      <xsl:attribute name='selected'/>
                    </xsl:if>

                    <xsl:value-of select='concat(@icon, " ", @name)'/>
                  </option>
                </xsl:for-each>
              </select>
            </td>

            <td>
              <input type='text' class='t1 right' value='{@estimate}' onchange='update({@id}, "project", "estimate")' id='{concat(@id, "project", "estimate")}' size='3'/>
            </td>

            <td>
              <select onchange='update({@id}, "project", "unit")' id='{concat(@id, "project", "unit")}'>
                <xsl:for-each select='/developer/misc/unit/u'>
                  <option value='{@unit}'>
                    <xsl:if test='./@unit = $p/@unit'>
                      <xsl:attribute name='selected'/>
                    </xsl:if>

                    <xsl:value-of select='@name'/>
                  </option>
                </xsl:for-each>
              </select>
            </td>

            <td class='delete2'>
              <xsl:if test='@id'>
                <a href='javascript:delete_project({@id})'>Delete</a>
              </xsl:if>
            </td>
          </tr>
        </xsl:for-each>
      </xsl:if>

      <tr>
        <td class='back'>
          <a href='javascript:back()'>Back</a>
        </td>
        <td colspan='4'/>
        <td class='add'>
          <xsl:if test='count(project/p[@id]) = count(project/p)'>
            <a href='javascript:add_project({/developer/@selected})'>Add<xsl:if test='count(project/p) = 0'> Project</xsl:if></a>
          </xsl:if>
        </td>
      </tr>

    </table>
  </xsl:template>

</xsl:stylesheet>