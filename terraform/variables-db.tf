
variable "db_name" {
  description = "name for RDS postgres sql db"
  type        = string
  default     = "kanduladb"
}

variable "db_secret_name" {
  description = "identifying name for db secrets in secretsmanager"
  type        = string
  default     = "kandula-db-test"
}

variable "db_storage" {
  description = "size of db in gb"
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "engine and version for rds db"
  type        = map(string)
  default = {
    engine  = "postgres"
    version = "12.9"
  }
}

variable "db_instance_class" {
  description = "instance type to be used for db instances"
  type        = string
  default     = "db.t2.micro"
}

variable "db_port" {
  description = "port for db connections"
  type        = number
  default     = 5432
}

variable "ansible_psql_role_vars_filepath" {
  description = "file path for vars file used in ansible psql role"
  type        = string
  default     = "../ansible/roles/psql/vars/main.yml"
}

variable "db_setup_script_filepath" {
  description = "file path for sql file used for initial db setup"
  type        = string
  default     = "../ansible/roles/psql/files/setup_db.sql"
}
