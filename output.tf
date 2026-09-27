output "vpc_id" {
  description = "ID of the main VPC"
  value       = aws_vpc.main-vpc.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main-vpc.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main-igw.id
}

output "public_subnet_1_id" {
  description = "ID of public subnet 1"
  value       = aws_subnet.public-subnet-1.id
}

output "public_subnet_2_id" {
  description = "ID of public subnet 2"
  value       = aws_subnet.public-subnet-2.id
}

output "private_subnet_1_id" {
  description = "ID of private subnet 1"
  value       = aws_subnet.private-subnet-1.id
}

output "private_subnet_2_id" {
  description = "ID of private subnet 2"
  value       = aws_subnet.private-subnet-2.id
}

output "public_route_table_id" {
  description = "ID of public route table"
  value       = aws_route_table.public-main-rt.id
}

output "private_route_table_id" {
  description = "ID of private route table"
  value       = aws_route_table.private-main-rt.id
}

output "nat_gateway_id" {
  description = "ID of NAT Gateway"
  value       = aws_nat_gateway.main-nat-gw.id
}

output "elastic_ip" {
  description = "Elastic IP allocated to NAT Gateway"
  value       = aws_eip.main-nat-eip.public_ip
}

output "bastion_1_id" {
  description = "ID of bastion EC2 in AZ 1"
  value       = aws_instance.bastion-ec2-1.id
}

output "bastion_1_public_ip" {
  description = "Public IP of bastion EC2 in AZ 1"
  value       = aws_instance.bastion-ec2-1.public_ip
}

output "bastion_3_id" {
  description = "ID of bastion EC2 in AZ 2"
  value       = aws_instance.bastion-ec2-3.id
}

output "bastion_3_public_ip" {
  description = "Public IP of bastion EC2 in AZ 2"
  value       = aws_instance.bastion-ec2-3.public_ip
}

output "public_ec2_2_id" {
  description = "ID of public EC2 2"
  value       = aws_instance.public-ec2-2.id
}

output "public_ec2_4_id" {
  description = "ID of public EC2 4"
  value       = aws_instance.public-ec2-4.id
}

output "private_asg_name" {
  description = "Name of private EC2 Auto Scaling Group"
  value       = aws_autoscaling_group.private-ec2-asg.name
}