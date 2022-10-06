variable "credentials_file" { 
  default = "../secrets/cis-91.key" 
}

variable "project" {
  default = "rodriguez-364418"
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-c"
}


terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file("/home/kyr4142/rodriguez-364418-f0b1d1a65e7c.json")

  project = "rodriguez-364418"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

resource "google_compute_firewall" "default-firewall" {
  name = "default-firewall"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

output "ip" {
  value = google_compute_instance.vm_instance.network_interface.0.network_ip
}
