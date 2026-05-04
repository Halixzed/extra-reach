resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}

resource "aws_security_group" "ecs_tasks" {
  name   = "${var.app_name}-ecs-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = var.app_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([{
    name         = var.app_name
    image        = "${aws_ecr_repository.app.repository_url}:latest"
    portMappings = [{ containerPort = 80 }]
    environment = [
      { name = "APP_ENV", value = "production" },
      { name = "DB_HOST", value = aws_db_instance.main.address },
      { name = "DB_DATABASE", value = "portfolio" },
      { name = "DB_USERNAME", value = "admin" },
      { name = "AWS_BUCKET", value = aws_s3_bucket.media.bucket },
      { name = "AWS_DEFAULT_REGION", value = var.aws_region }
    ]
    secrets = [
      { name = "APP_KEY", valueFrom = aws_ssm_parameter.app_key.arn },
      { name = "DB_PASSWORD", valueFrom = aws_ssm_parameter.db_password.arn }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.app_name}"
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

resource "aws_ecs_service" "app" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = var.app_name
    container_port   = 80
  }
}

resource "aws_ssm_parameter" "app_key" {
  name  = "/${var.app_name}/app_key"
  type  = "SecureString"
  value = var.app_key
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.app_name}/db_password"
  type  = "SecureString"
  value = var.db_password
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = 7
}