output "frontend_public_ip" {
  value = aws_instance.tf-separate-fontend.public_ip
}


output "backend_public_ip" {
  value = aws_instance.tf-separate-backend.public_ip
}
