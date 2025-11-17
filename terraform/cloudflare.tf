provider "cloudflare" {
    api_token = var.cloudflare_api_token
}

resource "cloudflare_dns_record" "wascaml_dns_record" {
    zone_id  = var.cloudflare_zone_id
    name     = "wascaml"
    type     = "CNAME"
    content  = "momeemt.github.io"
    ttl      = 1
    proxied  = false
    comment  = "https://github.com/momeemt/wascaml"
}