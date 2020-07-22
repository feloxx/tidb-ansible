INSERT INTO dolphinscheduler.t_ds_alertgroup (id, group_name, group_type, description, create_time, update_time) VALUES (1, 'default admin warning group', 0, 'default admin warning group', '2018-11-29 10:20:39', '2018-11-29 10:20:39');

INSERT INTO dolphinscheduler.t_ds_queue (id, queue_name, queue, create_time, update_time) VALUES (1, 'default', 'default', null, null);

INSERT INTO dolphinscheduler.t_ds_relation_user_alertgroup (id, alertgroup_id, user_id, create_time, update_time) VALUES (1, 1, 1, '2018-11-29 10:22:33', '2018-11-29 10:22:33');

INSERT INTO dolphinscheduler.t_ds_user (id, user_name, user_password, user_type, email, phone, tenant_id, create_time, update_time, queue) VALUES (1, 'admin', '7ad2410b2f4c074479a8937a28a22b8f', 0, 'xxx@qq.com', 'xx', 0, '2018-03-27 15:48:50', '2018-10-24 17:40:22', null);

INSERT INTO dolphinscheduler.t_ds_version (id, version) VALUES (1, '1.3.1');