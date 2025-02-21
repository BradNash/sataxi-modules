output "vanguard_rds_security_group" {
  value = aws_security_group.vanguard_rds_security_group
}

output "vanguard_rds_access_sg" {
  value = aws_security_group.vanguard_rds_access_sg
}
