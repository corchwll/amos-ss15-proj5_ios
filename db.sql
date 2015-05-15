create table projects (
	id integer primary key, 
	name text,
	is_archived boolean
);

create table sessions (
	id integer primary key autoincrement,
	project_id integer,
	timestamp_start integer not null,
	timestamp_end integer not null, 
	foreign key(project_id) references projects(id)
);

insert into projects values (
	1,
	"Illness",
	0
);

insert into projects values (
	2,
	"Holiday",
	0
);

insert into projects values (
	3,
	"Training",
	0
);
