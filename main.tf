// Start - Soft-multi-tenancy
resource "kubernetes_namespace" "example" {
  metadata {
    annotations = {
      name = "soft-multitenancy-check"
    }
    labels = {
      mylabel = "soft-multitenancy-check"
    }
    name = "soft-multitenancy-check"
  }
}

resource "kubernetes_limit_range" "example" {
  metadata {
    name      = "pfx-limit-range"
    namespace = "soft-multitenancy-check"
  }
  spec {
    limit {
      type = "Pod"
      max = {
        cpu    = "800m"
        memory = "256M"
      }
    }
    limit {
      type = "PersistentVolumeClaim"
      min = {
        storage = "24M"
      }
    }
    limit {
      type = "Container"
      default = {
        cpu    = "200m"
        memory = "256M"
      }
    }
  }
}
// END
