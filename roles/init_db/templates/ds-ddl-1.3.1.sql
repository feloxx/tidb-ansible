create schema ds collate utf8_general_ci;

use ds;

create table QRTZ_CALENDARS
(
	SCHED_NAME varchar(120) not null,
	CALENDAR_NAME varchar(200) not null,
	CALENDAR blob not null,
	primary key (SCHED_NAME, CALENDAR_NAME)
);

create table QRTZ_FIRED_TRIGGERS
(
	SCHED_NAME varchar(120) not null,
	ENTRY_ID varchar(95) not null,
	TRIGGER_NAME varchar(200) not null,
	TRIGGER_GROUP varchar(200) not null,
	INSTANCE_NAME varchar(200) not null,
	FIRED_TIME bigint(13) not null,
	SCHED_TIME bigint(13) not null,
	PRIORITY int not null,
	STATE varchar(16) not null,
	JOB_NAME varchar(200) null,
	JOB_GROUP varchar(200) null,
	IS_NONCONCURRENT varchar(1) null,
	REQUESTS_RECOVERY varchar(1) null,
	primary key (SCHED_NAME, ENTRY_ID)
);

create index IDX_QRTZ_FT_INST_JOB_REQ_RCVRY
	on QRTZ_FIRED_TRIGGERS (SCHED_NAME, INSTANCE_NAME, REQUESTS_RECOVERY);

create index IDX_QRTZ_FT_JG
	on QRTZ_FIRED_TRIGGERS (SCHED_NAME, JOB_GROUP);

create index IDX_QRTZ_FT_J_G
	on QRTZ_FIRED_TRIGGERS (SCHED_NAME, JOB_NAME, JOB_GROUP);

create index IDX_QRTZ_FT_TG
	on QRTZ_FIRED_TRIGGERS (SCHED_NAME, TRIGGER_GROUP);

create index IDX_QRTZ_FT_TRIG_INST_NAME
	on QRTZ_FIRED_TRIGGERS (SCHED_NAME, INSTANCE_NAME);

create index IDX_QRTZ_FT_T_G
	on QRTZ_FIRED_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);

create table QRTZ_JOB_DETAILS
(
	SCHED_NAME varchar(120) not null,
	JOB_NAME varchar(200) not null,
	JOB_GROUP varchar(200) not null,
	DESCRIPTION varchar(250) null,
	JOB_CLASS_NAME varchar(250) not null,
	IS_DURABLE varchar(1) not null,
	IS_NONCONCURRENT varchar(1) not null,
	IS_UPDATE_DATA varchar(1) not null,
	REQUESTS_RECOVERY varchar(1) not null,
	JOB_DATA blob null,
	primary key (SCHED_NAME, JOB_NAME, JOB_GROUP)
);

create index IDX_QRTZ_J_GRP
	on QRTZ_JOB_DETAILS (SCHED_NAME, JOB_GROUP);

create index IDX_QRTZ_J_REQ_RECOVERY
	on QRTZ_JOB_DETAILS (SCHED_NAME, REQUESTS_RECOVERY);

create table QRTZ_LOCKS
(
	SCHED_NAME varchar(120) not null,
	LOCK_NAME varchar(40) not null,
	primary key (SCHED_NAME, LOCK_NAME)
);

create table QRTZ_PAUSED_TRIGGER_GRPS
(
	SCHED_NAME varchar(120) not null,
	TRIGGER_GROUP varchar(200) not null,
	primary key (SCHED_NAME, TRIGGER_GROUP)
);

create table QRTZ_SCHEDULER_STATE
(
	SCHED_NAME varchar(120) not null,
	INSTANCE_NAME varchar(200) not null,
	LAST_CHECKIN_TIME bigint(13) not null,
	CHECKIN_INTERVAL bigint(13) not null,
	primary key (SCHED_NAME, INSTANCE_NAME)
);

