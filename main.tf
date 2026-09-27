resource "aws_vpc" "main-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true //help translate dns name into ip address 
  enable_dns_hostnames = true //give name to the instances in the vpc
  tags = {
    Name = "main-vpc"
  }
}
#----------------------------------------------------------
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "main-igw" //public ->igw ->intenret
  }
}

resource "aws_route_table" "public-main-rt" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
}
resource "aws_route_table_association" "public-subnet-1-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-main-rt.id
}
resource "aws_route_table_association" "public-subnet-2-association" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-main-rt.id
}
#---------------------------------------------------------

resource "aws_nat_gateway" "main-nat-gw" { //private ->nat ->igw ->internet
  allocation_id = aws_eip.main-nat-eip.id
  subnet_id     = aws_subnet.public-subnet-1.id //store in public subnet 1

  depends_on = [
    aws_internet_gateway.main-igw
  ]
  tags = {
    Name = "main-nat-gw"
  }
}
resource "aws_eip" "main-nat-eip" { //changes the public ip coming from private to our aws account some reserved elastic ip(public ip) and then it will be used by nat gateway to access internet from private subnet
  domain = "vpc"
  tags = {
    Name = "main-nat-eip"
  }
}
resource "aws_route_table" "private-main-rt" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block     = "0.0.0.0/0" //means all traffic to internet from our side if we wanna access anything we can from ec2 if i wanna allow my ec2 to just allow goggle i will do cidr = 8.8.8.8/0
    nat_gateway_id = aws_nat_gateway.main-nat-gw.id
  }
}
resource "aws_route_table_association" "private-subnet-1-association" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-main-rt.id
}
resource "aws_route_table_association" "private-subnet-2-association" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-main-rt.id
}
#----------------------------------------------------------
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.zone1
  map_public_ip_on_launch = true //provide public ip to every instance launched in this subnet
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.zone2
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = var.zone1
  map_public_ip_on_launch = false //don't provide public ip to every instance launched in this subnet cause use private ec2
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = var.zone2
  map_public_ip_on_launch = false //don't provide public ip to every instance launched in this subnet cause use private ec2
  tags = {
    Name = "private-subnet-2"
  }
}
#----------------------------------------------------------

resource "aws_instance" "bastion-ec2-1" { //act as bastion host
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public-subnet-1.id
vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  key_name        = var.key_name
  tags = {
    Name = "bastion-ec2-1"
  }
}
resource "aws_instance" "public-ec2-2" { //act as request forwarder to private ec2
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public-subnet-1.id
vpc_security_group_ids = [aws_security_group.public-sg.id]
  key_name        = var.key_name //stores public key if not then we can login to ec2 using private cause it will not  authenticate us cause it iwll nto have anykey
  tags = {
    Name = "public-ec2"
  }
}
resource "aws_instance" "bastion-ec2-3" { //act as bastion host
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public-subnet-2.id
vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  key_name        = var.key_name
  tags = {
    Name = "bastion-ec2-3"
  }
}
resource "aws_instance" "public-ec2-4" { //act as request forwarder to private ec2
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public-subnet-2.id
  vpc_security_group_ids = [aws_security_group.public-sg.id]
  key_name        = var.key_name
  tags = {
    Name = "public-ec2-4"
  }
}
//creating private ec2 instances using launch template
resource "aws_launch_template" "private-ec2-template" {
  name_prefix   = "private-ec2-template"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name //ec2 cant talk to s3 cuz block all public access even not still  so iam role have pemrission so this provide badage to ec2 so it can access
  }
  #the code below is from ai which will store my bucket into folder of app automatcially whenever linux boot and then the files or anything app have will go into my s3 this connect s3 bucket to my file 
  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "BUCKET_NAME=${aws_s3_bucket.my-app-s3.id}" >> /etc/environment
              EOF 
  )
  # userdata is reserve --- use for write script
  #base64encode change our script into binary so machine understand
  #store in system etc environment and >eof mean open file and close and bin bash is shebang alrdy know
  #When your application code starts up on the server, it automatically opens that Linux /etc/environment notepad file.
  # It reads BUCKET_NAME=my-app-storage-bucket-a1b2c3d4 and loads it into its brain.
  # save in our ec2 of app then whenever we run any app the ec2 have already this code which will connect s3 to any code
  network_interfaces {
    associate_public_ip_address = false
    security_groups              = [aws_security_group.private-sg.id]
  }
}

resource "aws_autoscaling_group" "private-ec2-asg" {
  name                = "private-ec2-asg"
  max_size            = 2
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
  target_group_arns   = [aws_lb_target_group.main-tg.arn] // it will be trageted by alb

  launch_template {
    id      = aws_launch_template.private-ec2-template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "private-ec2"
    propagate_at_launch = true //mean tag will be applied to all instances launched by this asg
  }
}