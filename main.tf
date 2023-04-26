terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}


provider "docker" {
  host = "ssh://remote-host"   #remote-host need be change to your host where you want to deploy docker containers 
}

resource "docker_volume" "my_volume" {
  name = "my_volume"
  driver = "local"
  driver_opts = {
      "type"    = "none"
      "device"  = "/mnt/data/my_volume"
      "o"       = "bind"
    }
}


resource "docker_container" "my_container" {
  name  = "my_container"
  image = "nginx:latest"
  ports {
    internal = 80
    external = 8080
  }
  volumes {
    container_path = "/usr/share/nginx/html"
    host_path      = docker_volume.my_volume.driver_opts.device
    read_only      = false
  }
}

