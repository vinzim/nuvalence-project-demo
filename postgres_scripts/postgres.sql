begin;
CREATE TABLE IF NOT EXISTS datatable (
  username varchar(45) NOT NULL,
  password varchar(450) NOT NULL,
  enabled integer NOT NULL DEFAULT '1',
  PRIMARY KEY (username)
)
CREATE USER nuvalence WITH PASSWORD 'PASSWORD';
GRANT ALL PRIVILEGES ON datatable IN SCHEMA public TO nuvalence;
commit;