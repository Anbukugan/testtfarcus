# Creation of a VPC
resource "aws_vpc" "main" {
  cidr_block                       = "${var.vpc_cidr_range}"
  instance_tenancy                 = "${var.vpc_instance_tenancy}"
  enable_dns_support               = "${var.enable_dns_support}"
  enable_dns_hostnames             = "${var.enable_dns_hostnames}"
  assign_generated_ipv6_cidr_block = "${var.assign_ipv6_cidr}"
  tags                             = "${map("Name",var.vpc_name)}"
}

# Creation of web subnet 1
resource "aws_subnet" "web_subnet1" {
  vpc_id                           = "${aws_vpc.main.id}"
  cidr_block                       = "${var.web_subnet1_range}"
  tags                             = "${map("Name",var.web_subnet1_name)}"
  availability_zone                = "${var.region}a"
}

# Creation of web subnet 2
resource "aws_subnet" "web_subnet2" {
  vpc_id                           = "${aws_vpc.main.id}"
  cidr_block                       = "${var.web_subnet2_range}"
  tags                             = "${map("Name",var.web_subnet2_name)}"
  availability_zone                = "${var.region}b"
}

# Creation of app subnet 1
resource "aws_subnet" "app_subnet1" {
  vpc_id                           = "${aws_vpc.main.id}"
  cidr_block                       = "${var.app_subnet1_range}"
  tags                             = "${map("Name",var.app_subnet1_name)}"
  availability_zone                = "${var.region}a"
}

# Creation of app subnet 2
resource "aws_subnet" "app_subnet2" {
  vpc_id                           = "${aws_vpc.main.id}"
  cidr_block                       = "${var.app_subnet2_range}"
  tags                             = "${map("Name",var.app_subnet2_name)}"
  availability_zone                = "${var.region}b"
}

# Creation of db subnet 1
resource "aws_subnet" "db_subnet1" {
  vpc_id                           = "${aws_vpc.main.id}"
  cidr_block                       = "${var.db_subnet1_range}"
  tags                             = "${map("Name",var.db_subnet1_name)}"
  availability_zone                = "${var.region}a"
}

# Creation of db subnet 2
resource "aws_subnet" "db_subnet2" {
  vpc_id                           = "${aws_vpc.main.id}"
  cidr_block                       = "${var.db_subnet2_range}"
  tags                             = "${map("Name",var.db_subnet2_name)}"
  availability_zone                = "${var.region}b"
}

# Creation of web NACL with inbund & outbound rules
resource "aws_network_acl" "web_nacl" {
  vpc_id                           = "${aws_vpc.main.id}"
  subnet_ids                       = ["${aws_subnet.web_subnet1.id}","${aws_subnet.web_subnet2.id}"]
  egress {
    protocol                       = "tcp"
    rule_no                        = 200
    action                         = "allow"
    cidr_block                     = "0.0.0.0/0"
    from_port                      = 0
    to_port                        = 65535
  }

  ingress {
    protocol                       = "tcp"
    rule_no                        = 100
    action                         = "allow"
    cidr_block                     = "0.0.0.0/0"
    from_port                      = 0
    to_port                        = 65535
  }

  tags                             = "${map("Name",var.web_nacl_name)}" 
}

