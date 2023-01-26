///ALB
resource "aws_security_group" "alb-shoval-sg-iac" {
  name        = "alb-shoval-sg-iac-${terraform.workspace}"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc-id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  tags = {
      "Owner" =	var.Owner
    }
}

resource "aws_lb_target_group" "target-shoval-iac" {
  name        = "target1-shoval-iac-${terraform.workspace}"
  # target_type = "alb"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc-id
  
  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    timeout             = "2"
    interval            = "5" 
    path                = "/"
   }
  #  depends_on = [
  #    var.ec2_name[count.index], var.ec2_name[count.index]
  #   ]
   tags = {
      "Owner" =	var.Owner
    }
}
resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.alb_shoval_iac.arn
  protocol = "HTTP"
  port = "80"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target-shoval-iac.arn
  }
}

resource "aws_lb_target_group_attachment" "add_proc1_iac" {
  count = var.ec2-count
  target_group_arn = aws_lb_target_group.target-shoval-iac.arn
  target_id        = aws_instance.prod_shoval_iac[count.index].id
  port             = 80
}

# resource "aws_lb_target_group_attachment" "add_proc2_iac" {
#   target_group_arn = aws_lb_target_group.target-shoval-iac.arn
#   target_id        = aws_instance.prod2_shoval_iac.id
#     port           = 80
# }


resource "aws_lb" "alb_shoval_iac" {
  name               = "alb1-shoval-iac-${terraform.workspace}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-shoval-sg-iac.id]
  subnets            = var.subnets-id

#   enable_deletion_protection = true

   tags = {
    Environment = "production"
    Owner =	var.Owner
    }
}

////////////////////ec2 
resource "aws_security_group" "prodSG_iac_shoval" {
  name        = "prod_iac_shoval-${terraform.workspace}"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = var.vpc-id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb-shoval-sg-iac.id] 
  }
  egress {
    from_port = 0
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
}
//iam role
resource "aws_iam_role" "iam_role_to_ec2" {
  name = "iam_role_to_ec2"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    tag-key = "iam_role_to_ec2"
  }
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${terraform.workspace}_profile"
  role = "${aws_iam_role.iam_role_to_ec2.name}"
}
resource "aws_iam_role_policy" "ecr_ec2" {
  name = "ecr_ec2"
  role = "${aws_iam_role.iam_role_to_ec2.id}"
  policy = data.local_file.ami_role.content

}
resource "aws_instance" "prod_shoval_iac" {
  count = var.ec2-count
  ami = var.ami_prod
  instance_type = var.instance_type_prod
  subnet_id = var.subnets-id[count.index]
  vpc_security_group_ids = [aws_security_group.prodSG_iac_shoval.id]
  associate_public_ip_address = true
  user_data = data.local_file.user_data.content
  //add the role
  iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"


     tags = merge(var.tags,{
      "Name" =format("%s-%s",var.ec2_name[count.index],"${terraform.workspace}")
    })
}
resource "aws_key_pair" "tf-key-pair" {
key_name = "tf-key-pair"
public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}

resource "local_file" "ssh-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "ssh-key-pair"
}