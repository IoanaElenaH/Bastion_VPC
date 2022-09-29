data "http" "myip"{
    url              = "http://ipv4.icanhazip.com" 
}

resource "aws_security_group" "ioana-web-security-group"{
    vpc_id           = "${aws_vpc.ioana-vpc.id}"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.myip.response_body)}/32"]
    description      = "SSH"
  }

   ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "ICMP"
    cidr_blocks      = [var.cidr_block]
    description      = "ping"
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_block]
    description      = "HTTP"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = [var.cidr_block]
    description      = "Web_server output"
  }
  tags = {
    Name = "${var.owner}-security-group-Web-public-instance"
  }
  description        = "HTTP, PING, SSH"
  depends_on         = [aws_vpc.ioana-vpc,
        aws_subnet.ioana-public-subnet-1,
        aws_subnet.ioana-public-subnet-2,
        aws_subnet.ioana-private-subnet-1,
        aws_subnet.ioana-private-subnet-2]
} 

resource "aws_security_group" "ioana-MySQL-security-group"{
   vpc_id            = "${aws_vpc.ioana-vpc.id}"
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.myip.response_body)}/32"]
    description      = "SSH"
  }

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.ioana-web-security-group.id]
    description      = "MySQL Access"
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.ioana-web-security-group.id]
    description      = "HTTP"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = [var.cidr_block]
    description      = "output from MySQL"
  }
  
  tags               = {
    Name             = "${var.owner}-security-group-MySQL-private-instance"
  }
  description        = "Limit access"
  depends_on         = [aws_vpc.ioana-vpc,
        aws_subnet.ioana-public-subnet-1,
        aws_subnet.ioana-public-subnet-2,
        aws_subnet.ioana-private-subnet-1,
        aws_subnet.ioana-private-subnet-2,
        aws_security_group.ioana-web-security-group]
}

resource "aws_security_group" "ioana-Bastion-host-security-group"{
   vpc_id             = "${aws_vpc.ioana-vpc.id}"
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.ioana-web-security-group.id]
    description      = "Bastion host security group"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = [var.cidr_block]
    description      = "output from Bastion host"
  }
  
  tags               = {
    Name             = "${var.owner}-security-group-Bastion-instance"
  }
  description        = "MySQL Access only from the Webserver Instances"
  depends_on         = [aws_vpc.ioana-vpc,
        aws_subnet.ioana-public-subnet-1,
        aws_subnet.ioana-public-subnet-2,
        aws_subnet.ioana-private-subnet-1,
        aws_subnet.ioana-private-subnet-2]
}

resource "aws_security_group" "ioana-Bastion-update-host-security-group"{
   vpc_id            = "${aws_vpc.ioana-vpc.id}"
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_security_group.ioana-Bastion-host-security-group.id]
    description      = "Bastion host update security group"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = [var.cidr_block]
    description      = "output from Bastion host"
  }
  
  tags               = {
    Name             = "${var.owner}-security-group-Bastion-Connect-private-instance"
  }
  description        = "MySQL Bastion host access for updates and connection"
  depends_on         = [aws_vpc.ioana-vpc,
        aws_subnet.ioana-public-subnet-1,
        aws_subnet.ioana-public-subnet-2,
        aws_subnet.ioana-private-subnet-1,
        aws_subnet.ioana-private-subnet-2,
        aws_security_group.ioana-Bastion-host-security-group]
} 