provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "lambdaCode"
  output_path = "lambdaCode.zip"
}

resource "aws_lambda_function" "lambda" {

  function_name = "lambda"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  role    = data.aws_iam_role.lambda.arn
  handler = "lambdaCode.lambda_handler"
  runtime = "python3.9"
  timeout = "30"
}


resource "aws_subnet" "private" {
  vpc_id                  = data.aws_vpc.vpc.id
  cidr_block              = "10.0.141.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "exam-mdp-subnet"
  }
}

resource "aws_route_table" "private" {

  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "exam-mdp-rt"
  }
}

resource "aws_route" "private" {

  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = data.aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {

  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.id
}

resource "aws_default_security_group" "default_security_group" {
  vpc_id = data.aws_vpc.vpc.id


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = ["127.0.0.1/32"]
  }

  tags = {
    Name = "exam-mdp-default-security-group"
  }
}
