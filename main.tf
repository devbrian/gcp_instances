resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = "instance-group-manager"
  zone               = "us-east1-b"
  version {
    instance_template  = google_compute_instance_template.feeder_template.id
  }
  
  base_instance_name = "instance-group-manager"
  target_size        = "2"
}

data "template_file" "nzbget_template" {
  template = file("files/nzbget.conf")
  vars = {
    user = var.user
    pass = var.pass
    s1user = var.s1user
    s1pass = var.s1pass
  }
}

data "template_file" "rclone_template" {
  template = file("files/rclone.conf")
  vars = {
    rclone_file = var.rclone_file
  }
}

provider "google" {
 credentials = var.google_sa
 project     = var.google_project
 region      = "us-east1"
}

resource "google_compute_instance_template" "feeder_template" {
  name_prefix  = "feeder-"
  machine_type  = "n2-standard-4"

  disk {
    source_image = "ubuntu-1804-lts"
    auto_delete  = true
    boot         = true
    disk_size_gb = 100
  }
  
  disk {
    type = "SCRATCH"
    interface = "NVME"
  }
  
  
  network_interface {
    network = "open-network"

    access_config {
    }
  }

  metadata_startup_script = file("files/startup.sh")
 
  metadata = {
    ssh-keys = "root:${var.publickey}"
  }
 
  provisioner "file" {
        content = data.template_file.nzbget_template.rendered
        destination = "/tmp/nzbget.conf"
        connection {
            type = "ssh"
            user = "root"
            private_key = var.privatekey
        }
   }
  
   provisioner "file" {
        source = "files/services/nzbget.service"
        destination = "/etc/systemd/system/nzbget.service"
        connection {
            type = "ssh"
            user = "root"
            private_key = var.privatekey
        }
   }
  
   provisioner "file" {
        source = "files/services/cloudplow.service"
        destination = "/etc/systemd/system/cloudplow.service"
        connection {
            type = "ssh"
            user = "root"
            private_key = var.privatekey
        }
   }
  
   provisioner "file" {
        source = "files/config.json"
        destination = "/tmp/config.json"
        connection {
            type = "ssh"
            user = "root"
            private_key = var.privatekey
        }
   }
  
   provisioner "file" {
        content = data.template_file.rclone_template.rendered
        destination = "/tmp/rclone.conf"
        connection {
            type = "ssh"
            user = "root"
            private_key = var.privatekey
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
  
  depends_on = [google_compute_network.default]
}

resource "google_compute_network" "default" {
  name = "open-network"
}