# Creation of app NACL with inbund & outbound rules
resource "aws_network_acl" "app_nacl" {
  vpc_id                           = "${aws_vpc.main.id}"
  subnet_ids                       = ["${aws_subnet.app_subnet1.id}","${aws_subnet.app_subnet2.id}"]
  egress {
    protocol                       = "tcp"
    rule_no                        = 200
    action                         = "allow"
    cidr_block                     = "10.10.2.0/24"
    from_port                      = 0
    to_port                        = 65535
  }

  ingress {
    protocol                       = "tcp"
    rule_no                        = 100
    action                         = "allow"
    cidr_block                     = "10.10.2.0/24"
    from_port                      = 0
    to_port                        = 65535
  }
 egress {
    protocol                       = "tcp"
    rule_no                        = 300
    action                         = "allow"
    cidr_block                     = "10.10.3.0/24"
    from_port                      = 0
    to_port                        = 65535
  }

  ingress {
    protocol                       = "tcp"
    rule_no                        = 200
    action                         = "allow"
    cidr_block                     = "10.10.3.0/24"
    from_port                      = 0
    to_port                        = 65535
  }

  egress {
    protocol                       = "tcp"
    rule_no                        = 400
    action                         = "allow"
    cidr_block                     = "10.10.0.0/24"
    from_port                      = 0
    to_port                        = 65535
  }

  ingress {
    protocol                       = "tcp"
    rule_no                        = 300
    action                         = "allow"
    cidr_block                     = "10.10.0.0/24"
    from_port                      = 0
    to_port                        = 65535
  }
  egress {
    protocol                       = "tcp"
    rule_no                        = 500
    action                         = "allow"
    cidr_block                     = "10.10.1.0/24"
    from_port                      = 0
    to_port                        = 65535
  }

  ingress {
    protocol                       = "tcp"
    rule_no                        = 400
    action                         = "allow"
    cidr_block                     = "10.10.1.0/24"
    from_port                      = 0
    to_port                        = 65535
  }

  tags                             = "${map("Name",var.app_nacl_name)}" 
}

# Creation of db NACL with inbund & outbound rules
resource "aws_network_acl" "db_nacl" {
  vpc_id                           = "${aws_vpc.main.id}"
  subnet_ids                       = ["${aws_subnet.db_subnet1.id}","${aws_subnet.db_subnet2.id}"]
  egress {
    protocol                       = "tcp"
    rule_no                        = 200
    action                         = "allow"
    cidr_block                     = "0.0.0.0/0"
    from_port                      = 3306
    to_port                        = 3306
  }

  ingress {
    protocol                       = "tcp"
    rule_no                        = 100
    action                         = "allow"
    cidr_block                     = "0.0.0.0/0"
    from_port                      = 3306
    to_port                        = 3306
  }

  tags                             = "${map("Name",var.db_nacl_name)}" 
}

# Creation of web Network security group
resource "aws_security_group" "web_sg" {
  name                             = "${var.web_sg_name}"
  description                      = "${var.web_sg_description}"
  vpc_id                           = "${aws_vpc.main.id}"

  ingress {
    from_port                      = 22
    to_port                        = 22
    protocol                       = "TCP"
    cidr_blocks                    = ["0.0.0.0/0"]
  }
  ingress {
    from_port                      = 80
    to_port                        = 80
    protocol                       = "TCP"
    cidr_blocks                    = ["0.0.0.0/0"]
  }  
  ingress {
    from_port                      = 443
    to_port                        = 443
    protocol                       = "TCP"
    cidr_blocks                    = ["0.0.0.0/0"]
  }
  egress {
    from_port                      = 0
    to_port                        = 0
    protocol                       = "-1"
    cidr_blocks                    = ["0.0.0.0/0"]
  }
  tags                             = "${map("Name",var.web_sg_name)}" 
}

# Creation of app Network security group
resource "aws_security_group" "app_sg" {
  name                             = "${var.app_sg_name}"
  description                      = "${var.app_sg_description}"
  vpc_id                           = "${aws_vpc.main.id}"

  ingress {
    from_port                      = 22
    to_port                        = 22
    protocol                       = "TCP"
    cidr_blocks                    = ["0.0.0.0/0"]
  }
  ingress {
    from_port                      = 80
    to_port                        = 80
    protocol                       = "TCP"
    cidr_blocks                    = ["0.0.0.0/0"]
  } 
  ingress {
    from_port                      = 443
    to_port                        = 443
    protocol                       = "TCP"
    cidr_blocks                    = ["0.0.0.0/0"]
  }

  egress {
    from_port                      = 0
    to_port                        = 0
    protocol                       = "-1"
    cidr_blocks                    = ["0.0.0.0/0"]
  }
  tags                             = "${map("Name",var.app_sg_name)}" 
}

