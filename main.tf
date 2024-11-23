provider "google" {
  project = "intranet-production-441303"
  region  = "us-central1"
  credentials = file("credentials.json")
}

resource "google_compute_instance" "vm-control-plane" {
  name         = "vm-control-plane"
  machine_type = "e2-small"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20241115"
      size  = 25
      type  = "pd-standard"
    }
  }

  network_interface {
    network = google_compute_network.vpc.self_link
    access_config {
      nat_ip       = google_compute_address.vm-control-plane-ip.address
      network_tier = "PREMIUM"
    }
  }

  tags = ["http-server", "https-server", "control-plane"]
}

resource "google_compute_instance" "vm-worker01" {
  name         = "vm-worker01"
  machine_type = "e2-small"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20241115"
      size  = 25
      type  = "pd-standard"
    }
  }

  network_interface {
    network = google_compute_network.vpc.self_link
    access_config {
      nat_ip       = google_compute_address.vm-worker01-ip.address
      network_tier = "PREMIUM"
    }
  }

  tags = ["http-server", "https-server", "worker"]
}

resource "google_compute_instance" "vm-worker02" {
  name         = "vm-worker02"
  machine_type = "e2-small"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20241115"
      size  = 25
      type  = "pd-standard"
    }
  }

  network_interface {
    network = google_compute_network.vpc.self_link
    access_config {
      nat_ip       = google_compute_address.vm-worker02-ip.address
      network_tier = "PREMIUM"
    }
  }

  tags = ["http-server", "https-server", "worker"]
}

resource "google_compute_instance" "vm-ansible" {
  name         = "vm-ansible"
  machine_type = "e2-small"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20241115"
      size  = 25
      type  = "pd-standard"
    }
  }

  network_interface {
    network = google_compute_network.vpc.self_link
    access_config {
      nat_ip       = google_compute_address.vm-ansible-ip.address
      network_tier = "PREMIUM"
    }
  }

  tags = ["http-server", "https-server"]
  
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      metadata,
    ]
  }
}

resource "google_compute_address" "vm-control-plane-ip" {
  name = "vm-control-plane-ip"
}

resource "google_compute_address" "vm-worker01-ip" {
  name = "vm-worker01-ip"
}

resource "google_compute_address" "vm-worker02-ip" {
  name = "vm-worker02-ip"
}

resource "google_compute_address" "vm-ansible-ip" {
  name = "vm-ansible-ip"
}

resource "google_compute_network" "vpc" {
  name                    = "vpc"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["http-server", "https-server", "control-plane", "worker"]
}

resource "google_compute_firewall" "allow-icmp" {
  name    = "allow-icmp"
  network = google_compute_network.vpc.self_link

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/8"] // permitir tráfego ICMP da rede interna

  target_tags = ["http-server", "https-server", "control-plane", "worker"]
}