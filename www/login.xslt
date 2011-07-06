<?xml version='1.0' encoding='utf-8'?>

<xsl:stylesheet
  version='1.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

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
                        <td>
                          <select name='email'>
                            <option> - Login - </option>

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
                        <td>
                          <input type='password' name='password' class='t1' style='width: 100%' onchange='logon(this.form.email.value, this.value)'/>
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