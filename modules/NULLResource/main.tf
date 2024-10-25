resource "null_resource" "certs" {
  provisioner "local-exec" {
    command = "./${path.module}/certs/script.sh Dev Propel"
    interpreter = ["bash", "-c"]
  }
}