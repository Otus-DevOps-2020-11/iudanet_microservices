provider "cloudflare" {
  version   = "~> 2.0"
  api_token = var.cloudflare_api_token
}


resource "cloudflare_record" "gitlab" {
  zone_id = var.cloudflare_zone_id
  name    = "gitlab.otus"
  value   = "${yandex_compute_instance.gitlab-ci.network_interface.0.nat_ip_address}"
  type    = "A"
}

resource "cloudflare_record" "review" {
  zone_id = var.cloudflare_zone_id
  name    = "*.review.otus"
  value   = "${yandex_compute_instance.gitlab-ci.network_interface.0.nat_ip_address}"
  type    = "A"
}
