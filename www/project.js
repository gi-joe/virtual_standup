
function add_project (id)
{
  var p = xml.createElement('p');

  p.setAttribute(     'new',  idx++);
  p.setAttribute(    'name', ''    );
  p.setAttribute( 'percent', '0'   );
  p.setAttribute(  'status', 'play');
  p.setAttribute('estimate', '0'   );
  p.setAttribute(    'unit', 'd'   );

  xpath(xml, '/developer/d[@id='+id+']/project').appendChild(p);

  transform('project.xslt', xml, 'main');

  $.ajax({
     url: 'virtual_standup.php',
    type: 'post',
    data: {
        'cmd':'insert',
      'table':'project',
      'value': id
    },
    dataType: 'json',

    success: function (data)
    {
      for (var i=0; i<data.length; i++)
      {
        var d = data[i];

        xpath(xml, d.xpath).setAttribute(d.attr, d.value);
      }
      transform('project.xslt', xml, 'main');
    },

    error: function (e)
    {
      p.parentNode.removeChild(p);

      transform('project.xslt', xml, 'main');

      error(e.responseText);
    }
  });
}


function delete_project (id)
{
  $('#'+id).fadeOut('slow');

  clear();

  $.ajax({
     url: 'virtual_standup.php',
    type: 'post',
    data: {
        'cmd':'delete',
      'table':'project',
         'id': id,
    },
    dataType: 'json',

    success: function (err_msg) {
      if (err_msg)
      {
        $('#'+id).fadeIn('slow');

        error(err_msg);
      }
      else
      {
        var p = xpath(xml, '//project/p[@id='+id+']');
            p.parentNode.removeChild(p);
      }
    },

    error: function (e)
    {
      $('#'+id).fadeIn('slow');

      error(e.responseText);
    }
  });
}


function update (id, table, field, property)
{
  var element = [id, table, field].join(''),
       object = document.getElementById(element),
        value = object.value,
         path = '//'+table+'/*[@id="'+id+'"]';

  if (field == 'percent') percent (id, table, field);

  if (table == 'developer') developer (id, table, field);

  if (property != null) css (id, table, field);

  clear();

  $.ajax({
     url: 'virtual_standup.php',
    type: 'post',
    data: {
        'cmd':'update',
         'id': id,
      'table': table,
      'field': field,
      'value': value,
    },
    dataType: 'json',

    success: function (err_msg)
    {
      if (err_msg) { error(err_msg); }
      else
      {
        xpath(xml, path).setAttribute(field, value);

        try { green (id, table, field); } catch(x) { transform('index.xslt', xml, 'main'); }
      }
    },

    error: function (e) { error(e.responseText); }
  });
}


function assign (project, from, to)
{
  assign_(project, to);

  clear();

  $.ajax({
     url: 'virtual_standup.php',
    type: 'post',
    data: {
        'cmd':'update',
         'id': project,
      'table':'project',
      'field':'developer_id',
      'value': to,
    },
    dataType: 'json',

    success: function (err_msg)
    {
      if (err_msg)
      {
        assign_(project, from);

        error(err_msg);
      }
      else
      {
        try { green ('tr', project, ''); } catch(x) { }
      }
    },

    error: function (e)
    {
      assign_(project, from);

      error(e.responseText);
    }
  });
}


function assign_ (p, d)
{
  var path1 =   '//project/p[@id='+p+']',
      path2 = '//developer/d[@id='+d+']/project';

  var p1 = xpath(xml, path1),
      p2 = xpath(xml, path2).appendChild( p1.cloneNode(true) );

  p1.parentNode.removeChild(p1);

  transform('index.xslt', xml, 'main');
}


function green (id, table, field, color)
{
  var element = [id, table, field].join(''),
       object = document.getElementById(element),
           bc = object.style.backgroundColor;

  switch (object.tagName)
  {
    case 'TR':
      object.style.backgroundColor = '#dfd';
      setTimeout('try { document.getElementById("'+element+'").style.backgroundColor = "'+bc+'" } catch(x) {}', 400);
      break;

    case 'TD':
      color = color ? color : '#dfd';
      object.style.backgroundColor = color;
      setTimeout('try { document.getElementById("'+element+'").style.backgroundColor = "'+bc+'" } catch(x) {}', 400);
      break;

    case 'INPUT':
      object.style.backgroundColor = '#dfd';
      setTimeout('try { document.getElementById("'+element+'").style.backgroundColor = "'+bc+'" } catch(x) {}', 400);
      break;

    case 'SELECT':
      object.style.color = 'green';
      setTimeout('try { document.getElementById("'+element+'").style.color = "black" } catch(x) {}', 400);
      break;
  }
}


function percent (id, table, field)
{
  var element = [id, table, field].join(''),
       object = document.getElementById(element),
        width = object.value,
          div = document.getElementById(element +'div');

  div.style.width = width +'%';

  if (width > 15) { div.innerHTML = width +'%' } else { div.innerHTML = '&#160;' }
}


function developer (id, table, field)
{
  var element = [id, table, field].join(''),
       object = document.getElementById(element),
         name = object.value,
           th = document.getElementById(table + field);

  th.innerHTML = name;
}


function css (id, table, field, property)
{
  var element = [id, table, field].join(''),
       object = document.getElementById(element),
        value = object.value.split(';'),
           th = document.getElementById('developername'),
          map = {};

  for (var i=0; i<value.length; i++)
  {
    if (value[i].indexOf(':') != -1)
    {
      var key = value[i].split(':')[0].replace(/^\s+|\s+$/ig, ''),
          val = value[i].split(':')[1].replace(/^\s+|\s+$/ig, '');

      map[key] = val;
    }
  }

  $(th).css( map);
}

