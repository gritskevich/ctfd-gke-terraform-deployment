variable "ssh_password" {
  type        = string
  description = "SSH bruteforce password"
}

variable "ssh_login" {
  type        = string
  description = "SSH login"
}

variable "ssh_ip" {
  type        = string
  description = "SSH bruteforce IP"
}

variable "port_ip" {
  type        = string
  description = "Port Scan IP"
}

variable "port_number" {
  type        = string
  description = "Port Scan number"
}

variable "port_message" {
  type        = string
  description = "Port Scan message"
}