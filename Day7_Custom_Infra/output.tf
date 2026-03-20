output "name" {
    value = {
        vpc_id = aws_vpc.dev_vpc.id
        public_subnet_1_id = aws_subnet.public_subnet_1.id
        private_subnet_1_id = aws_subnet.private_subnet_1.id
        private_subnet_2_id = aws_subnet.private_subnet_2.id
        internet_gateway_id = aws_internet_gateway.igw.id
        route_table_public_id = aws_route_table.public_rt.id
        elastic_ip_id = aws_eip.nat_gw_eip.id
        nat_gateway_id = aws_nat_gateway.nat_gw.id
        route_table_private_id = aws_route_table.private_rt.id


        public_ip = aws_instance.bastion_ec2.public_ip
        private_ip = aws_instance.bastion_ec2.private_ip
        availability_zone = aws_instance.bastion_ec2.availability_zone
        
    }
  
}