variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
  
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0388e3ada3d9812da"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "tutedude"
}