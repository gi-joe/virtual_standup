
function email()
{
  $.ajax({
        url: 'virtual_standup.php',
       data: {'cmd':'email'},
   dataType: 'json',
      async: false,
    success: function (data) { document.forms['login'].email.value = data.email },
      error: function (e) { error(e.responseText); }
  });
}


function logon (email, password)
{
  clear();

  var prm = [ 'cmd=logon',
            'email='+email,
         'password='+password ].join('&');

  $.ajax({
    url: api+'?'+prm,
    dataType: 'xml',

    success: function (data)
    {
      var e = xpath(data, '//error[1]/text()');

      if (e) try { error(e.nodeValue) } catch(x) {}
      else
      {
        var f = document.forms[email],
            t = xpath(data, '//token[1]/text()');

        f.token.value = t.nodeValue; f.submit();
      }
    },

    error: function (e) { error(e.responseText); }
  });
}


function logout() { window.location.href = 'virtual_standup.php?cmd=logout' }

