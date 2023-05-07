resource "aws_vpc" "base" {
  cidr_block = var.cidr_block

  tags = {
    Name = "${local.name}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.base.id
  count                   = length(var.cidr_blocks)
  cidr_block              = var.cidr_blocks[count.index]
  map_public_ip_on_launch = var.public_ip_on_launch
  availability_zone       = var.az[count.index]

  tags = {
    Name = var.subnet_tags[count.index]
  }
}

resource "aws_internet_gateway" "base_internet_gateway" {
  vpc_id = aws_vpc.base.id

  tags = {
    Name = "${local.name}-IGW"
  }
}

resource "aws_route_table" "pub_rt" {
  count  = var.counts
  vpc_id = aws_vpc.base.id

  tags = {
    Name = var.subnet_tags[count.index]
  }
}

resource "aws_route" "my_route" {
  count                  = var.counts
  route_table_id         = aws_route_table.pub_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.base_internet_gateway.id

}

resource "aws_route_table_association" "my_route_association" {
  count          = var.counts
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.pub_rt[count.index].id

}


resource "aws_security_group" "ugo" {
  name   = "base"
  vpc_id = aws_vpc.base.id
  dynamic "ingress" {
    for_each = [22, 80]
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

}


resource "aws_key_pair" "ugo" {
  key_name   = var.key_name
  public_key = file(var.public_key)
}

resource "aws_instance" "my_server" {
  count                  = length(var.ami)
  instance_type          = var.instance_type[count.index]
  ami                    = var.ami[count.index]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ugo.id]
  subnet_id              = aws_subnet.public_subnet[count.index].id
  user_data              = file("userdata.tpl")


  tags = {
    Name = var.subnet_tags[count.index]
  }
}