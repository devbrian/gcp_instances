provider "google" {
 credentials = var.google_sa
 project     = "future-abacus-302701"
 region      = "us-east1"
}

resource "google_compute_instance" "example" {
  name          = "example"
  machine_type  = "f1-micro"
  zone          = "us-east1-b"
  
  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }
  
  network_interface {
    network = "open-network"

    access_config {
    }
  }
 
 metadata_startup_script = "scripts/startup.sh"
}

resource "google_compute_firewall" "default" {
  name    = "open-firewall"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["1-66666"]
  }

  source_tags = ["web"]
}

resource "google_compute_network" "default" {
  name = "open-network"
}
