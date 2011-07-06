
var api = 'http://fogbugz.perx.com/api.asp', token;

var ready = { 'other': false,
             'search': false,
             'people': false };

var xml, xsl, idx = 1, other, search, people;


function page_setup()
{
  setTimeout('if ( !ready.other || !ready.search || !ready.people ) error("The page may need to be reloaded: Ctrl+R")', 3000);

  get_token();

  $.ajax({
        url: 'virtual_standup.php',
   dataType: 'xml',
    success: function (data) { other = data; ready.other = true; ready_(); },
      error: function (e) { error(e.responseText); }
  });


  // list user's filters
  var prm = ['cmd=listFilters','token='+token ].join('&');

  $.ajax({
    url: api+'?'+prm,
    dataType: 'xml',

    success: function (data)
    {
      // remember user's current filter
      var sFilter = xpath(data, '//filter[@status="current"]');
          sFilter = sFilter ? sFilter.getAttribute('sFilter') : 'ez';

      // set current filter to 'vs'
      var prm = ['cmd=setCurrentFilter','token='+token,'sFilter=15' ].join('&');

      $.ajax({
        url: api+'?'+prm,
        dataType: 'xml',

        success: function (data)
        {
          // list cases
          var prm = ['cmd=search','token='+token,'cols='+['sTitle','ixPersonAssignedTo','hrsElapsedExtra','hrsElapsed','hrsCurrEst'].join(',') ].join('&');

          $.ajax({
            url: api+'?'+prm,
            dataType: 'xml',

            success: function (data)
            {
              search = data; ready.search = true; ready_();

              // set the original filter back
              var prm = ['cmd=setCurrentFilter','token='+token,'sFilter='+sFilter ].join('&');

              $.ajax({
                    url: api+'?'+prm,
               dataType: 'xml',
                success: function (data) {},
                  error: function (e) { error(e.responseText); }
              });
            },

            error: function (e) { error(e.responseText); }
          });
        },

        error: function (e) { error(e.responseText); }
      });
    },

    error: function (e) { error(e.responseText); }
  });


  var prm = ['cmd=listPeople',
           'token='+token ].join('&');
  $.ajax({
        url: api+'?'+prm,
   dataType: 'xml',
    success: function (data) { people = data; ready.people = true; ready_(); },
      error: function (e) { error(e.responseText); }
  });
}


function get_token()
{
  $.ajax({
        url: 'virtual_standup.php',
       data: {'cmd':'token'},
   dataType: 'json',
      async: false,
    success: function (data) { token = data.token },
      error: function (e) { error(e.responseText); }
  });
}


function ready_()
{
  if ( ready.other
    && ready.search
    && ready.people ) { xml = join_xml(other, search, people); transform('index.xslt', xml, 'main'); }
}


function join_xml (m1, m2, m3)
{
  m1.documentElement.appendChild( m2.documentElement);
  m1.documentElement.appendChild( m3.documentElement);

  return m1;
}


function more()
{
  xml.documentElement.setAttribute('more','info');

  transform('index.xslt', xml, 'main');
}


function less()
{
  if (xml.documentElement.getAttribute('more'))
      xml.documentElement.attributes.removeNamedItem('more');

  transform('index.xslt', xml, 'main');
}


function edit (id)
{
  xpath(xml, '/*').setAttribute('selected', id);

  transform('project.xslt', xml, 'main');
}


function back() { transform('index.xslt', xml, 'main') }


function transform (url, x, i)
{
  clear('error');

  try{
    $.ajax({
         url: url,
       async: false,
    dataType: 'xml',
     success: function (data) {xsl = data},
       error: function (e) { error('Document is not well formed: <b>'+url+'</b><br/>' + e.responseText); }
    });

    var prc = new XSLTProcessor();
        prc.importStylesheet(xsl);

    var f = prc.transformToFragment(x, document),
        d = document.getElementById(i);

    d.innerHTML = '';
    d.appendChild(f);
  }
  catch(x) { error(x) }
}


function show (action)
{
  if (action == 'add') { $('#developer').val('') }

  $('#'+action+'1').css('display','none');
  $('#'+action+'2').fadeIn('fast');
}


function hide (action)
{
  $('#'+action+'2').css('display','none');
  $('#'+action+'1').fadeIn('fast');
}


function xpath (node, path)
{
  var n = node.ownerDocument || node,
      v = n.createNSResolver(n.documentElement),
      e = n.evaluate(path, node, v, 0, null);

  return e.iterateNext(); // only return the first one
}


function clear()
{
  $('#error').attr('class','');
  $('#error').html('');
}


function error (e)
{
  $('#error').attr('class','error');

  var h = $('#error').html();

  $('#error').html(h + e +'<br/><br/>');
}

