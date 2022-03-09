CREATE ROLE kandula_app_user 
LOGIN
PASSWORD 'kandula123456';

GRANT all ON DATABASE kanduladb TO kandula_app_user;

CREATE SCHEMA schedule;

CREATE TABLE IF NOT EXISTS schedule.instance_shutdown (
	schedule_id SERIAL NOT NULL PRIMARY key,
	instance_id VARCHAR(32) NOT NULL,
	shutdown_hour NUMERIC NOT NULL CHECK(shutdown_hour >= 0 AND shutdown_hour < 24),
	unique (instance_id, shutdown_hour)
)