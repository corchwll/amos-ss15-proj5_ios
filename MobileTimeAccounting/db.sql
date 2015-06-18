create table projects (
	id text primary key, 
	name text,
	final_date integer,
    latitude real,
    longitude real,
	is_archived boolean
);

create table sessions (
	id integer primary key autoincrement,
	project_id text,
	timestamp_start integer not null,
	timestamp_end integer not null, 
	foreign key(project_id) references projects(id)
);

insert into projects values (
	"00001",
	"Vacation",
    0,
    0.0,
    0.0,
	0
);

insert into projects values (
	"00002",
	"Illness",
    0,
    0.0,
    0.0,
	0
);

insert into projects values (
	"00003",
	"Office",
    0,
    0.0,
    0.0,
	0
);

insert into projects values (
    "00004",
    "Training",
    0,
    0.0,
    0.0,
    0
);
