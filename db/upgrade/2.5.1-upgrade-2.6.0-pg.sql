-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- this file works for PostgreSQL, can not use "`" syntax.

ALTER TABLE selector ADD COLUMN match_restful int2 NOT NULL;
COMMENT ON COLUMN "public"."rule"."match_restful" IS 'whether to match restful(0 cache, 1 not cache)';
COMMIT;

ALTER TABLE rule ADD COLUMN match_restful int2 NOT NULL;
COMMENT ON COLUMN "public"."rule"."match_restful" IS 'whether to match restful(0 cache, 1 not cache)';
COMMIT;


/* insert plugin_handle data for plugin CryptorRequest */
INSERT INTO "public"."plugin_handle" VALUES ('1630760188111376384', '24', 'mapType', 'mapType', 3, 2, 3, '{\"required\":\"0\",\"defaultValue\":\"all\",\"rule\":\"\"}', '2023-03-01 10:41:41', '2023-03-01 10:42:21');
/* insert plugin_handle data for plugin cryptorResponse */
INSERT INTO "public"."plugin_handle" VALUES ('1630768384280514560', '25', 'mapType', 'mapType', 3, 2, 4, '{\"required\":\"0\",\"defaultValue\":\"all\",\"rule\":\"\"}', '2023-03-01 11:14:15', '2023-03-01 11:15:14');

/* insert plugin_handle data for plugin_handle mapType */
INSERT INTO "public"."shenyu_dict" VALUES ('1630761573833920512', 'mapType', 'mapType', 'all', 'all', '', 0, 1, '2023-03-01 10:47:11', '2023-03-01 10:47:11');
INSERT INTO "public"."shenyu_dict" VALUES ('1630761984393367552', 'mapType', 'mapType', 'field', 'field', '', 1, 1, '2023-03-01 10:48:49', '2023-03-01 10:48:49');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621976689762308', 'loadBalance', 'LOAD_BALANCE', 'p2c', 'p2c', 'p2c', 4, 1, '2023-03-07 22:15:16.846', '2023-03-07 22:15:16.846');
INSERT INTO "public"."shenyu_dict" VALUES ('1572621976689762309', 'loadBalance', 'LOAD_BALANCE', 'shortestResponse', 'shortestResponse', 'shortestResponse', 5, 1, '2023-03-17 10:15:16.846', '2023-03-07 10:15:16.846');

/* add column into plugin table */
ALTER TABLE "public"."plugin" ADD COLUMN plugin_jar bytea NULL;
COMMENT ON COLUMN "public"."plugin".plugin_jar IS 'plugin jar';

