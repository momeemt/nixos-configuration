locals {
  argocd = {
    domain         = "argocd.momee.mt"
    allowed_emails = ["me@momee.mt"]
  }
}

resource "cloudflare_zero_trust_access_application" "argocd" {
  zone_id              = local.cloudflare.zone_id
  name                 = "ArgoCD Dashboard"
  domain               = local.argocd.domain
  type                 = "self_hosted"
  session_duration     = "24h"
  app_launcher_visible = false
  policies = [{
    id         = cloudflare_zero_trust_access_policy.argocd_policy.id
    precedence = 1
  }]
}

resource "cloudflare_zero_trust_access_policy" "argocd_policy" {
  account_id       = local.cloudflare.account_id
  name             = "Allow ArgoCD admins policy"
  decision         = "allow"
  session_duration = "24h"
  include = [
    for email in local.argocd.allowed_emails : {
      email = {
        email = email
      }
    }
  ]
}

resource "random_id" "argocd_zero_trust_tunnel_secret" {
  byte_length = 35
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "argocd" {
  account_id    = local.cloudflare.account_id
  name          = "argocd"
  config_src    = "cloudflare"
  tunnel_secret = random_id.argocd_zero_trust_tunnel_secret.b64_std
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "argocd" {
  account_id = local.cloudflare.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.argocd.id
  source     = "cloudflare"
  config = {
    origin_request = {
      http2_origin  = true
      no_tls_verify = false
      tls_timeout   = 10
    }
    ingress = [
      {
        hostname = local.argocd.domain
        service  = "https://argocd-server.argocd.svc.cluster.local:443"
      },
      {
        service = "http_status:404"
      }
    ]
  }
}

resource "cloudflare_dns_record" "argocd_dns_record" {
  zone_id = local.cloudflare.zone_id
  name    = "argocd"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.argocd.id}.cfargotunnel.com"
  ttl     = 1
  proxied = true
  comment = "ArgoCD Dashboard"
}
