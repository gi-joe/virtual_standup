
-- new columns
alter table developer add column fb_id    int     unique,
                      add column fb_name  varchar unique,
                      add column fb_email varchar unique,
                      add column    token varchar unique;

-- FogBugz login info
update developer set fb_id = 2  , fb_name = 'cleo'            , fb_email = 'cleo@perx.com'             where   id =  1001;
update developer set fb_id = 9  , fb_name = 'Devin Torres'    , fb_email = 'dtorres@perx.com'          where   id =  5293;
update developer set fb_id = 10 , fb_name = 'Doug Donaldson'  , fb_email = 'ddonaldson@dargal.com'     where   id =  5124;
update developer set fb_id = 6  , fb_name = 'Kurt Williams'   , fb_email = 'kwilliams@perx.com'        where   id =  1004;
update developer set fb_id = 4  , fb_name = 'Lindsay Martin'  , fb_email = 'lindsay@dargal.com'        where   id =  5145;
update developer set fb_id = 3  , fb_name = 'Michael Boyd'    , fb_email = 'mcboyd@perx.com'           where   id =  1003;
update developer set fb_id = 7  , fb_name = 'Rob Linton'      , fb_email = 'rlinton@perx.com'          where   id =  5339;
update developer set fb_id = 11 , fb_name = 'Sergei Kachanov' , fb_email = 'skachanov@dargal.com'      where   id =  5311;
update developer set fb_id = 8  , fb_name = 'Vanessa Lee'     , fb_email = 'vklee@perx.com'            where   id =  1002;
update developer set fb_id = 18 , fb_name = 'James Bucknall'  , fb_email = 'jbucknall@touchdown.co.uk' where name ~ 'James';


-- new property
insert into property (developer_id, name, value)
select
    p.developer_id,
    'header' as name,
    string_agg( p.name || ': ' || p.value, e'; ') as value

from property p
group by p.developer_id;


-- delete
delete from property where name != 'header';

