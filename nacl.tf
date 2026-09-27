resource "aws_network_acl" "public-nacl" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "public-nacl"
  }
}
resource "aws_network_acl_rule" "public-nacl-ingress-allow-http" {
  network_acl_id = aws_network_acl.public-nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "public-nacl-egress-allow-http" {
  network_acl_id = aws_network_acl.public-nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
resource "aws_network_acl_association" "public-nacl-association-subnet-1" {
  subnet_id = aws_subnet.public-subnet-1.id

  network_acl_id = aws_network_acl.public-nacl.id
}
resource "aws_network_acl_association" "public-nacl-association-subnet-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  network_acl_id = aws_network_acl.public-nacl.id
}
#----------------------------------------------------------
resource "aws_network_acl" "private-nacl" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name = "private-nacl"
  }
}
resource "aws_network_acl_rule" "private-nacl-ingress-allow-http" {
  network_acl_id = aws_network_acl.private-nacl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "private-nacl-egress-allow-http" {
  network_acl_id = aws_network_acl.private-nacl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
resource "aws_network_acl_association" "private-nacl-association-subnet-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  network_acl_id = aws_network_acl.private-nacl.id
}
resource "aws_network_acl_association" "private-nacl-association-subnet-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  network_acl_id = aws_network_acl.private-nacl.id
}
#----------------------------------------------------------