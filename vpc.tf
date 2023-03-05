resource "aws_vpc" "ugo_b" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Base"
  }
}

resource "aws_subnet" "new_public_subnet" {
  vpc_id                  = aws_vpc.ugo_b.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Pub_sub"
  }
}

resource "aws_subnet" "vscode_subnet" {
  vpc_id     = aws_vpc.ugo_b.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Subnet_ugo"
  }
}


resource "aws_internet_gateway" "ugo_b_internet_gateway" {
  vpc_id = aws_vpc.ugo_b.id

  tags = {
    Name = "ugo_b_igw"
  }
}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.ugo_b.id

  tags = {
    Name = "ugo_b_rt"
  }
}

resource "aws_route" "my_route" {
  route_table_id         = aws_route_table.pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ugo_b_internet_gateway.id
}

resource "aws_route_table_association" "my_route_association" {
  subnet_id      = aws_subnet.vscode_subnet.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_security_group" "sg" {
  name        = "ugo_b_sg"
  description = "ugo_b_sg"
  vpc_id      = aws_vpc.ugo_b.id


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["192.168.178.162/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ugo_k" {
  key_name   = "ugokey"
  public_key = file("~/.ssh/ugokey.pub")
}

resource "aws_instance" "my_server" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.base.id
  key_name               = aws_key_pair.ugo_k.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.new_public_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev"
  }
}