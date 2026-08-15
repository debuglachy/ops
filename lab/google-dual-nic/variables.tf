
variable "cloud_provider" {
	type		=	string
	description	=	"all variable settings match to google cloud platform by default"
	default		=	"google"
}

variable "provider_compute" {
	type		=	string
	description	=	"compute resource of the chosen provider"
	default		=	"google_compute_instance"
}

variable "project_instance" {
	type		=	string
	description	=	"project to use"
}

variable "project_region" {
	type		=	string
	description	=	"region setting"
	default		=	"us-central1"
}

variable "project_zone" {
	type		=	string
	description	=	"zone setting"
	default		=	"us-central1-a"
}

variable "vm_region" {
	type		=	string
	description	=	"region setting"
	default		=	"us-central1"
}

variable "vm_zone" {
	type		=	string
	description	=	"zone setting"
	default		=	"us-central1-a"
}

variable "vm_instance" {
	type		=	string
	description	=	"name of the machine"
}

variable "vm_type" {
	type		=	string
	description	=	"size and flavour of machine"
	default		=	"e2-medium"
}

variable "vm_image" {
	type		=	string
	description	=	"image of machine"
	default		=	"centos-cloud/centos-stream-9"
}

variable "vm_net1" {
	type		=	string
	description	=	"vpc network name"
}

variable "vm_subnet1" {
	type		=	string
	description	=	"vpc subnet name"
}

variable "vm_net2" {
	type		=	string
	description	=	"vpc network name"
}

variable "vm_subnet2" {
	type		=	string
	description	=	"vpc subnet name"
}

