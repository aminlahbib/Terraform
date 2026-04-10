#Bucket to store website files
resource "google_storage_bucket" "website" {
    provider = google
    name     = "example-website-bucket-terraform-demo"
    location = var.gcp_region
}

#Make object public
resource "google_storage_object_access_control" "public_rule" {
    object   = google_storage_bucket_object.static_site_src.name
    bucket   = google_storage_bucket.website.name
    role     = "READER"
    entity   = "allUsers"
}

#upload index.html
resource "google_storage_bucket_object" "static_site_src" {
    name     = "index.html"
    source   = "../website/index.html"
    bucket   = google_storage_bucket.website.name
}

#Reserve a static IP address
resource "google_compute_global_address" "website_ip" {
    name = "website-lb-ip"
}

#Get the managed DNS zone
data "google_dns_managed_zone" "dns_zone" {
    name = var.dns_zone_name
}

# Add the ip address to the DNS zone
resource "google_dns_record_set" "website_dns" {
    name         = "website.${data.google_dns_managed_zone.dns_zone.dns_name}"
    type         = "A"
    ttl          = 300
    managed_zone = data.google_dns_managed_zone.dns_zone.name
    rrdatas      = [google_compute_global_address.website_ip.address]
}

# Add the bucket as a CDN backend
resource "google_compute_backend_bucket" "website_backend" {
    name        = "website-backend"
    bucket_name = google_storage_bucket.website.name
    description  = "Backend bucket for website"
    enable_cdn = true
}

# GCP URL map
resource "google_compute_url_map" "website" {
    name            = "website-url-map"
    default_service = google_compute_backend_bucket.website_backend.self_link
    host_rule {
        hosts        = ["*"]
        path_matcher = "allpaths"
    }
    path_matcher {
        name            = "allpaths"
        default_service = google_compute_backend_bucket.website_backend.self_link
    }
}

# GCP Target HTTP Proxy
resource "google_compute_target_http_proxy" "website" {
    name    = "website-http-proxy"
    url_map = google_compute_url_map.website.self_link
}

# GCP Global Forwarding Rule
resource "google_compute_global_forwarding_rule" "default" {
    name       = "website-forwarding-rule"
    load_balancing_scheme = "EXTERNAL"
    ip_address = google_compute_global_address.website_ip.address
    ip_protocol = "TCP"
    port_range = "80"
    target     = google_compute_target_http_proxy.website.self_link
}