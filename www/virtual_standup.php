<?
  $cmd = $_REQUEST['cmd'];

  if ($cmd)
  {
    if (function_exists($cmd)) $cmd();
  }
  else
  {
    if ( $_COOKIE['token'] )
    {
      if ( ok_db() and ok_fb() ) main(); else { setcookie('token', null, time() - 1, '/'); login(); }
    }
    else login();
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


  function token()
  {
    header('Content-Type: application/json');
    header('Pragma: no-cache');

    echo json_encode( array( 'token' => $_COOKIE['token']));
  }


  function email()
  {
    header('Content-Type: application/json');
    header('Pragma: no-cache');

    echo json_encode( array( 'email' => $_COOKIE['email']));
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
              ( select xmlagg( xmlelement( name d, xmlattributes( d.id, d.name, d.fb_email as email))) from developer d where d.fb_email is not null )
            ) as xml;
    ";

    $data = query($sql);

    xml($data);
  }


  function cookie()
  {
    $token = $_POST['token'];
    $email = $_POST['email'];
       $id = $_POST['id'];

    $sql = "update developer set token = '{$token}' where id = {$id}"; query($sql);

    setcookie('token', $token, time() + 60*60*24*30*12*10, '/');
    setcookie('email', $email, time() + 60*60*24*30*12*10, '/');

    header('Location: index.html');
  }


  function logout()
  {
    setcookie('token', $_POST['token'], time() - 60*60*24*30*12*10, '/');

    header('Location: index.html');
  }


  function main()
  {
    $token = $_COOKIE['token'];

    $sql = "
        select
            xmlelement(
                name developer,
                xmlattributes( (select id from developer where token = '{$token}') as id),

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
                                             xmlattributes( d.id, d.name, d.is_admin, d.fb_id),

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
    $host = $p[0] ? $p[0] : '10.20.0.159';
  $dbname = $p[1] ? $p[1] : 'virtual_standup';
    $user = $p[2] ? $p[2] : 'dev_admin';
    $pass = $p[3] ? $p[3] : 'l!3bg0tt';

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


<?

  function ok_db()
  {
    $token = $_COOKIE['token'];

    $sql = "select id from developer where token = '{$token}'";

    $data = query($sql);

    $a = pg_fetch_assoc($data);

    return $a['id'] > 0;
  }


  function ok_fb()
  {
    $token = $_COOKIE['token'];

    $f = fopen("http://fogbugz.perx.com/api.asp?token={$token}&cmd=listStatuses", 'rb');

    $s = stream_get_contents($f);

    fclose($f);

    return !preg_match('/error/i', $s);
  }

?>

