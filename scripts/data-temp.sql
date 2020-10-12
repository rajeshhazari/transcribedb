


insert into AUTHORITIES_MASTER (role_id,roleDesc,max_file_size,max_number_files) values ('ROLE_BASIC_USER','Default role for any user, This supports limited file size transcription, for ex: 20MB and 
one file at a time, no batch transcribtion',20,0);
insert into AUTHORITIES_MASTER (role_id,roleDesc,max_file_size,max_number_files) values ('ROLE_ANONYMUS','Anonymus role for any user, This supports limited file size transcription, for ex: 20MB and 
one file at a time, no batch 
transcribtion. This Role can be used for users to explore or in beta testing.',20,100);
insert into AUTHORITIES_MASTER (role_id,roledesc,max_file_size,max_number_files)  values ('ROLE_ADMIN','Default admin role for limited admin privileges, like new features released testing, unlimited 
transcribtions for sphin4x and deepspeech and unlimited file size and unlimited files',0,0);
insert into AUTHORITIES_MASTER (role_id,roledesc,max_file_size,max_number_files)  values ('ROLE_DEVOPS','Default devops role with  unlimited admin privileges, like new features released testing, 
unlimited  transcribtions for sphin4x and deepspeech and unlimited file size and unlimited files',0,0);
insert into AUTHORITIES_MASTER (role_id,roleDesc,max_file_size,max_number_files)  values ('ROLE_SUPER_ADMIN','Super admin role with complete auth, this will be mostly backend and complete access to 
all features, endpoints',0,0);
insert into AUTHORITIES_MASTER (role_id,roleDesc,max_file_size,max_number_files)  values ('ROLE_PREMIUM_USER','Super role with complete transcription endpoints access like spinx4 transribtion with 
unlimited size, for ex at max 100MB(system limit), unlimited transcribtions at anytime, access to deepspeech transcribtions endpoints ',0,0);

insert into APPUSERS (username, password, active, first_name, last_name, email, zipcode) values ('rajeshhazari', 'admin321', true,'Rajesh', 'Hazari', 'rajeshhazari@gmail.com','27560');
insert into APPUSERS (username, password, active, first_name, last_name, email, zipcode) values ('rajeshh', '$2a$10$JuqFvWlOf/AIbBvrhvkvfuNuCnnwudxDxTzeuqc3Gr3n6sTLniHsy', 
true,'rajesh','hazare','rajesh_hazari@yahoo.com','27560');
insert into APPUSERS (username, password, active, first_name, last_name, email, zipcode) values ('devuser', '$2a$10$JuqFvWlOf/AIbBvrhvkvfuNuCnnwudxDxTzeuqc3Gr3n6sTLniHsy', 
true,'devappuser','devapp','transcribedevappuser@yahoo.com','27560');




insert into APPUSERS_AUTH (userid,username,email,role_id) values (1,'rajeshhazari','rajeshhazari@gmail.com','ROLE_BASIC_USER');
insert into APPUSERS_AUTH (userid,username,email,role_id) values (2,'rajeshh','rajesh_hazari@yahoo.com','ROLE_SUPER_ADMIN');
insert into APPUSERS_AUTH (userid,username,email,role_id) values (2,'rajeshh','rajesh_hazari@yahoo.com','ROLE_PREMIUM_USER');

insert into APPUSERS_AUTH (userid,username,email,role_id)  values (3,'devuser','transcribedevappuser@yahoo.com','ROLE_DEVOPS');


insert into APPUSERS_TRANSCRIPTIONS (userid,username,email,transcription_req_id,file_name,session_id) values (1,'rajeshhazari','rajeshhazari@gmail.com','3214','sample.wav',  'jsession321' );
insert into APPUSERS_TRANSCRIPTIONS (userid,username,email,transcription_req_id,file_name,session_id) values (2,'rajeshh','rajesh_hazari@yahoo.com','3214','sample_super_user.wav',  'jsession321' );
insert into APPUSERS_TRANSCRIPTIONS (userid,username,email,transcription_req_id,file_name,session_id) values (1,'rajeshhazari','rajeshhazari@gmail.com','32143','sample1.wav',  'jsession321' );