create table QRTZ_TRIGGERS
(
	SCHED_NAME varchar(120) not null,
	TRIGGER_NAME varchar(200) not null,
	TRIGGER_GROUP varchar(200) not null,
	JOB_NAME varchar(200) not null,
	JOB_GROUP varchar(200) not null,
	DESCRIPTION varchar(250) null,
	NEXT_FIRE_TIME bigint(13) null,
	PREV_FIRE_TIME bigint(13) null,
	PRIORITY int null,
	TRIGGER_STATE varchar(16) not null,
	TRIGGER_TYPE varchar(8) not null,
	START_TIME bigint(13) not null,
	END_TIME bigint(13) null,
	CALENDAR_NAME varchar(200) null,
	MISFIRE_INSTR smallint(2) null,
	JOB_DATA blob null,
	primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
	constraint QRTZ_TRIGGERS_ibfk_1
		foreign key (SCHED_NAME, JOB_NAME, JOB_GROUP) references QRTZ_JOB_DETAILS (SCHED_NAME, JOB_NAME, JOB_GROUP)
);

create table QRTZ_BLOB_TRIGGERS
(
	SCHED_NAME varchar(120) not null,
	TRIGGER_NAME varchar(200) not null,
	TRIGGER_GROUP varchar(200) not null,
	BLOB_DATA blob null,
	primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
	constraint QRTZ_BLOB_TRIGGERS_ibfk_1
		foreign key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) references QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
);

create index SCHED_NAME
	on QRTZ_BLOB_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);

create table QRTZ_CRON_TRIGGERS
(
	SCHED_NAME varchar(120) not null,
	TRIGGER_NAME varchar(200) not null,
	TRIGGER_GROUP varchar(200) not null,
	CRON_EXPRESSION varchar(120) not null,
	TIME_ZONE_ID varchar(80) null,
	primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
	constraint QRTZ_CRON_TRIGGERS_ibfk_1
		foreign key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) references QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
);

create table QRTZ_SIMPLE_TRIGGERS
(
	SCHED_NAME varchar(120) not null,
	TRIGGER_NAME varchar(200) not null,
	TRIGGER_GROUP varchar(200) not null,
	REPEAT_COUNT bigint(7) not null,
	REPEAT_INTERVAL bigint(12) not null,
	TIMES_TRIGGERED bigint(10) not null,
	primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
	constraint QRTZ_SIMPLE_TRIGGERS_ibfk_1
		foreign key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) references QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
);

create table QRTZ_SIMPROP_TRIGGERS
(
	SCHED_NAME varchar(120) not null,
	TRIGGER_NAME varchar(200) not null,
	TRIGGER_GROUP varchar(200) not null,
	STR_PROP_1 varchar(512) null,
	STR_PROP_2 varchar(512) null,
	STR_PROP_3 varchar(512) null,
	INT_PROP_1 int null,
	INT_PROP_2 int null,
	LONG_PROP_1 bigint null,
	LONG_PROP_2 bigint null,
	DEC_PROP_1 decimal(13,4) null,
	DEC_PROP_2 decimal(13,4) null,
	BOOL_PROP_1 varchar(1) null,
	BOOL_PROP_2 varchar(1) null,
	primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP),
	constraint QRTZ_SIMPROP_TRIGGERS_ibfk_1
		foreign key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) references QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP)
);

create index IDX_QRTZ_T_C
	on QRTZ_TRIGGERS (SCHED_NAME, CALENDAR_NAME);

create index IDX_QRTZ_T_G
	on QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_GROUP);

create index IDX_QRTZ_T_J
	on QRTZ_TRIGGERS (SCHED_NAME, JOB_NAME, JOB_GROUP);

create index IDX_QRTZ_T_JG
	on QRTZ_TRIGGERS (SCHED_NAME, JOB_GROUP);

create index IDX_QRTZ_T_NEXT_FIRE_TIME
	on QRTZ_TRIGGERS (SCHED_NAME, NEXT_FIRE_TIME);

create index IDX_QRTZ_T_NFT_MISFIRE
	on QRTZ_TRIGGERS (SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME);

create index IDX_QRTZ_T_NFT_ST
	on QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_STATE, NEXT_FIRE_TIME);

