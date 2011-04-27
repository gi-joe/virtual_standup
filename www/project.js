
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

  if (property != null) css (id, table, field, property);

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


function green (id, table, field)
{
  var element = [id, table, field].join(''),
       object = document.getElementById(element);

  switch (object.tagName)
  {
    case 'INPUT':
      object.style.backgroundColor = '#dfd';
      setTimeout('try { document.getElementById("'+element+'").style.backgroundColor = "#fff" } catch(x) {}', 400);
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
        value = object.value,
           th = document.getElementById('developername');

  $(th).css( property, value);
}

