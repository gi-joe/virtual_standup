
drop function if exists add (varchar, varchar);


create function add (
    _table varchar = null,
    _value varchar = null
)
returns setof record
as
$$
declare
    id int;
  name varchar;
   rec record;

begin
    -- xpath will find the appropriate javascript object to update
    create temp table t (xpath varchar, attr varchar, value varchar);

    case _table
        when 'developer' then

            name := _value;

            insert into developer (name) select name;    id := currval('developer_id_seq');
            insert into t select '/developer/d[last()]', 'id', id;
            insert into t select '/developer/d[last()]', 'name', name;

            insert into property (developer_id, name, value)  select id, 'header', 'background-color: white; color: black;';
            insert into t select '/developer/d[last()]/property/p[@name=''header'']', 'id', currval('property_id_seq');
            insert into t select '/developer/d[last()]/property/p[@name=''header'']', 'value', 'background-color: white; color: black;';

        when 'project' then

            id := _value;

            insert into project (developer_id) select id::int;
            insert into t select '/developer/d[@id='|| id ||']/project/p[last()]', 'id', currval('project_id_seq');

    end case;

    -- return
    for rec in select * from t loop return next rec; end loop;

    drop table t;

    return;
end;
$$ language 'plpgsql';