create index IDX_QRTZ_T_NFT_ST_MISFIRE
	on QRTZ_TRIGGERS (SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME, TRIGGER_STATE);

create index IDX_QRTZ_T_NFT_ST_MISFIRE_GRP
	on QRTZ_TRIGGERS (SCHED_NAME, MISFIRE_INSTR, NEXT_FIRE_TIME, TRIGGER_GROUP, TRIGGER_STATE);

create index IDX_QRTZ_T_N_G_STATE
	on QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_GROUP, TRIGGER_STATE);

create index IDX_QRTZ_T_N_STATE
	on QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP, TRIGGER_STATE);

create index IDX_QRTZ_T_STATE
	on QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_STATE);

create table t_ds_access_token
(
	id int auto_increment comment 'key'
		primary key,
	user_id int null comment 'user id',
	token varchar(64) null comment 'token',
	expire_time datetime null comment 'end time of token ',
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time'
);

create table t_ds_alert
(
	id int auto_increment comment 'key'
		primary key,
	title varchar(64) null comment 'title',
	show_type tinyint null comment 'send email type,0:TABLE,1:TEXT',
	content text null comment 'Message content (can be email, can be SMS. Mail is stored in JSON map, and SMS is string)',
	alert_type tinyint null comment '0:email,1:sms',
	alert_status tinyint default 0 null comment '0:wait running,1:success,2:failed',
	log text null comment 'log',
	alertgroup_id int null comment 'alert group id',
	receivers text null comment 'receivers',
	receivers_cc text null comment 'cc',
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time'
);

create table t_ds_alertgroup
(
	id int auto_increment comment 'key'
		primary key,
	group_name varchar(255) null comment 'group name',
	group_type tinyint null comment 'Group type (message 0, SMS 1...)',
	description varchar(255) null,
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time'
);

create table t_ds_command
(
	id int auto_increment comment 'key'
		primary key,
	command_type tinyint null comment 'Command type: 0 start workflow, 1 start execution from current node, 2 resume fault-tolerant workflow, 3 resume pause process, 4 start execution from failed node, 5 complement, 6 schedule, 7 rerun, 8 pause, 9 stop, 10 resume waiting thread',
	process_definition_id int null comment 'process definition id',
	command_param text null comment 'json command parameters',
	task_depend_type tinyint null comment 'Node dependency type: 0 current node, 1 forward, 2 backward',
	failure_strategy tinyint default 0 null comment 'Failed policy: 0 end, 1 continue',
	warning_type tinyint default 0 null comment 'Alarm type: 0 is not sent, 1 process is sent successfully, 2 process is sent failed, 3 process is sent successfully and all failures are sent',
	warning_group_id int null comment 'warning group',
	schedule_time datetime null comment 'schedule time',
	start_time datetime null comment 'start time',
	executor_id int null comment 'executor id',
	dependence varchar(255) null comment 'dependence',
	update_time datetime null comment 'update time',
	process_instance_priority int null comment 'process instance priority: 0 Highest,1 High,2 Medium,3 Low,4 Lowest',
	worker_group varchar(64) default '' null comment 'worker group'
);

create table t_ds_datasource
(
	id int auto_increment comment 'key'
		primary key,
	name varchar(64) not null comment 'data source name',
	note varchar(256) null comment 'description',
	type tinyint not null comment 'data source type: 0:mysql,1:postgresql,2:hive,3:spark',
	user_id int not null comment 'the creator id',
	connection_params text not null comment 'json connection params',
	create_time datetime not null comment 'create time',
	update_time datetime null comment 'update time'
);

create table t_ds_error_command
(
	id int not null comment 'key'
		primary key,
	command_type tinyint null comment 'command type',
	executor_id int null comment 'executor id',
	process_definition_id int null comment 'process definition id',
	command_param text null comment 'json command parameters',
	task_depend_type tinyint null comment 'task depend type',
	failure_strategy tinyint default 0 null comment 'failure strategy',
	warning_type tinyint default 0 null comment 'warning type',
	warning_group_id int null comment 'warning group id',
	schedule_time datetime null comment 'scheduler time',
	start_time datetime null comment 'start time',
	update_time datetime null comment 'update time',
	dependence text null comment 'dependence',
	process_instance_priority int null comment 'process instance priority, 0 Highest,1 High,2 Medium,3 Low,4 Lowest',
	worker_group varchar(64) default '' null comment 'worker group',
	message text null comment 'message'
);

