variable "ip_vpc_virginia" {
  type        = string
  description = "Ip de la VPC-Virginia"
}
variable "ip_subnet" {
  type        = list(string)
  description = "ips de la subnet de Virginia"
}

variable "tags_Virginia" {
  description = "Lista de tag para el proyecto"
  type        = map(string)
}

variable "ip_sg" {
  description = "Ips que se conectarán al remoto"
  type        = string
}