
var xml, xsl, idx = 1;


function page_setup()
{
  $.ajax({
       url: 'virtual_standup.php',
     async: false,
  dataType: 'xml',
   success: function (data) {xml = data},
     error: function (e) { error(e.responseText); }
  });

  transform('index.xslt', xml, 'main');
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


function logout() { window.location.href = 'virtual_standup.php?cmd=logout' }


function transform (url, x, i)
{
  clear('error');

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

