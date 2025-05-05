#psa_ranges = {
#  dev = [
#    {
#      ranges = {
#        cloudsql-mysql      = "10.68.1.0/24"
#        cloudsql-sqlserver  = "10.68.2.0/24"
#        cloudsql-postgresql = "10.68.3.0/24"
#      }
#    }
#  ]
#  prod = [
#    {
#      ranges = {
#        cloudsql-mysql      = "10.72.1.0/24"
#        cloudsql-sqlserver  = "10.72.2.0/24"
#        cloudsql-postgresql = "10.72.3.0/24"
#      }
#    }
#  ]
#}

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