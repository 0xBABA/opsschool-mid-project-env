variable "db_credentials" {
  sensitive   = true
  description = "crednetials for rds db connection"
  type = object({
    user     = string
    password = string
  })
}

variable "db_name" {
  description = "name for RDS postgres sql db"
  type        = string
  default     = "kanduladb"
}

variable "db_secret_name" {
  description = "identifying name for db secrets in secretsmanager"
  type        = string
  default     = "project-db"
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
