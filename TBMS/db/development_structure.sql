CREATE TABLE "emailaccounts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255), "name" varchar(255), "preferences" text, "last_get" datetime, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "file_creators" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "zipPath" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "groups" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "preferences" text, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "user_sessions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "session_id" varchar(255) NOT NULL, "data" text, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "login" varchar(255) NOT NULL, "crypted_password" varchar(255) NOT NULL, "password_salt" varchar(255) NOT NULL, "persistence_token" varchar(255) NOT NULL, "single_access_token" varchar(255) NOT NULL, "perishable_token" varchar(255) NOT NULL, "login_count" integer DEFAULT 0 NOT NULL, "failed_login_count" integer DEFAULT 0 NOT NULL, "last_request_at" datetime, "current_login_at" datetime, "last_login_at" datetime, "current_login_ip" varchar(255), "last_login_ip" varchar(255), "name" varchar(255) DEFAULT '' NOT NULL, "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_sessions_on_session_id" ON "user_sessions" ("session_id");
CREATE INDEX "index_sessions_on_updated_at" ON "user_sessions" ("updated_at");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20110329095113');

INSERT INTO schema_migrations (version) VALUES ('20110322081806');

INSERT INTO schema_migrations (version) VALUES ('20110322200029');

INSERT INTO schema_migrations (version) VALUES ('20110322200712');

INSERT INTO schema_migrations (version) VALUES ('20110329081806');