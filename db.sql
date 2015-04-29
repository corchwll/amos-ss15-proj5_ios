create table projects (
	id integer primary key, 
	name text
);

create table sessions (
	id integer primary key autoincrement,
	project_id integer,
	timestamp_start integer not null,
	timestamp_end integer not null, 
	foreign key(project_id) references projects(id)
);
