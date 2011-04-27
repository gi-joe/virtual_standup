<?
  $cmd = $_REQUEST['cmd'];

  if ($cmd)
  {
    if (function_exists($cmd)) $cmd();
  }
  else
  {
    if ($_COOKIE['developer']) main(); else login();
  }
?>


<?

  function xml ($data)
  {
    header('Content-Type: text/xml');
    header('Pragma: no-cache');

    $a = pg_fetch_assoc($data);

    echo $a['xml'];
  }


  function json ($data)
  {
    header('Content-Type: application/json');
    header('Pragma: no-cache');

    $a = pg_fetch_all($data);

    echo json_encode($a);
  }

?>


<?

  function login()
  {
    $sql = "
        select
            xmlelement(
                name developer,
                xmlattributes( 'require' as login),
              ( select xmlagg( xmlelement( name d, xmlattributes( d.id, d.name))) from developer d )
            ) as xml;
    ";

    $data = query($sql);

    xml($data);
  }


  function cookie()
  {
    setcookie('developer', $_POST['id'], time() + 60*60*24*30*12*10, '/');

    header('Location: index.html');
  }


  function logout()
  {
    setcookie('developer', $_POST['id'], time() - 60*60*24*30*12*10, '/');

    header('Location: index.html');
  }


  function main()
  {
    $id = $_COOKIE['developer'];

    $sql = "
        select
            xmlelement(
                name developer,
                xmlattributes({$id} as id),

                xmlelement(
                    name misc,

                    xmlelement (
                        name status,
                      ( select xmlagg( xmlelement( name s, xmlattributes( s.status, s.position, s.name, s.icon)))
                        from (
                                  select 'play' status, 1 as position, chr(9658) icon, 'In Progress' as name
                            union select 'pause'status, 2 as position, '||'      icon, 'Paused'
                            union select 'wait' status, 3 as position, chr(63)   icon, 'Waiting'
                            union select 'done' status, 4 as position, chr(10004)icon, 'Done' ) s )),

                    xmlelement (
                        name unit,
                      ( select xmlagg( xmlelement( name u, xmlattributes( u.unit, u.name)))
                        from (
                                  select 'd' unit, 'Days' as name
                            union select 'w' unit, 'Weeks'
                            union select 'm' unit, 'Months' ) u ))
                ),

                ( select xmlagg( xmlelement( name d,
                                             xmlattributes( d.id, d.name, d.is_admin),

                                             xmlelement(
                                                 name project,
                                               ( select xmlagg( xmlelement( name p, xmlattributes( p.id, p.name, p.percent, p.status, p.estimate, p.unit )))
                                                 from project p
                                                 where p.developer_id = d.id )),

                                             xmlelement(
                                                 name property,
                                               ( select xmlagg( xmlelement( name p, xmlattributes( p.id, p.name, p.value )))
                                                 from property p
                                                 where p.developer_id = d.id ))
                ))
                from developer d )
            ) as xml
        ;
    ";

    $data = query($sql);

    xml($data);
  }

?>


<?

  function connection ($p = null)
  {
    $host = $p[0] ? $p[0] : '';
  $dbname = $p[1] ? $p[1] : 'virtual_standup';
    $user = $p[2] ? $p[2] : '';
    $pass = $p[3] ? $p[3] : '';

    $c = pg_connect("host={$host} dbname={$dbname} user={$user} password={$pass}");

    if (!$c) exit;

    return $c;
  }


  function query ($sql, $p = null)
  {
    $cnn = connection($p);
    $res = pg_query($cnn, $sql);

    if (false === $res) exit;

    close($cnn);

    return $res;
  }


  function close ($cnn)
  {
    if ( !is_null($cnn) ) pg_close($cnn);
  }

?>


<?

  function insert()
  {
    $table = $_POST['table'];
    $value = $_POST['value'];

    $sql = "select * from add ('$table', e'$value') as a (xpath varchar, attr varchar, value varchar)";

    $data = query($sql);

    json($data);
  }


  function delete()
  {
    $id    = $_POST['id'   ];
    $table = $_POST['table'];

    $sql = "delete from {$table} where id = {$id}";

    $data = query($sql);

    json($data);
  }


  function update()
  {
    $id    = $_POST['id'   ];
    $table = $_POST['table'];
    $field = $_POST['field'];
    $value = $_POST['value'];

    $sql = "update {$table} set {$field} = e'{$value}' where id = {$id}";

    $data = query($sql);

    json($data);
  }

?>