/* create new tables discovery,discovery_handler,discovery_rel,discovery_upstream,proxy_selector for discovery */
CREATE TABLE "public"."discovery" (
    "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "level" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
    "plugin_name" varchar(255) COLLATE "pg_catalog"."default",
    "type" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
    "server_list" varchar(255) COLLATE "pg_catalog"."default",
    "props" text COLLATE "pg_catalog"."default",
    "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."discovery"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."discovery"."name" IS 'the discovery name';
COMMENT ON COLUMN "public"."discovery"."level" IS '0 selector,1 plugin  2 global';
COMMENT ON COLUMN "public"."discovery"."plugin_name" IS 'the plugin name';
COMMENT ON COLUMN "public"."discovery"."type" IS 'local,zookeeper,etcd,consul,nacos';
COMMENT ON COLUMN "public"."discovery"."server_list" IS 'register server url (,)';
COMMENT ON COLUMN "public"."discovery"."props" IS 'the discovery pops (json) ';
COMMENT ON COLUMN "public"."discovery"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."discovery"."date_updated" IS 'update time';


CREATE TABLE "public"."discovery_handler" (
    "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "discovery_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "handler" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "listener_node" varchar(255) COLLATE "pg_catalog"."default",
    "props" text COLLATE "pg_catalog"."default",
    "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."discovery_handler"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."discovery_handler"."discovery_id" IS 'the discovery id';
COMMENT ON COLUMN "public"."discovery_handler"."handler" IS 'the handler';
COMMENT ON COLUMN "public"."discovery_handler"."listener_node" IS 'register server listener to node';
COMMENT ON COLUMN "public"."discovery_handler"."props" IS 'the discovery pops (json) ';
COMMENT ON COLUMN "public"."discovery_handler"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."discovery_handler"."date_updated" IS 'update time';

CREATE TABLE "public"."discovery_rel" (
    "id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "plugin_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "discovery_handler_id" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "selector_id" varchar(128) COLLATE "pg_catalog"."default",
    "proxy_selector_id" varchar(128) COLLATE "pg_catalog"."default",
    "date_created" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone),
    "date_updated" timestamp(6) NOT NULL DEFAULT timezone('UTC-8'::text, (now())::timestamp(0) without time zone)
)
;
COMMENT ON COLUMN "public"."discovery_rel"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."discovery_rel"."plugin_name" IS 'the plugin name';
COMMENT ON COLUMN "public"."discovery_rel"."discovery_handler_id" IS 'the discovery handler id';
COMMENT ON COLUMN "public"."discovery_rel"."selector_id" IS 'the selector id';
COMMENT ON COLUMN "public"."discovery_rel"."proxy_selector_id" IS 'the proxy selector id';
COMMENT ON COLUMN "public"."discovery_rel"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."discovery_rel"."date_updated" IS 'update time';

CREATE TABLE "public"."proxy_selector"
(
    "id"           varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
    "name"         varchar(128) COLLATE "pg_catalog"."default",
    "plugin_name"  varchar(128) COLLATE "pg_catalog"."default",
    "type"         varchar(128) COLLATE "pg_catalog"."default",
    "forward_port" int4 NOT NULL,
    "props"        text COLLATE "pg_catalog"."default",
    "date_created" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "date_updated" timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "public"."proxy_selector"."id" IS 'primary key id';
COMMENT ON COLUMN "public"."proxy_selector"."name" IS 'the proxy_selector name';
COMMENT ON COLUMN "public"."proxy_selector"."plugin_name" IS 'the plugin name';
COMMENT ON COLUMN "public"."proxy_selector"."type" IS 'the type ';
COMMENT ON COLUMN "public"."proxy_selector"."forward_port" IS 'the forward port';
COMMENT ON COLUMN "public"."proxy_selector"."date_created" IS 'create time';
COMMENT ON COLUMN "public"."proxy_selector"."date_updated" IS 'update time';


INSERT INTO "public"."plugin" VALUES ('42', 'tcp', null, 'Proxy', 320, 1, '2022-05-25 18:08:01', '2022-05-25 18:08:01', null);
INSERT INTO "public"."plugin" VALUES ('43', 'loggingHuaweiLts', '{ "totalSizeInBytes": "104857600","maxBlockMs":"0","ioThreadCount":"1","batchSizeThresholdInBytes":"524288","batchCountThreshold":"4096","lingerMs":"2000","retries":"100","baseRetryBackoffMs":"100","maxRetryBackoffMs":"100","enableLocalTest":"true","setGiveUpExtraLongSingleLog":"false"}', 'Logging', 177, 0, '2023-07-05 14:03:53', '2023-07-06 12:42:07', null);

INSERT INTO "public"."permission" VALUES ('1572525965658820609', '1346358560427216896', '1572525965625266177', '2023-07-07 23:20:04.962', '2023-07-07 23:20:14.170');
INSERT INTO "public"."permission" VALUES ('1572525965658820610', '1346358560427216896', '1572525965625266178', '2023-07-07 23:21:23.648', '2023-07-07 23:21:23.648');
INSERT INTO "public"."permission" VALUES ('1572525965658820611', '1346358560427216896', '1572525965625266179', '2023-07-07 23:23:40.409', '2023-07-07 23:23:40.409');
INSERT INTO "public"."permission" VALUES ('1572525965658820612', '1346358560427216896', '1572525965625266180', '2023-07-07 23:24:03.398', '2023-07-07 23:24:03.398');
INSERT INTO "public"."permission" VALUES ('1572525965658820613', '1346358560427216896', '1572525965625266181', '2023-07-07 23:24:19.165', '2023-07-07 23:24:19.165');
INSERT INTO "public"."permission" VALUES ('1572525965658820614', '1346358560427216896', '1572525965625266182', '2023-07-07 23:24:52.339', '2023-07-07 23:24:52.339');
INSERT INTO "public"."permission" VALUES ('1572525965658820615', '1346358560427216896', '1572525965625266183', '2023-07-07 23:25:30.528', '2023-07-07 23:25:30.528');
INSERT INTO "public"."permission" VALUES ('1572525965658820616', '1346358560427216896', '1572525965625266184', '2023-07-07 23:25:50.772', '2023-07-07 23:25:50.772');
INSERT INTO "public"."permission" VALUES ('1572525965658820617', '1346358560427216896', '1572525965625266185', '2023-07-07 23:26:11.518', '2023-07-07 23:26:11.518');
INSERT INTO "public"."permission" VALUES ('1572525965658820618', '1346358560427216896', '1572525965625266186', '2023-07-07 23:26:37.388', '2023-07-07 23:26:37.388');


INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312065', '43', 'projectId', 'projectId', 2, 3, 0, '{"required":"1","rule":""}', '2023-07-05 14:06:00.893', '2023-07-07 22:50:00.597');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312066', '43', 'logGroupId', 'logGroupId', 2, 3, 1, '{"required":"1","rule":""}', '2023-07-05 14:09:19.928', '2023-07-07 22:50:00.606');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312067', '43', 'logStreamId', 'logStreamId', 2, 3, 2, '{"required":"1","rule":""}', '2023-07-05 14:09:53.224', '2023-07-07 22:50:00.607');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312068', '43', 'accessKeyId', 'AccessKey', 2, 3, 4, '{"required":"1","rule":""}', '2023-07-05 14:10:41.897', '2023-07-07 22:50:00.608');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312069', '43', 'accessKeySecret', 'accessKey', 2, 3, 5, '{"required":"1","rule":""}', '2023-07-05 14:12:16.828', '2023-07-07 22:50:00.609');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312070', '43', 'regionName', 'regionName', 2, 3, 6, '{"required":"1","rule":""}', '2023-07-05 14:13:24.703', '2023-07-07 22:50:00.610');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312071', '43', 'totalSizeInBytes', 'totalSizeInBytes', 1, 3, 8, '{"required":"0","defaultValue":"104857600","rule":""}', '2023-07-05 14:15:16.913', '2023-07-07 22:50:00.611');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312072', '43', 'maxBlockMs', 'maxBlockMs', 1, 3, 9, '{"required":"0","defaultValue":"0","rule":""}', '2023-07-05 14:16:14.236', '2023-07-07 22:50:00.612');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312073', '43', 'ioThreadCount', 'ioThreadCount', 1, 3, 10, '{"required":"0","defaultValue":"1","rule":""}', '2023-07-05 14:17:12.065', '2023-07-07 22:50:00.612');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312074', '43', 'batchSizeThresholdInBytes', 'batchSizeThresholdInBytes', 1, 3, 11, '{"required":"0","defaultValue":"524288","rule":""}', '2023-07-05 14:18:27.915', '2023-07-07 22:50:00.614');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312075', '43', 'batchCountThreshold', 'batchCountThreshold', 1, 3, 12, '{"required":"0","defaultValue":"4096","rule":""}', '2023-07-05 14:19:27.704', '2023-07-07 22:50:00.615');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312076', '43', 'lingerMs', 'lingerMs', 1, 3, 12, '{"required":"0","defaultValue":"2000","rule":""}', '2023-07-05 14:20:11.908', '2023-07-07 22:50:00.616');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312077', '43', 'retries', 'retries', 1, 3, 13, '{"required":"0","defaultValue":"100","rule":""}', '2023-07-05 14:20:50.052', '2023-07-07 22:50:00.617');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312078', '43', 'baseRetryBackoffMs', 'baseRetryBackoffMs', 1, 3, 14, '{"required":"0","defaultValue":"100","rule":""}', '2023-07-05 14:22:03.347', '2023-07-07 22:50:00.618');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312079', '43', 'maxRetryBackoffMs', 'maxRetryBackoffMs', 1, 3, 15, '{"required":"0","defaultValue":"100","rule":""}', '2023-07-05 14:22:33.010', '2023-07-07 22:50:00.619');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312080', '43', 'enableLocalTest', 'enableLocalTest', 2, 3, 15, '{"required":"0","defaultValue":"false","rule":""}', '2023-07-05 14:25:13.500', '2023-07-07 22:50:00.619');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312081', '43', 'setGiveUpExtraLongSingleLog', 'setGiveUpExtraLongSingleLog', 2, 3, 16, '{"required":"0","defaultValue":"false","rule":""}', '2023-07-05 14:26:20.600', '2023-07-07 22:50:00.620');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312082', '43', 'keyword', 'keyword', 2, 2, 0, '{"required":"0","placeholder":"please use ‘;’ to split keyword","rule":""}', '2023-07-05 14:26:20.600', '2023-07-07 22:50:00.620');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312083', '43', 'maskType', 'maskType', 3, 2, 1, '{"required":"0","defaultValue":"dataMaskByMD5","rule":""}', '2023-07-05 14:26:20.600', '2023-07-07 22:50:00.620');
INSERT INTO "public"."plugin_handle" VALUES ('1570591265492312084', '43', 'maskStatus', 'maskStatus', 3, 2, 2, '{"required":"0","defaultValue":"false","rule":""}','2023-07-05 14:26:20.600', '2023-07-07 22:50:00.620');

INSERT INTO "public"."resource" VALUES ('1572525965625266177', '1346775491550474240', 'loggingHuaweiLts', 'loggingHuaweiLts', '/plug/loggingHuaweiLts', 'loggingHuaweiLts', 1, 0, 'block', 0, 0, '', 1, '2023-07-05 14:03:53.699', '2023-07-05 14:03:53.709');
INSERT INTO "public"."resource" VALUES ('1572525965625266178', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsSelector:add', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266179', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsSelector:delete', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266180', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsSelector:edit', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266181', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.SELECTOR.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsSelector:query', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266182', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsRule:add', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266183', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsRule:delete', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266184', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsRule:edit', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266185', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.RULE.QUERY', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLtsRule:query', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
INSERT INTO "public"."resource" VALUES ('1572525965625266186', '1572525965625266177', 'SHENYU.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 0, '', 1, 0, 'plugin:loggingHuaweiLts:modify', 1, '2023-07-05 14:03:53.721', '2023-07-05 14:03:53.721');
