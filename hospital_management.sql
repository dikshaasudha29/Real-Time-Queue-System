create table if not exists roles(
id int auto_increment primary key,
name varchar(50) unique not null
);

create table if not exists users (
id int auto_increment primary key,
role_id int not null,
email varchar(200) unique not null,
password_hash varchar(300) not null,
full_name varchar(100) not null,
created_at timestamp default current_timestamp,
foreign key(role_id) references roles(id) on delete restrict
);

create table if not exists triage_system (
id int auto_increment primary key,
patient_id int not null,
clinician_id int null,
symptoms text not null,
severity_score int not null check (severity_score between 1 and 10),
status enum( 'pending' , 'in_progress' , 'completed', 'abandoned') default 'pending',
created_at timestamp default current_timestamp,
updated_at timestamp default current_timestamp on update current_timestamp,
foreign key (patient_id) references users(id) on delete restrict,
foreign key(clinician_id)  references users(id) on delete set null);

create table if not exists audit_logs(
id bigint auto_increment primary key,
session_id int not null,
changed_by_user_id int null,
action varchar(100) not null,
created_at timestamp default current_timestamp,
foreign key (session_id) references triage_system(id) on update cascade on delete restrict,
foreign key (changed_by_user_id) references users(id) on update cascade on delete restrict);

create index idx_users_role on users(role_id);
create index idx_triage_lookup on triage_system ( status, severity_score, created_at);
create index idx_triage_patient on triage_system(patient_id);
create index idx_triage_clinician on triage_system(clinician_id);
create index idx_audit_session on audit_logs(session_id);

insert ignore into roles (id, name) values (1, 'PATIENT'), (2, 'CLINICIAN');