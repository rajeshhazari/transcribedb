INSERT INTO STATES_MASTER  (STATE_CODE, STATE_NAME)  VALUES
('AL','Alabama'),
('AK','Alaska'),
('AZ','Arizona'),
('AR','Arkansas'),
('CA','California'),
('CO','Colorado'),
('CT','Connecticut'),
('DE','Delaware'),
('DC','District of Columbia'),
('FL','Florida'),
('GA','Georgia'),
('HI','Hawaii'),
('ID','Idaho'),
('IL','Illinois'),
('IN','Indiana'),
('IA','Iowa'),
('KS','Kansas'),
('KY','Kentucky'),
('LA','Louisiana'),
('ME','Maine'),
('MD','Maryland'),
('MA','Massachusetts'),
('MI','Michigan'),
('MN','Minnesota'),
('MS','Mississippi'),
('MO','Missouri'),
('MT','Montana'),
('NE','Nebraska'),
('NV','Nevada'),
('NH','New Hampshire'),
('NJ','New Jersey'),
('NM','New Mexico'),
('NY','New York'),
('NC','North Carolina'),
('ND','North Dakota'),
('OH','Ohio'),
('OK','Oklahoma'),
('OR','Oregon'),
('PA','Pennsylvania'),
('PR','Puerto Rico'),
('RI','Rhode Island'),
('SC','South Carolina'),
('SD','South Dakota'),
('TN','Tennessee'),
('TX','Texas'),
('UT','Utah'),
('VT','Vermont'),
('VA','Virginia'),
('WA','Washington'),
('WV','West Virginia'),
('WI','Wisconsin'),
('WY','Wyoming');
select * from states_master;
select * from authorities_master;
desc table authorities_master
alter table appusers_auth drop constraint appusers_auth_role_id_fkey;
drop table authorities_master ;
alter table authorities_master  alter column roledesc type varchar(400);
CREATE TABLE authorities_master (
 id serial PRIMARY KEY ,
 rolename VARCHAR(25),
 roleDesc VARCHAR(400)
);


drop table appusers_auth ;
CREATE TABLE appusers_auth (
 auth_user_id bigserial not null ,
 userid bigserial ,
 username text,
 email text,
 role_id INTEGER,
 updated_time timestamp default CURRENT_TIMESTAMP,
 primary key (auth_user_id),
 FOREIGN KEY (role_id)
 REFERENCES authorities_master (id)
);

ALTER TABLE appusers_auth ADD CONSTRAINT FK_AUTHROTIES_APPUSER foreign key (userid,username,email) references APPUSERS(userid,username,email);

insert into authorities_master (rolename,roleDesc) values ('ROLE_BASIC_USER','Default role for any user, This supports limited file size transcription, fo ex: 20 mb and one file at a time, no batch transcribtion');
insert into authorities_master (rolename,roledesc)  values ('ROLE_ADMIN','Default admin role for limited admin privileges, like new features released testing, unlimited tranribitions for sphin4x and deepspeech and unlimited file size and unlimited files');
insert into authorities_master (rolename,roleDesc)  values ('ROLE_SUPER_ADMIN','Super admin role with complete auth, this will be mostly backend and complete access to all features, endpoints');
insert into authorities_master (rolename,roleDesc)  values ('ROLE_PREMIUM_USER','Super role with complete transcription endpoints access like spinx4 transribtion with unlimited size, for ex at max 100MB(system limit), unlimited transcribtions at anytime, access to deepspeech transcribtions endpoints ');



drop table registeredappusers;

CREATE TABLE REGISTEREDAPPUSERS_ACTIVITY_LOG(
  id bigserial PRIMARY KEY,
  user_id int not null,
  username text not null,
  email text not null,
  token text,
   last_loggedin timestamp default CURRENT_TIMESTAMP
);

ALTER TABLE REGISTEREDAPPUSERS_ACTIVITY_LOG ADD CONSTRAINT FK_REGUSERS_USERNAME_EMAIL foreign key (user_id,username,email) references APPUSERS(userid,username,email);

drop TABLE if exists APPUSERS_TRANSCRIPTIONS  cascade;

CREATE TABLE APPUSERS_TRANSCRIPTIONS (
  log_id bigserial PRIMARY KEY,
  username text not null,
  user_id int not null,
  email text not null,
  transcription_req_id text not null,
  transcribe_res_type text default 'application/json',
  file_name text not null,
  session_id varchar(100) not null,
  transcribed boolean default false,
  downloaded boolean default false,
  transcribe_res_available_format text default 'application/json',
  transcribe_res_downloaded_format text default 'application/json',
  transcribed_date timestamp default CURRENT_TIMESTAMP,
  uploaded_date timestamp default CURRENT_TIMESTAMP
);

drop table if exists TABLE TRANSCRIBEFILELOG ;
CREATE TABLE TRANSCRIBEFILELOG (
  id bigserial PRIMARY KEY,
  email text,
  file_name text,
  log_id integer,
  transcribe_res text,
  file_size integer,
  created_at timestamp DEFAULT now() NOT NULL,
  FOREIGN KEY (log_id) REFERENCES APPUSERS_TRANSCRIPTIONS (log_id)
);

ALTER TABLE APPUSERS_TRANSCRIPTIONS ADD CONSTRAINT FK_Users_Transcriptions_users FOREIGN KEY
  ( user_id, username,   email  ) REFERENCES APPUSERS(  userid, username, email  );



