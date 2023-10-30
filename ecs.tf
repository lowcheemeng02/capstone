# Create an AWS ECS cluster.
resource "aws_ecs_cluster" "main" {
  name = "friends-flask-app-main-cluster"
}

# Create an AWS ECS task.
resource "aws_ecs_task_definition" "main" {
  family                   = "friends-flask-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory = 512
  cpu = 256
  execution_role_arn = "arn:aws:iam::255945442255:role/ecsTaskExecutionRole"
  container_definitions    = <<DEFINITION
  [
    {
      "image": "255945442255.dkr.ecr.us-east-1.amazonaws.com/justinlim-ecr-repo:latest",
      "name": "friends-flask-app",
      "networkmode": "awsvpc",
      "memory": 512,
      "cpu": 256,
      "portMappings":[
        {
          "containerPort":5000,
          "hostPort":5000
        }
      ]
    }
  ]
  DEFINITION
}

# Create an AWS ECS service.
resource "aws_ecs_service" "main" {
  name            = "friends-flask-app-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 3
  launch_type = "FARGATE"
  network_configuration {
    # subnets = [for s in module.test_network.subnets_public: s.id]
    subnets = [for s in module.test_network.subnets_public: s.id]
    assign_public_ip = true
    security_groups = [aws_security_group.allow_http.id]
  }
}

resource "aws_security_group" "allow_http" {
  name = "friends-flask-app-allow-http"
  description = "allow http inbound"
  vpc_id = module.test_network.vpc_id

  ingress {
    description = "from http"
    from_port = 80
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
}




