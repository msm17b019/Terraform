output "url" {
    value = join(":",["http://localhost",var.external_port])
}