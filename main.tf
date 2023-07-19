resource "aws_vpc" "vpc_virginia" {
  cidr_block = var.ip_vpc_virginia
  tags = {
    Name = "VPC_VIRGINIA"
  }
}
resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.vpc_virginia.id
  cidr_block              = var.ip_subnet[0]
  map_public_ip_on_launch = true
  tags = {
    Name="Public_Subnet"
  }

}
resource "aws_subnet" "subnet_private" {
  vpc_id     = aws_vpc.vpc_virginia.id
  cidr_block = var.ip_subnet[1]
  tags = {
    Name = "Private_Subnet"
  }
}

resource "aws_instance" "PC01-GRETEL" {
  ami           = "ami-06ca3ca175f37dd66"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_public.id
  vpc_security_group_ids = [aws_security_group.sg_public.id]
  key_name = aws_key_pair.test.key_name

}

/*resource "aws_key_pair" "test" {
  key_name   = "test"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}*/

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "test" {
  key_name   = "myKey"       # Create a "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.test.key_name}.pem"
  content = tls_private_key.pk.private_key_pem
}

resource "aws_internet_gateway" "Gateway_Virginia" {
  vpc_id = aws_vpc.vpc_virginia.id
  tags = {
    Name = "igw vpc virginia"
  }
}

resource "aws_route_table" "crt_public" { /*custom route table*/
  vpc_id = aws_vpc.vpc_virginia.id

  route {
    cidr_block = "0.0.0.0/0" /*cualquier destino*/
    gateway_id = aws_internet_gateway.Gateway_Virginia.id
  }

  tags = {
    Name = "public ctr"
  }
}

resource "aws_route_table_association" "art_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.crt_public.id
}

resource "aws_security_group" "sg_public" {
  name        = "pubic instance sg"
  description = "permite trafico de ingreso ssh y salida"
  vpc_id      = aws_vpc.vpc_virginia.id

  ingress {
    description      = "ssh para vpc virginia"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.ip_sg]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "public instance sg" /*Al finalizar se tiene que vincular en la instancia al SG*/
  }
}