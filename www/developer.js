
function add_developer()
{
  var d = xml.createElement('d');

  d.setAttribute('id','');
  d.setAttribute('new', idx++);
  d.setAttribute('name',' Adding ...');

  var project = d.appendChild( xml.createElement('project') )
     property = d.appendChild( xml.createElement('property') );

  var p = property.appendChild( xml.createElement('p') );

  p.setAttribute('id','');
  p.setAttribute('name','header');
  p.setAttribute('value','background-color: #efefef; color: #bfbfbf;');

  xml.documentElement.appendChild(d);


  $.ajax({
     url: 'virtual_standup.php',
    type: 'post',
    data: {
        'cmd':'insert',
      'table':'developer',
      'value':$('#developer').val()
    },
    dataType: 'json',

    success: function (data)
    {
      for (var i=0; i<data.length; i++)
      {
        var d = data[i];

        xpath(xml, d.xpath).setAttribute(d.attr, d.value);
      }
      transform('index.xslt', xml, 'main');
    },

    error: function (e)
    {
      var d = xpath(xml, '/developer/d[last()]');
          d.parentNode.removeChild(d);

      transform('index.xslt', xml, 'main');

      error(e.responseText);
    }
  });

  transform('index.xslt', xml, 'main'); // placed here to kepp $('#developer').val()
}


function delete_developer ()
{
  var id = $('#remove').val();

  xpath(xml, '/developer/d[@id='+id+']').setAttribute('delete','Deleting ...');

  xpath(xml, '/developer/d[@id='+id+']/property/p[@name="header"]').setAttribute('value','background-color: #efefef; color: #bfbfbf;');

  transform('index.xslt', xml, 'main');


  $.ajax({
     url: 'virtual_standup.php',
    type: 'post',
    data: {
        'cmd':'delete',
      'table':'developer',
         'id': id,
    },
    dataType: 'json',

    success: function (err_msg)
    {
      if (err_msg)
      {
        xpath(xml, '/developer/d[@id='+id+']').attributes.removeNamedItem('delete');

        transform('index.xslt', xml, 'main');

        error(err_msg);
      }
      else {
        var d = xpath(xml, '/developer/d[@id='+id+']');
            d.parentNode.removeChild(d);

        transform('index.xslt', xml, 'main');
      }
    },

    error: function (e)
    {
      xpath(xml, '/developer/d[@id='+id+']').attributes.removeNamedItem('delete');

      transform('index.xslt', xml, 'main');

      error(e.responseText);
    }
  });
}

