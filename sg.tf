resource "aws_security_group" "public-sg" {
  name        = "public-sg"
  description = "Security group for public subnets"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port   = 80 //http
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443 //https
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0 //send all traffic to internet from our end
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private-sg" {
  name        = "private-sg"
  description = "Security group for private subnets"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port       = 22 //ssh
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-sg.id] //only allow ssh from bastion sg
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public-sg.id] # Only trusts traffic coming through the ALB
  }                                                     // saves me from hacker as alb work as middle man to open app site so nooen can login so bastion can only login so didnt put bastion in alb cuz it allow 22 only alb cant handle 22

  #Need Ssl certificate which is free but u need a domain name which i dotn have so alb dont allow 443

  #also alb translate 443 to 80 automatically no need to define rules in sg for 443


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port   = 22 //ssh
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] //allow ssh from anywhere
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}