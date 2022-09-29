//generate SSH private key using the tls_private_key resource
resource "tls_private_key" "ioana-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 2048

provisioner "local-exec" {
  command     = <<EOT
    '${tls_private_key.ioana-ssh-key.private_key_pem}' | % {$_ -replace "`r", ""} | Set-Content -NoNewline ./'${var.keyname}.pem' -Force
    chmod 400 ./'${var.keyname}'.pem
	EOT
  interpreter = ["PowerShell", "-Command"]
  	}
}

resource "aws_key_pair" "ioana-generated-key" {
  key_name   = var.keyname
  public_key = tls_private_key.ioana-ssh-key.public_key_openssh
}