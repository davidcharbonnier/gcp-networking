dns = {}

psa_ranges = {
  dev = {
    ranges = {
      cloudsql-mysql      = "10.128.62.0/24"
      cloudsql-sqlserver  = "10.128.63.0/24"
      cloudsql-postgresql = "10.128.64.0/24"
    }
    routes = null
  }
  prod = {
    ranges = {
      cloudsql-mysql      = "10.128.94.0/24"
      cloudsql-sqlserver  = "10.128.95.0/24"
      cloudsql-postgresql = "10.128.96.0/24"
    }
    routes = null
  }
}

regions = {
  primary   = "northamerica-northeast1"
  secondary = "northamerica-northeast2"
}

serverless_connector_config = {
  dev-primary = {
    machine_type = "f1-micro"
    instances = {
      max = 3
      min = 2
    }
  }
  prod-primary = null
}