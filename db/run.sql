
\c virtual_standup

\cd '/Users/sergei/Projects/virtual_standup/003/db'

\i './create/tables.sql'
\i './create/add.sql'


alter table developer alter column id drop default;

\copy developer from './data/developer.txt'

\copy project (developer_id, name, percent, status, estimate, unit) from './data/project.txt'

\copy property (developer_id, name, value) from './data/property.txt'


select setval('developer_id_seq', (select max(id) from developer) ); -- reset the sequence

alter table developer alter column id set default nextval('developer_id_seq');