create table t_ds_master_server
(
	id int auto_increment comment 'key'
		primary key,
	host varchar(45) null comment 'ip',
	port int null comment 'port',
	zk_directory varchar(64) null comment 'the server path in zk directory',
	res_info varchar(256) null comment 'json resource information:{"cpu":xxx,"memroy":xxx}',
	create_time datetime null comment 'create time',
	last_heartbeat_time datetime null comment 'last head beat time'
);

create table t_ds_process_definition
(
	id int auto_increment comment 'key'
		primary key,
	name varchar(255) null comment 'process definition name',
	version int null comment 'process definition version',
	release_state tinyint null comment 'process definition release state：0:offline,1:online',
	project_id int null comment 'project id',
	user_id int null comment 'process definition creator id',
	process_definition_json longtext null comment 'process definition json content',
	description text null,
	global_params text null comment 'global parameters',
	flag tinyint null comment '0 not available, 1 available',
	locations text null comment 'Node location information',
	connects text null comment 'Node connection information',
	receivers text null comment 'receivers',
	receivers_cc text null comment 'cc',
	create_time datetime null comment 'create time',
	timeout int default 0 null comment 'time out',
	tenant_id int default -1 not null comment 'tenant id',
	update_time datetime null comment 'update time',
	modify_by varchar(36) default '' null comment 'modify user',
	resource_ids varchar(255) null comment 'resource ids',
	constraint process_definition_unique
		unique (name, project_id)
);

create index process_definition_index
	on t_ds_process_definition (project_id, id);

create table t_ds_process_instance
(
	id int auto_increment comment 'key'
		primary key,
	name varchar(255) null comment 'process instance name',
	process_definition_id int null comment 'process definition id',
	state tinyint null comment 'process instance Status: 0 commit succeeded, 1 running, 2 prepare to pause, 3 pause, 4 prepare to stop, 5 stop, 6 fail, 7 succeed, 8 need fault tolerance, 9 kill, 10 wait for thread, 11 wait for dependency to complete',
	recovery tinyint null comment 'process instance failover flag：0:normal,1:failover instance',
	start_time datetime null comment 'process instance start time',
	end_time datetime null comment 'process instance end time',
	run_times int null comment 'process instance run times',
	host varchar(45) null comment 'process instance host',
	command_type tinyint null comment 'command type',
	command_param text null comment 'json command parameters',
	task_depend_type tinyint null comment 'task depend type. 0: only current node,1:before the node,2:later nodes',
	max_try_times tinyint default 0 null comment 'max try times',
	failure_strategy tinyint default 0 null comment 'failure strategy. 0:end the process when node failed,1:continue running the other nodes when node failed',
	warning_type tinyint default 0 null comment 'warning type. 0:no warning,1:warning if process success,2:warning if process failed,3:warning if success',
	warning_group_id int null comment 'warning group id',
	schedule_time datetime null comment 'schedule time',
	command_start_time datetime null comment 'command start time',
	global_params text null comment 'global parameters',
	process_instance_json longtext null comment 'process instance json(copy的process definition 的json)',
	flag tinyint default 1 null comment 'flag',
	update_time timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
	is_sub_process int default 0 null comment 'flag, whether the process is sub process',
	executor_id int not null comment 'executor id',
	locations text null comment 'Node location information',
	connects text null comment 'Node connection information',
	history_cmd text null comment 'history commands of process instance operation',
	dependence_schedule_times text null comment 'depend schedule fire time',
	process_instance_priority int null comment 'process instance priority. 0 Highest,1 High,2 Medium,3 Low,4 Lowest',
	worker_group varchar(64) default '' null comment 'worker group',
	timeout int default 0 null comment 'time out',
	tenant_id int default -1 not null comment 'tenant id'
);

