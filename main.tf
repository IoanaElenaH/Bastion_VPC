resource "aws_instance" "ioana-web-server"{
	ami                    = var.instance_AMI
	instance_type          = var.instance_type
	subnet_id              = aws_subnet.ioana-public-subnet-1.id
	vpc_security_group_ids = [aws_security_group.ioana-web-security-group.id]
    	key_name               = aws_key_pair.ioana-generated-key.key_name
	connection {
        type                   = "ssh"
        user                   = "ec2-user"
        host                   = aws_instance.ioana-web-server.public_ip
  }

  provisioner "remote-exec" {
    inline                     = [
        "sudo yum update -y",
        "sudo yum install php php-mysqlnd httpd -y",
        "wget https://wordpress.org/wordpress-4.8.14.tar.gz",
        "tar -xzf wordpress-4.8.14.tar.gz",
        "sudo cp -r wordpress /var/www/html/",
        "sudo chown -R apache.apache /var/www/html/",
        "sudo systemctl start httpd",
        "sudo systemctl enable httpd",
        "sudo systemctl restart httpd"
    ]
  }
		tags = {
			Name       = "${var.owner}-web-server"
            "KeepInstanceRunning"  = "false"
		}
}

resource "aws_instance" "ioana-MySQL"{
	ami                    = var.instance_AMI
	instance_type          = var.instance_type
	subnet_id              = aws_subnet.ioana-private-subnet-1.id
	vpc_security_group_ids = [aws_security_group.ioana-MySQL-security-group.id, 
                             aws_security_group.ioana-Bastion-update-host-security-group.id
                             ]
    	key_name               = aws_key_pair.ioana-generated-key.key_name
		tags = {
		    	Name       = "${var.owner}-MySQL"
            "KeepInstanceRunning"  = "false"
	    }
}

resource "aws_instance" "ioana-Bastion-host"{
	ami                    = var.instance_AMI
	instance_type          = var.instance_type
	subnet_id              = aws_subnet.ioana-public-subnet-2.id
	vpc_security_group_ids = [aws_security_group.ioana-Bastion-host-security-group.id]
    	key_name               = aws_key_pair.ioana-generated-key.key_name
		tags = {
			Name        = "${var.owner}-Bastion-host"
            "KeepInstanceRunning"   = "false"
		}
       depends_on                   = [
            aws_instance.ioana-web-server,
            aws_instance.ioana-MySQL
            ]
}

terraform {
  	backend "s3" {
    	key        = "terraform/tfstate.tfstate"
	acl        = "private"
    	bucket     = "state-files-for-terraform"
    	region     = "eu-central-1"
  	}
}
