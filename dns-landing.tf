/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# tfdoc:file:description Landing DNS zones and peerings setup.

# forwarding to on-prem DNS resolvers

moved {
  from = module.onprem-example-dns-forwarding
  to   = module.landing-dns-fwd-onprem-example
}

#module "landing-dns-fwd-onprem-example" {
#  source     = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/dns?ref=v25.0.0"
#  project_id = module.landing-project.project_id
#  name       = "example-com"
#  zone_config = {
#    domain = "onprem.example.com."
#    forwarding = {
#      client_networks = [module.landing-vpc.self_link]
#      forwarders      = { for ip in var.dns.onprem : ip => null }
#    }
#  }
#}

moved {
  from = module.reverse-10-dns-forwarding
  to   = module.landing-dns-fwd-onprem-rev-10
}

#module "landing-dns-fwd-onprem-rev-10" {
#  source     = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/dns?ref=v25.0.0"
#  project_id = module.landing-project.project_id
#  name       = "root-reverse-10"
#  zone_config = {
#    domain = "10.in-addr.arpa."
#    forwarding = {
#      client_networks = [module.landing-vpc.self_link]
#      forwarders      = { for ip in var.dns.onprem : ip => null }
#    }
#  }
#}

moved {
  from = module.gcp-example-dns-private-zone
  to   = module.landing-dns-priv-gcp
}

#module "landing-dns-priv-gcp" {
#  source     = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/dns?ref=v25.0.0"
#  project_id = module.landing-project.project_id
#  name       = "gcp-example-com"
#  zone_config = {
#    domain = "gcp.example.com."
#    private = {
#      client_networks = [module.landing-vpc.self_link]
#    }
#  }
#  recordsets = {
#    "A localhost" = { records = ["127.0.0.1"] }
#  }
#}

# Google APIs via response policies

module "landing-dns-policy-googleapis" {
  source     = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/dns-response-policy?ref=v25.0.0"
  project_id = module.landing-project.project_id
  name       = "googleapis"
  networks = {
    landing = module.landing-vpc.self_link
  }
  rules_file = var.factories_config.dns_policy_rules_file
}

# davidcharbonnier.fr public zone

module "davidcharbonnier-dns-public-zone" {
  source          = "git@github.com:GoogleCloudPlatform/cloud-foundation-fabric.git//modules/dns?ref=v25.0.0"
  project_id      = module.landing-project.project_id
  name            = "davidcharbonnier-fr"
  zone_config = {
    domain = "davidcharbonnier.fr."
    public = {
      dnssec_config = {
        state = "on"
      }
    }
  }
  recordsets = {
    # Gmail
    "MX "                   = { ttl = 3600, records = ["5 alt2.aspmx.l.google.com.", "10 alt4.aspmx.l.google.com.", "10 alt3.aspmx.l.google.com.", "5 alt1.aspmx.l.google.com.", "1 aspmx.l.google.com."] }
    "SPF "                  = { ttl = 0, records = ["\"v=spf1 include:_spf.google.com ~all\""] }
    "TXT google._domainkey" = { ttl = 0, records = ["\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwkn0FEXhDrJO6OdDnCeN6jZbZZlKpxOIqsS5qABeihxCyWjqRqpS1Aslr4dyNudVn4r5xoVYt/eGURSnwFurJYDdPXj4lGf19dMugP3qCXQQT/yqOlJzf0N+YCiAGr5ZdB2BXhimacZwfAebfnQWpyoNntQpRtWmTXRP0d29S/FzWxZTYHBAMP07nhXWShg98\" \"8O4C8/ET6/9zEUF/QeJFiMAxew2Cpwc97LApeG5wr7qe+Vqt/q+IG+WQVD0klygcxD6zWOwHtviqocQgleCY64CyrgHX8GE4krs/on7o5bC22Nie2OggywVUxczQvxTzOO2EDzRhvXzghuhT3k25QIDAQAB\""] }
    # Netlify
    "A "        = { ttl = 0, records = ["75.2.60.5"] }
    "CNAME www" = { ttl = 0, records = ["davidcharbonnier.netlify.app."] }
    # Letencrypt
    "CAA " = { ttl = 0, records = ["0 iodef \"mailto:contact@davidcharbonnier.fr\"", "0 issue \"letsencrypt.org\""] }
    # Google Workspace
    "TXT " = { ttl = 0, records = ["google-site-verification=ufzEd-TjmFzEHsejF-PB0PIVwwlCTFiqP7JOyVx4u9s"] }
  }
}