create index process_instance_index
	on t_ds_process_instance (process_definition_id, id);

create index start_time_index
	on t_ds_process_instance (start_time);

create table t_ds_project
(
	id int auto_increment comment 'key'
		primary key,
	name varchar(100) null comment 'project name',
	description varchar(200) null,
	user_id int null comment 'creator id',
	flag tinyint default 1 null comment '0 not available, 1 available',
	create_time datetime default CURRENT_TIMESTAMP null comment 'create time',
	update_time datetime default CURRENT_TIMESTAMP null comment 'update time'
);

create index user_id_index
	on t_ds_project (user_id);

create table t_ds_queue
(
	id int auto_increment comment 'key'
		primary key,
	queue_name varchar(64) null comment 'queue name',
	queue varchar(64) null comment 'yarn queue name',
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time'
);

create table t_ds_relation_datasource_user
(
	id int auto_increment comment 'key'
		primary key,
	user_id int not null comment 'user id',
	datasource_id int null comment 'data source id',
	perm int default 1 null comment 'limits of authority',
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time'
);

create table t_ds_relation_process_instance
(
	id int auto_increment comment 'key'
		primary key,
	parent_process_instance_id int null comment 'parent process instance id',
	parent_task_instance_id int null comment 'parent process instance id',
	process_instance_id int null comment 'child process instance id'
);

create table t_ds_relation_project_user
(
	id int auto_increment comment 'key'
		primary key,
	user_id int not null comment 'user id',
	project_id int null comment 'project id',
	perm int default 1 null comment 'limits of authority',
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time'
);

create index user_id_index
	on t_ds_relation_project_user (user_id);

create table t_ds_relation_resources_user
(
	id int auto_increment
		primary key,
	user_id int not null comment 'user id',
	resources_id int null comment 'resource id',
	perm int default 1 null comment 'limits of authority',
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time'
);

create table t_ds_relation_udfs_user
(
	id int auto_increment comment 'key'
		primary key,
	user_id int not null comment 'userid',
	udf_id int null comment 'udf id',
	perm int default 1 null comment 'limits of authority',
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time'
);

create table t_ds_relation_user_alertgroup
(
	id int auto_increment comment 'key'
		primary key,
	alertgroup_id int null comment 'alert group id',
	user_id int null comment 'user id',
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time'
);

create table t_ds_resources
(
	id int auto_increment comment 'key'
		primary key,
	alias varchar(64) null comment 'alias',
	file_name varchar(64) null comment 'file name',
	description varchar(256) null,
	user_id int null comment 'user id',
	type tinyint null comment 'resource type,0:FILE，1:UDF',
	size bigint null comment 'resource size',
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time',
	pid int default -1 null comment 'parent id',
	full_name varchar(255) null comment 'full name',
	is_directory tinyint(1) default 0 null comment 'is directory'
);

create table t_ds_schedules
(
	id int auto_increment comment 'key'
		primary key,
	process_definition_id int not null comment 'process definition id',
	start_time datetime not null comment 'start time',
	end_time datetime not null comment 'end time',
	crontab varchar(256) not null comment 'crontab description',
	failure_strategy tinyint not null comment 'failure strategy. 0:end,1:continue',
	user_id int not null comment 'user id',
	release_state tinyint not null comment 'release state. 0:offline,1:online ',
	warning_type tinyint not null comment 'Alarm type: 0 is not sent, 1 process is sent successfully, 2 process is sent failed, 3 process is sent successfully and all failures are sent',
	warning_group_id int null comment 'alert group id',
	process_instance_priority int null comment 'process instance priority：0 Highest,1 High,2 Medium,3 Low,4 Lowest',
	worker_group varchar(64) default '' null comment 'worker group',
	create_time datetime not null comment 'create time',
	update_time datetime not null comment 'update time'
);

create table t_ds_session
(
	id varchar(64) not null comment 'key'
		primary key,
	user_id int null comment 'user id',
	ip varchar(45) null comment 'ip',
	last_login_time datetime null comment 'last login time'
);

