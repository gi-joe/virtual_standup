<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet
  version='1.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

  <!-- <xsl:include href='more.xslt'/>
  <xsl:include href='login.xslt'/> -->

  <xsl:variable name='d' select='/developer/d[@id = /developer/@id]'/>

  <xsl:variable name='is-admin' select='$d/@is_admin = "true"'/>

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

      <xsl:variable name='v' select='.'/>

      <xsl:variable name='ixBugWorkingOn' select='//person[ixPerson = $v/@fb_id]/ixBugWorkingOn'/>

      <xsl:variable name='case'   select='//case[ixPersonAssignedTo = $v/@fb_id]'/>


      <table class='block' border='0' cellpadding='2' cellspacing='0'>

        <tr>
          <td colspan='2' class='active'>
            <input type='text' class='t3' disabled='true'>
              <xsl:if test='$ixBugWorkingOn != 0'>
                <xsl:attribute name='value'>
                  <xsl:value-of select='normalize-space(//case[@ixBug = $ixBugWorkingOn]/sTitle)'/>
                </xsl:attribute>
              </xsl:if>
            </input>
          </td>
        </tr>

        <tr>
          <th colspan='2' class='caption1' style='{property/p[@name="header"]/@value}'>
            <xsl:choose>
              <xsl:when test='@delete'><xsl:value-of select='@delete'/></xsl:when>
              <xsl:otherwise>
                <xsl:value-of select='@name'/>
                <xsl:if test='count($case) &gt; 0'>
                  <span class='o'>
                    <xsl:value-of select='count($case)'/>
                  </span>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>

          </th>
        </tr>

        <tr>
          <td colspan='2' style='padding: 0'>

            <div class='scroll'>

              <table border='0' cellpadding='0' cellspacing='0' width='100%'>
                <thead>

                  <xsl:for-each select='project/p'>
                    <xsl:sort select='@id' data-type='number'/>

                    <xsl:variable name='p' select='.'/>

                    <xsl:variable name='z'>
                      <xsl:choose>
                        <xsl:when test='position() mod 2 = 1'>z1</xsl:when>
                        <xsl:otherwise>z2</xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>

                    <tr id='tr{@id}'>

                      <td class='{$z} l' style='color: #aaa' nowrap=''>
                        <xsl:if test='$is-admin'>
                          <xsl:attribute name='style'>color: #aaa; cursor: pointer</xsl:attribute>
                          <xsl:attribute name='onmouseover'>document.getElementById('a<xsl:value-of select='@id'/>').style.display = 'block'</xsl:attribute>
                          <xsl:attribute name='onmouseout' >document.getElementById('a<xsl:value-of select='@id'/>').style.display = 'none' </xsl:attribute>
                        </xsl:if>

                        &#160; #<xsl:value-of select='@id'/> &#160;

                        <xsl:if test='$is-admin'>
                          <table cellpadding='5' cellspacing='0' id='a{@id}' class='assign'>
                            <tr>
                              <td class='invert'>
                                #<xsl:value-of select='@id'/>
                              </td>
                            </tr>
                            <xsl:for-each select='$developer/d'>
                              <xsl:sort select='@name'/>
                              <tr>
                                <td nowrap='' class='z3' onmouseover='this.className="z5"' onmouseout='this.className="z3"' onclick='assign({$p/@id},{$v/@id},{@id})'>
                                  <xsl:value-of select='@name'/>
                                </td>
                              </tr>
                            </xsl:for-each>
                          </table>
                        </xsl:if>
                      </td>

                      <td class='{$z} l' style='width: 100%'>
                        <input type='text' class='t2' value='{@name}' disabled='true'/>
                      </td>

                      <td class='{$z} r'>
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

                </thead>
                <tbody>

                  <xsl:for-each select='$case'>
                    <xsl:sort select='@ixBug' data-type='number'/>

                    <xsl:variable name='p' select='.'/>

                    <xsl:variable name='z'>
                      <xsl:choose>
                        <xsl:when test='( position() + count($v/project/p) ) mod 2 = 1'>z1</xsl:when>
                        <xsl:otherwise>z2</xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>

                    <tr id='tr{$p/@ixBug}'>
                      <td class='{$z} l' style='color: #aaa' nowrap=''>
                        <xsl:if test='$is-admin'>
                          <xsl:attribute name='style'>color: #aaa; cursor: pointer</xsl:attribute>
                          <xsl:attribute name='onmouseover'>document.getElementById('b<xsl:value-of select='@ixBug'/>').style.display = 'block'</xsl:attribute>
                          <xsl:attribute name='onmouseout' >document.getElementById('b<xsl:value-of select='@ixBug'/>').style.display = 'none' </xsl:attribute>
                        </xsl:if>

                        <xsl:value-of select='@ixBug'/>

                        <xsl:if test='$is-admin'>
                          <table cellpadding='5' cellspacing='0' id='b{@ixBug}' class='assign'>
                            <tr>
                              <td class='invert'>
                                <xsl:value-of select='@ixBug'/>
                              </td>
                            </tr>
                            <xsl:for-each select='$developer/d'>
                              <xsl:sort select='@name'/>
                              <tr>
                                <td nowrap='' class='z3' onmouseover='this.className="z5"' onmouseout='this.className="z3"' onclick='fb_assign({$p/@ixBug},{$p/ixPersonAssignedTo},{@fb_id})'>
                                  <xsl:value-of select='@name'/>
                                </td>
                              </tr>
                            </xsl:for-each>
                          </table>
                        </xsl:if>
                      </td>

                      <td class='{$z} l' style='width: 100%'>
                        <input type='text' class='t2' value='{normalize-space(sTitle)}' disabled='true'/>
                      </td>

                      <td class='{$z} r'>
                        <xsl:choose>

                          <xsl:when test='/developer/@more="info"'>
                            <xsl:call-template name='more'>
                              <xsl:with-param name='info' select='.'/>
                              <xsl:with-param name='bug' select='$ixBugWorkingOn'/>
                            </xsl:call-template>
                          </xsl:when>

                          <xsl:otherwise>
                            <xsl:choose>

                              <xsl:when test='$ixBugWorkingOn = current()/@ixBug'>
                                <span class='play'>
                                  <xsl:value-of select='//status/s[@status="play"]/@icon'/>
                                </span>
                              </xsl:when>

                              <xsl:otherwise>
                                <span class='pause'>
                                  <xsl:value-of select='//status/s[@status="pause"]/@icon'/>
                                </span>
                              </xsl:otherwise>

                            </xsl:choose>
                          </xsl:otherwise>

                        </xsl:choose>
                      </td>

                    </tr>
                  </xsl:for-each>

                </tbody>
              </table>

            </div>
          </td>
        </tr>


        <tr>
          <td class='logout'>
            <xsl:if test='@id = $d/@id'>
              <a href='javascript:logout()' style='color: gray'>Logout</a>
            </xsl:if>
          </td>

          <td class='edit'>
            <xsl:if test='($is-admin) or (@id = $d/@id)'>
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

      <xsl:if test='$is-admin'>
        <xsl:call-template name='admin'/>
      </xsl:if>

    </div>
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


  <xsl:template name='login'>
    <xsl:param name='developer'/>

    <!-- login -->
    <table border='0' style='width: 100%; height: 70%'>
      <tr>
        <td>

          <table border='0' align='center' width='270'>
            <tr>
              <td>
                <fieldset style='padding-bottom: 1'>
                  <legend> FogBugz </legend>

                  <form id='login' onsubmit='return false'>
                    <table border='0' cellpadding='4' cellspacing='0'>

                      <tr>
                        <td colspan='2'>
                          <select name='email'>
                            <option> - Login As - </option>

                            <xsl:for-each select='$developer/d'>
                              <xsl:sort select='@name'/>

                              <option value='{@email}'>
                                <xsl:value-of select='concat(@name, " - ", @email)'/>
                              </option>
                            </xsl:for-each>
                          </select>

                          <script type='text/javascript'> email() </script>
                        </td>
                      </tr>

                      <tr>
                        <td style='width: 100%'>
                          <input type='password' name='password' class='t1' style='width: 100%'/>
                        </td>
                        <td>
                          <input type='button' value='Login' onclick='logon(this.form.email.value, this.form.password.value)'/>
                        </td>
                      </tr>

                    </table>
                  </form>

                </fieldset>
              </td>
            </tr>
          </table>


        </td>
      </tr>
    </table>

    <!-- forms -->
    <xsl:for-each select='$developer/d'>
      <form method='post' action='virtual_standup.php' id='{@email}' style='display: none'>

        <input type='hidden' name='cmd' value='cookie'/>
        <input type='hidden' name='id' value='{@id}'/>
        <input type='hidden' name='email' value='{@email}'/>
        <input type='hidden' name='token'/>
      </form>
    </xsl:for-each>

  </xsl:template>


</xsl:stylesheet>