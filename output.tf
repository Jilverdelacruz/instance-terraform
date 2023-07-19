output "ip_public_EC2" {
  description = "Ip pública de la instancia"
  value       = aws_instance.PC01-GRETEL.public_ip
}