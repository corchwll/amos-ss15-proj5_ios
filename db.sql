create table projects (
	id text primary key, 
	name text,
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
	"Illness",
	0
);

insert into projects values (
	"00002",
	"Holiday",
	0
);

insert into projects values (
	"00003",
	"Training",
	0
);

insert into projects values (
        "00004",
        "Office",
        0
);
