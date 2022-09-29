### Bastion_VPC
A Bastion host is used to securely connect to resources on your network.
### Steps
***
1. Provisioning using terraform, which automatically creates a VPC

2. Subnetting

| Public subnets       | Private Subnets|
| ---------------------|----------------|
| Accessible for       | Restricted for |
| Public World         | Public World   |
| ---------------------|----------------|
| 10.0.1.0/24          | 10.0.128.0/24  |
| ---------------------|----------------| 
| 10.0.2.0/24          | 10.0.129.0/24  |

3. Public facing internet gateway for connect our VPC/Network to the internet world and attach this gateway to our VPC

4. Associate the routing table to the Public Subnet to provide the Internet Gateway address

5. NAT gateway to connect our VPC/Network to the internet world - public subnet

6. The private subnet accesses the internet using the NAT gateway created in the public subnet

7. Launch an EC2 instance which has a web_server having the security group allowing port 80

8. Launch an ec2 instance which has MYSQL with security group allowing port 3306 in private subnet so that the web_server VM can connect