insert into APPUSERS (username, password, active, first_name, last_name, email, zipcode) values ('rajeshhazari', 'admin321', true,'Rajesh', 'Hazari', 'rajeshhazari@gmail.com','27560');
insert into APPUSERS (username, password, active, first_name, last_name, email, zipcode) values ('rajeshh', '$2a$10$SUM9YNdIuC1RQLR4lyosdeolpq3iU/T72noOJQx4XFyclWHLxAh/C', true,'raj1','hazari1','rajesh_hazari@yahoo.com','27560');
insert into APPUSERS (username, password, active, first_name, last_name, email, zipcode) values ('devuser', '$2a$10$JuqFvWlOf/AIbBvrhvkvfuNuCnnwudxDxTzeuqc3Gr3n6sTLniHsy', true,'devappuser','devapp','transcriibedevappuser@yahoo.com','27560');
$2a$10$Hh/MlD1OcRo4xsXB4HfQBOjRr1/tLfNri4bFC2rd290z5gGTVOr7a
update APPUSERS set password ='$2a$10$JuqFvWlOf/AIbBvrhvkvfuNuCnnwudxDxTzeuqc3Gr3n6sTLniHsy' where email='rajesh_hazari@yahoo.com';
select * from APPUSERS_UPDATE_LOG;
select * from appusers where email='rajesh_hazari@yahoo.com'

insert into appusers_auth (userid,username,email,role_id) values (1,'rajeshhazari','rajeshhazari@gmail.com',1);
insert into appusers_auth (userid,username,email,role_id) values (2,'rajeshh','rajesh_hazari@yahoo.com',3);




drop table APPUSERS_UPDATE_LOG cascade;

CREATE TABLE APPUSERS_UPDATE_LOG(
    id bigserial PRIMARY KEY,
    operation   char(1)   NOT NULL,
    userid int not null,
    username text not null,
    email text not null,
    password text,
    first_name text,
    last_name text,
    phone_number text,
    active boolean,
    disabled boolean,
    verified boolean,
    locked boolean,
    superuser boolean,
    last_updated timestamp default CURRENT_TIMESTAMP
);

--/
CREATE OR REPLACE FUNCTION process_users_profile_audit() RETURNS TRIGGER 
AS $appusers_update_activity$
    BEGIN   
            IF (TG_OP = 'DELETE') THEN
            INSERT INTO APPUSERS_UPDATE_LOG (operation,userid,username,email,password,first_name,last_name,phone_number,active,disabled,verified,locked,superuser)
                SELECT 'D',  n.userid,n.username,n.email,n.password,n.first_name,n.last_name,n.phone_number,n.active,n.disabled,n.verified,n.locked,n.superuser FROM old_table o;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO APPUSERS_UPDATE_LOG (operation,userid,username,email,password,first_name,last_name,phone_number,active,disabled,verified,locked,superuser)
                SELECT 'U',  n.userid,n.username,n.email,n.password,n.first_name,n.last_name,n.phone_number,n.active,n.disabled,n.verified,n.locked,n.superuser FROM old_table n;
        ELSIF (TG_OP = 'INSERT') THEN
            INSERT INTO APPUSERS_UPDATE_LOG (operation,userid,username,email,password,first_name,last_name,phone_number,active,disabled,verified,locked,superuser)
                SELECT 'I',  n.userid,n.username,n.email,n.password,n.first_name,n.last_name,n.phone_number,n.active,n.disabled,n.verified,n.locked,n.superuser  FROM new_table n;
        END IF;
        RETURN NULL;
    END $appusers_update_activity$ LANGUAGE plpgsql;
/
    
CREATE TRIGGER APPUSERS_PROFILE_INS_LOG
    AFTER INSERT ON APPUSERS
    REFERENCING NEW TABLE AS new_table
    FOR EACH STATEMENT EXECUTE FUNCTION process_users_profile_audit();
CREATE TRIGGER APPUSERS_PROFILE_UPDATE_LOG
    AFTER UPDATE ON APPUSERS
    REFERENCING OLD TABLE AS old_table NEW TABLE AS new_table
    FOR EACH STATEMENT EXECUTE FUNCTION process_users_profile_audit();
CREATE TRIGGER APPUSERS_PROFILE_DEL_LOG
    AFTER DELETE ON APPUSERS
    REFERENCING OLD TABLE AS old_table
    FOR EACH STATEMENT EXECUTE FUNCTION process_users_profile_audit();
    
    
insert into APPUSERS_TRANSCRIPTIONS (user_id,username,email,transcription_req_id,file_name,session_id) values (1,'rajeshhazari','rajeshhazari@gmail.com','3214','sample.wav',  'jsession321' );
insert into APPUSERS_TRANSCRIPTIONS (user_id,username,email,transcription_req_id,file_name,session_id) values (2,'rajeshh','rajesh_hazari@yahoo.com','3214','sample_super_user.wav',  'jsession321' );

select * from APPUSERS_TRANSCRIPTIONS;

drop TABLE if exists TRANSCRIBEFILELOG ;
  CREATE TABLE TRANSCRIBEFILELOG (
  id bigserial PRIMARY KEY,
  email text,
  file_name text,
  log_id integer,
  transcribe_res text,
  file_size integer,
  created_at timestamp DEFAULT now() NOT NULL,
  FOREIGN KEY (id) REFERENCES APPUSERS_TRANSCRIPTIONS (log_id)
);

select * from TRANSCRIBEFILELOG;
select * from APPUSERS_TRANSCRIPTIONS;


insert into TRANSCRIBEFILELOG   (LOG_ID,email,FILE_NAME,TRANSCRIBE_RES,file_size) values (1,'rajeshhazari@gmail.com', 'sample.wav', 'one two threee and so on.. sample response',30);
insert into TRANSCRIBEFILELOG   (LOG_ID,email,FILE_NAME,TRANSCRIBE_RES,file_size) values (3,'rajesh_hazari', 'sample.wav',  'one two threee and so on.. sample response', 31);




insert into appusers_auth (userid,usename,email,role_id)  values (1,rajeshhazari,rajeshhazari@gmail.com,1)


commit;
