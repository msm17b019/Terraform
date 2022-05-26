# Pulls the image
resource "docker_image" "nginx" {
  name = "nginx"
}

# Create a container
resource "docker_container" "nginx-container" {
  image = docker_image.nginx.latest
  name  = "nginx"
  ports {
    internal = 80
    external = 8080
    protocol = "tcp"
  }
}