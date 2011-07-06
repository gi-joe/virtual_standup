

function bug_working_on (ixBug, ixPerson)
{
  var path = '//person[ixPerson = //d[@id = /developer/@selected]/@fb_id]/ixBugWorkingOn/text()';

  clear();

  var prm = ['cmd=startWork',
           'token='+token,
        'ixPerson='+ixPerson,
           'ixBug='+ixBug ].join('&');
  $.ajax({
    url: api+'?'+prm,
    dataType: 'xml',

    success: function (data)
    {
      var e = xpath(data, '//error[1]/text()');

      if (e)
      {
        error(e.nodeValue);

        // 'checked' is not be available when there's no active project
        if (checked) $(checked).attr('checked', true); else $('#ixBug'+ixBug).attr('checked', false);

        try { green (ixBug, 'project', 'active', '#fc9'); } catch(x) {}
      }
      else
      {
        checked = '#ixBug'+ixBug;

        xpath(xml, path).nodeValue = ixBug;

        try { green (ixBug, 'project', 'active'); } catch(x) {}
      }
    },

    error: function (e)
    {
      error(e.responseText);

      if (checked) $(checked).attr('checked', true); else $('#ixBug'+ixBug).attr('checked', false);

      try { green (ixBug, 'project', 'active', '#fc9'); } catch(x) {}
    }
  });
}


function resolve (ix)
{
  $('#'+ix).fadeOut('slow');

  clear();

  var prm = ['cmd=resolve',
           'token='+token,
        'ixStatus=15',
           'ixBug='+ix ].join('&');
  $.ajax({
    url: api+'?'+prm,
    dataType: 'xml',

    success: function (data)
    {
      var e = xpath(data, '//error[1]/text()');

      if (e)
      {
        $('#'+ix).fadeIn('slow');

        error(e.nodeValue);
      }
      else
      {
        var p = xpath(xml, '//case[@ixBug='+ix+']');
            p.parentNode.removeChild(p);

        checked = ('#ixBug'+ix) == checked ? null : checked;
      }
    },

    error: function (e)
    {
      $('#'+ix).fadeIn('slow');

      error(e.responseText);
    }
  });
}


function fb_assign (ix, from, to)
{
  fb_assign_(ix, to);

  clear();

    var prm = ['cmd=assign',
             'token='+token,
'ixPersonAssignedTo='+to,
             'ixBug='+ix ].join('&');
  $.ajax({
    url: api+'?'+prm,
    dataType: 'xml',

    success: function (data)
    {
      var e = xpath(data, '//error[1]/text()');

      if (e)
      {
        assign_(ix, from);

        error(e.nodeValue);
      }
      else
      {
        try { green ('tr', ix, ''); } catch(x) { }
      }
    },

    error: function (e)
    {
      assign_(ix, from);

      error(e.responseText);
    }
  });
}


function fb_assign_ (p, d)
{
  var path = '//case[@ixBug='+p+']/ixPersonAssignedTo/text()';

  xpath(xml, path).nodeValue = d;

  transform('index.xslt', xml, 'main');
}

