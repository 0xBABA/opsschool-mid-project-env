data "aws_availability_zones" "available" {
  filter {
    name   = "state"
    values = ["available"]
  }
}
