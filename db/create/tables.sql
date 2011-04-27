
drop table if exists
    project,
    property,
    developer;

create table developer (
    id serial primary key,
    name varchar not null unique,
   is_admin bool not null default false
);

create table property (
       id serial primary key,
    developer_id int not null references developer(id) on delete cascade,
        name varchar not null,
       value varchar not null
);

create table project (
       id serial primary key,
    developer_id int not null references developer(id) on delete cascade,
        name varchar not null default '',
     percent varchar not null default '0',
      status varchar not null default 'play' check ( status in ('play','pause','wait','done') ),
    estimate varchar not null default '0',
        unit    char not null default 'd' check ( unit in ('d','w','m') )
);

