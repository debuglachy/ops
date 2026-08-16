
provider var.provider {
	project = var.project_instance
	region = var.project_region
	zone = var.project_zone
}

resource var.provider_compute var.vm_instance {
	name = var.vm_instance
	machine_type = var.type
	zone = var.vm_zone
	boot_disk {
		initialize_params {
			image = var.vm_image
		}
	}
	network_interface {
		network = var.vm_net1
		subnetwork = var.vm_subnet1
		access_config {
			// Ephermal ip conf
		}
	}
	network_interface {
		network = var.vm_net2
		subnetwork = var.vm_subnet2
		access_config {
			// Ephermal
		}
	}
}

