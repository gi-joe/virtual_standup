<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet
  version='1.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>


  <xsl:template match='//d[@id = /developer/@selected]'>

    <xsl:variable name='header' select='property/p[@name="header"]'/>

    <table border='0' cellpadding='0' cellspacing='3'>

      <tr>
        <th/>
        <th class='caption2' style='{$header/@value}' id='{concat("developer", "name")}'>
          <xsl:value-of select='@name'/>
        </th>
      </tr>
      <tr>
        <td class='right2'> name </td>
        <td>
          <input type='text' class='t1' style='width: 100%' value='{@name}' onchange='update({@id}, "developer", "name")' id='{concat(@id, "developer", "name")}'/>
        </td>
      </tr>
      <tr>
        <td class='right2'> header </td>
        <td>
          <textarea rows='2' cols='30' onchange='update({$header/@id}, "property", "value", "{$header/@name}")' id='{concat($header/@id, "property", "value")}'>
            <xsl:value-of select='$header/@value'/>
          </textarea>
        </td>
      </tr>

    </table>


    <br/>
    <fieldset>

      <legend> Other Projects </legend>

      <table border='0' cellpadding='0' cellspacing='5'>
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
            <td class='add'>
              <xsl:if test='count(project/p[@id]) = count(project/p)'>
                <a href='javascript:add_project({/developer/@selected})'>Add Project</a>
              </xsl:if>
            </td>
          </tr>

      </table>

    </fieldset>


    <xsl:variable name='case' select='//case[ixPersonAssignedTo = //d[@id = /developer/@selected]/@fb_id]'/>

    <xsl:if test='count($case) &gt; 0'>

      <script type='text/javascript'>
        var checked = null;
      </script>

      <br/>
      <fieldset>

        <legend> FogBugz </legend>

        <table border='0' cellpadding='0' cellspacing='5'>

          <tr>
            <th colspan='3'> Project / Working On  </th>
            <th> Progress </th>
            <th> </th>
          </tr>

          <xsl:for-each select='$case'>
            <xsl:sort select='@ixBug' data-type='number'/>

            <xsl:variable name='p' select='.'/>

            <xsl:variable name='percent1'>
              <xsl:choose>
                <xsl:when test='hrsCurrEst != 0'>
                  <xsl:value-of select='(hrsElapsedExtra + hrsElapsed) div hrsCurrEst * 100'/>
                </xsl:when>
                <xsl:otherwise> 0 </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name='percent2'>
              <xsl:choose>
                <xsl:when test='$percent1 &gt; 100'>100</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select='$percent1'/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name='percent' select='format-number($percent2, "##0")'/>


            <tr id='{@ixBug}'>
              <td nowrap='' style='text-align: right'>
                <a target='_blank' href='http://fogbugz.perx.com/default.asp?{@ixBug}' class='fogbugz'>
                  <xsl:value-of select='normalize-space(@ixBug)'/>
                </a>
              </td>

              <td nowrap=''>
                <input type='radio' id='ixBug{@ixBug}' name='bug_working_on' onclick='bug_working_on({@ixBug},{ixPersonAssignedTo})' style='cursor: pointer'>
                  <xsl:if test='//person[ixPerson = //d[@id = /developer/@selected]/@fb_id]/ixBugWorkingOn = current()/@ixBug'>
                    <xsl:attribute name='checked'/>

                    <script type='text/javascript'>
                      checked = '<xsl:value-of select='concat("#ixBug", @ixBug)'/>';
                    </script>
                  </xsl:if>
                </input>
              </td>

              <td nowrap='' style='padding-right: 5' id='{concat(@ixBug, "project", "active")}'>
                <label for='ixBug{@ixBug}' style='cursor: pointer'>
                  <xsl:value-of select='normalize-space(sTitle)'/>
                </label>
              </td>

              <td nowrap=''>
                <div class='d1' style='width: 250'>
                  <div class='d2' style='width: {$percent}%' id='{concat(@id, "project", "percent", "div")}'>
                    <xsl:choose>
                      <xsl:when test='$percent &gt; 15'>
                        <xsl:value-of select='concat($percent, "%")'/>
                      </xsl:when>
                      <xsl:otherwise> &#160; </xsl:otherwise>
                    </xsl:choose>
                  </div>
                </div>
              </td>

              <td nowrap='' class='resolve'>
                <a href='javascript:resolve({@ixBug})'>Resolve</a>
              </td>
            </tr>
          </xsl:for-each>

        </table>

      </fieldset>
    </xsl:if>

    <br/>
    <a href='javascript:back()' style='margin-left: 14'>Back</a>

  </xsl:template>


  <xsl:template match='/developer/response'>
  </xsl:template>

</xsl:stylesheet>