output "vpc_id" {
  value = "${aws_vpc.ioana-vpc.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.ioana-vpc.cidr_block}"
}

output "public-subnet-1_id" {
  value = "${aws_subnet.ioana-public-subnet-1.id}"
}

output "public-subnet-2_id" {
  value = "${aws_subnet.ioana-public-subnet-2.id}"
}

output "private-subnet-1_id" {
  value = "${aws_subnet.ioana-private-subnet-1.id}"
}

output "private-subnet-2_id" {
  value = "${aws_subnet.ioana-private-subnet-2.id}"
}

output "myip"{
  value = data.http.myip.response_body
}

output "ec2-instance-1" {
  value = "${aws_instance.ioana-instance-1}"
}

output "ec2-instance-2" {
  value = "${aws_instance.ioana-instance-2}"
}

output "ec2-instance-3" {
  value = "${aws_instance.ioana-instance-3}"
}