provider "google" {
 credentials = var.google_sa
 project     = var.google_project
 region      = "us-east1"
}

resource "google_compute_instance" "instance1" {
  name          = "instance1"
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

  metadata_startup_script = file("files/startup.sh")
 
  metadata = {
    ssh-keys = "root:${file(var.publickey)}"
  }
 
  provisioner "file" {
        source = "files/nzbget.conf"
        destination = "/tmp/nzbget.conf"
        connection {
            type = "ssh"
            host = "${google_compute_instance.instance1.network_interface.0.access_config.0.nat_ip}"
            user = "root"
            private_key = "${file(var.privatekey)}"
        }
   }
}

resource "google_compute_firewall" "default" {
  name    = "open-firewall"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_network" "default" {
  name = "open-network"
}
