#data "aws_route_tables" "rts" {
#vpc_id = aws_vpc.base.id

#filter {
#name   = "name"
#values = ["private*"]
#}
#}

#resource "aws_route" "route" {
#count                     = length(data.aws_route_tables.rts.ids)
#route_table_id            = tolist(data.aws_route_tables.rts.ids)[count.index]
#destination_cidr_block    = "0.0.0.0/0"
#}