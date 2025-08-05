variable "aws_region" {
  default = "us-east-1"
}

variable "ecr_repo_name" {
  default = "my-prod-app"
}

variable "ecs_cluster_name" {
  default = "my-prod-cluster"
}

variable "ecr_image_uri" {
  description = "Full URI of the Docker image from CI/CD"
  type        = string
}