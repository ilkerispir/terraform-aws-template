resource "null_resource" "mock_resource" {
  provisioner "local-exec" {
    command = "echo ${var.app_name}-${var.environment}"
  }
}
