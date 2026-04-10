resource "google_compute_address" "nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [google_project_service.api]
}

resource "google_compute_router" "router" {
    name    = "router"
    network = google_compute_network.vpc.id
    region  = local.region
}

resource "google_compute_router_nat" "nat" {
    name   = "nat"
    router = google_compute_router.router.name
    region = local.region

    nat_ip_allocate_option = "MANUAL_ONLY"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    nat_ips                = [ google_compute_address.nat.self_link ]

   

    subnetwork {
        name                    = google_compute_subnetwork.private.self_link
        source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }

} 