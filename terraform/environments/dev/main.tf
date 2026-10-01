module "network" {
  source            = "../../modules/network"
  project_id        = var.project_id
  environment       = var.environment
  region            = var.region
  app_subnet_cidr   = var.app_subnet_cidr
  proxy_subnet_cidr = var.proxy_subnet_cidr
}

module "nat" {
  source = "../../modules/nat"

  project_id    = var.project_id
  environment   = var.environment
  region        = var.region
  network_id    = module.network.network_id
  app_subnet_id = module.network.app_subnet_id
}

module "firewall" {
  source = "../../modules/firewall"

  project_id        = var.project_id
  environment       = var.environment
  network_id        = module.network.network_id
  proxy_subnet_cidr = var.proxy_subnet_cidr

}

module "compute" {
  source = "../../modules/compute"

  project_id        = var.project_id
  environment       = var.environment
  region            = var.region
  app_subnet_id     = module.network.app_subnet_id
  os_image          = var.os_image
  boot_disk_size_gb = var.boot_disk_size_gb
  mig_zones         = var.mig_zones
}

module "load_balancer" {
  source = "../../modules/load-balancer"

  project_id     = var.project_id
  environment    = var.environment
  region         = var.region
  network_id     = module.network.network_id
  instance_group = module.compute.instance_group
}

module "project-services" {
  source      = "../../modules/project-services"
  environment = var.environment
  project_id  = var.project_id

}

module "dns" {
  source = "../../modules/dns"

  project_id       = var.project_id
  environment      = var.environment
  domain_name      = var.domain_name
  load_balancer_ip = module.load_balancer.load_balancer_ip
}