# Creation of db Network security group
resource "aws_security_group" "db_sg" {
  name                             = "${var.db_sg_name}"
  description                      = "${var.db_sg_description}"
  vpc_id                           = "${aws_vpc.main.id}"

  ingress {
    from_port                      = 3306
    to_port                        = 3306
    protocol                       = "TCP"
    security_groups                = ["${aws_security_group.web_sg.id}","${aws_security_group.app_sg.id}"]
  }

  egress {
    from_port                      = 0
    to_port                        = 0
    protocol                       = "-1"
    cidr_blocks                    = ["0.0.0.0/0"]
  }
  tags                             = "${map("Name",var.db_sg_name)}"
}

# Creation of web Network security group
resource "aws_security_group" "lb_sg" {
  name                             = "${var.lb_sg_name}"
  description                      = "${var.lb_sg_description}"
  vpc_id                           = "${aws_vpc.main.id}"

  ingress {
    from_port                      = 80
    to_port                        = 80
    protocol                       = "TCP"
    cidr_blocks                    = ["0.0.0.0/0"]
  }  
  ingress {
    from_port                      = 443
    to_port                        = 443
    protocol                       = "TCP"
    cidr_blocks                    = ["0.0.0.0/0"]
  }
  egress {
    from_port                      = 0
    to_port                        = 0
    protocol                       = "-1"
    cidr_blocks                    = ["0.0.0.0/0"]
  }
  tags                             = "${map("Name",var.web_sg_name)}" 
}


# Creation of Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id                           = "${aws_vpc.main.id}"
  tags                             = "${map("Name",var.igw_name)}" 
}

# Creation of Elastic IP
resource "aws_eip" "eip" {
  vpc      = true
}

# Creation of NAT Gateway
resource "aws_nat_gateway" "gw" {
  allocation_id                    = "${aws_eip.eip.id}"
  subnet_id                        = "${aws_subnet.web_subnet1.id}"
  tags                             = "${map("Name", var.nat_gw_name)}"
}

# Creation for Web route table
resource "aws_route_table" "rt_1" {
  vpc_id                           = "${aws_vpc.main.id}"
  tags                             = "${map("Name",var.rt1_name)}"
}

# Creation of App route table
resource "aws_route_table" "rt_2" {
  vpc_id                           = "${aws_vpc.main.id}"
  tags                             = "${map("Name",var.rt2_name)}"
}

# Creation of DB route table
resource "aws_route_table" "rt_3" {
  vpc_id                           = "${aws_vpc.main.id}"
  tags                             = "${map("Name",var.rt3_name)}"
}
resource "aws_route_table_association" "rt1_association1" {
  subnet_id                        = "${aws_subnet.web_subnet1.id}"
  route_table_id                   = "${aws_route_table.rt_1.id}"
}

resource "aws_route_table_association" "rt1_association2" {
  subnet_id                        = "${aws_subnet.web_subnet2.id}"
  route_table_id                   = "${aws_route_table.rt_1.id}"
}

resource "aws_route_table_association" "rt2_association1" {
  subnet_id                        = "${aws_subnet.app_subnet1.id}"
  route_table_id                   = "${aws_route_table.rt_2.id}"
}

resource "aws_route_table_association" "rt2_association2" {
  subnet_id                        = "${aws_subnet.app_subnet2.id}"
  route_table_id                   = "${aws_route_table.rt_2.id}"
}

resource "aws_route_table_association" "rt3_association1" {
  subnet_id                        = "${aws_subnet.db_subnet1.id}"
  route_table_id                   = "${aws_route_table.rt_3.id}"
}


resource "aws_route_table_association" "rt3_association2" {
  subnet_id                        = "${aws_subnet.db_subnet2.id}"
  route_table_id                   = "${aws_route_table.rt_3.id}"
}

resource "aws_route" "route_rt_1" {
  route_table_id            = "${aws_route_table.rt_1.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = "${aws_internet_gateway.igw.id}"
}

resource "aws_route" "route_rt_2" {
  route_table_id            = "${aws_route_table.rt_2.id}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = "${aws_nat_gateway.gw.id}"
}

resource "aws_route" "route_rt_3" {
  route_table_id            = "${aws_route_table.rt_3.id}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = "${aws_nat_gateway.gw.id}"
}
