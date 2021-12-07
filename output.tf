# Output of web security group name
output "websg_name" {
  value = "${aws_security_group.web_sg.name}"
}

# Output of app security group name
output "appsg_name" {
  value = "${aws_security_group.app_sg.name}"
}
# Output of db security group name
output "dbsg_name" {
  value = "${aws_security_group.db_sg.name}"
}
# Output of lb security group name
output "lbsg_name" {
  value = "${aws_security_group.lb_sg.name}"
}
# Output of VPC name
output "vpc_name" {
  value = "${aws_vpc.main.id != "" ? var.vpc_name : ""}"
}

# Output of web subnet name
output "websub_name" {
  value = "${aws_subnet.web_subnet1.id != "" ? var.web_subnet1_name : ""}"
}

# Output for web subnet2 name
output "websub2_name" {
 value = "${aws_subnet.web_subnet2.id != "" ? var.web_subnet2_name : ""}"
}
# Output of app subnet name
output "appsub1_name" {
  value = "${aws_subnet.app_subnet1.id != "" ? var.app_subnet1_name : ""}"
}
# Output of app subnet name
output "appsub2_name" {
  value = "${aws_subnet.app_subnet2.id != "" ? var.app_subnet2_name : ""}"
}
# Output of db subnet name
output "dbsub1_name" {
  value = "${aws_subnet.db_subnet1.id != "" ? var.db_subnet1_name : ""}"
}
# Output of db subnet name
output "dbsub2_name" {
  value = "${aws_subnet.db_subnet2.id != "" ? var.db_subnet2_name : ""}"
}