create table t_ds_task_instance
(
	id int auto_increment comment 'key'
		primary key,
	name varchar(255) null comment 'task name',
	task_type varchar(64) null comment 'task type',
	process_definition_id int null comment 'process definition id',
	process_instance_id int null comment 'process instance id',
	task_json longtext null comment 'task content json',
	state tinyint null comment 'Status: 0 commit succeeded, 1 running, 2 prepare to pause, 3 pause, 4 prepare to stop, 5 stop, 6 fail, 7 succeed, 8 need fault tolerance, 9 kill, 10 wait for thread, 11 wait for dependency to complete',
	submit_time datetime null comment 'task submit time',
	start_time datetime null comment 'task start time',
	end_time datetime null comment 'task end time',
	host varchar(45) null comment 'host of task running on',
	execute_path varchar(200) null comment 'task execute path in the host',
	log_path varchar(200) null comment 'task log path',
	alert_flag tinyint null comment 'whether alert',
	retry_times int(4) default 0 null comment 'task retry times',
	pid int(4) null comment 'pid of task',
	app_link text null comment 'yarn app id',
	flag tinyint default 1 null comment '0 not available, 1 available',
	retry_interval int(4) null comment 'retry interval when task failed ',
	max_retry_times int(2) null comment 'max retry times',
	task_instance_priority int null comment 'task instance priority:0 Highest,1 High,2 Medium,3 Low,4 Lowest',
	worker_group varchar(64) default '' null comment 'worker group',
	executor_id int null comment 'executor id',
	constraint foreign_key_instance_id
		foreign key (process_instance_id) references t_ds_process_instance (id)
			on delete cascade
);

create index process_instance_id
	on t_ds_task_instance (process_instance_id);

create index task_instance_index
	on t_ds_task_instance (process_definition_id, process_instance_id);

create table t_ds_tenant
(
	id int auto_increment comment 'key'
		primary key,
	tenant_code varchar(64) null comment 'tenant code',
	tenant_name varchar(64) null comment 'tenant name',
	description varchar(256) null,
	queue_id int null comment 'queue id',
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time'
);

create table t_ds_udfs
(
	id int auto_increment comment 'key'
		primary key,
	user_id int not null comment 'user id',
	func_name varchar(100) not null comment 'UDF function name',
	class_name varchar(255) not null comment 'class of udf',
	type tinyint not null comment 'Udf function type',
	arg_types varchar(255) null comment 'arguments types',
	`database` varchar(255) null comment 'data base',
	description varchar(255) null,
	resource_id int not null comment 'resource id',
	resource_name varchar(255) not null comment 'resource name',
	create_time datetime not null comment 'create time',
	update_time datetime not null comment 'update time'
);

create table t_ds_user
(
	id int auto_increment comment 'user id'
		primary key,
	user_name varchar(64) null comment 'user name',
	user_password varchar(64) null comment 'user password',
	user_type tinyint null comment 'user type, 0:administrator，1:ordinary user',
	email varchar(64) null comment 'email',
	phone varchar(11) null comment 'phone',
	tenant_id int null comment 'tenant id',
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time',
	queue varchar(64) null comment 'queue',
	constraint user_name_unique
		unique (user_name)
);

create table t_ds_version
(
	id int auto_increment
		primary key,
	version varchar(200) not null,
	constraint version_UNIQUE
		unique (version)
)
comment 'version';

create table t_ds_worker_group
(
	id bigint(11) auto_increment comment 'id'
		primary key,
	name varchar(256) null comment 'worker group name',
	ip_list varchar(256) null comment 'worker ip list. split by [,] ',
	create_time datetime null comment 'create time',
	update_time datetime null comment 'update time'
);

create table t_ds_worker_server
(
	id int auto_increment comment 'key'
		primary key,
	host varchar(45) null comment 'ip',
	port int null comment 'process id',
	zk_directory varchar(64) collate utf8_bin null comment 'zk path',
	res_info varchar(255) null comment 'json resource info,{"cpu":xxx,"memroy":xxx}',
	create_time datetime null comment 'create time',
	last_heartbeat_time datetime null comment 'update time'
);

