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
// Network Security Policy
resource "kubernetes_network_policy" "example" {
  metadata {
    name      = "terraform-example-network-policy"
    namespace = "soft-multitenancy-check"
  }

  spec {
    pod_selector {
      match_expressions {
        key      = "name"
        operator = "In"
        values   = ["webfront", "api"]
      }
    }

    ingress {
      ports {
        port     = "http"
        protocol = "TCP"
      }
      ports {
        port     = "8125"
        protocol = "UDP"
      }

      from {
        namespace_selector {
          match_labels = {
            name = "default"
          }
        }
      }

      from {
        ip_block {
          cidr = "10.0.0.0/24"
          except = [
            "10.0.4.0/24",
            "10.0.5.0/24",
            "10.0.6.0/24"
          ]
        }
      }
    }

    egress {} # single empty rule to allow all egress traffic

    policy_types = ["Ingress", "Egress"]
  }
}

// Pod Security Policy
resource "kubernetes_pod_security_policy" "example" {
  metadata {
    name = "terraform-example"
  }
  spec {
    privileged                 = false
    allow_privilege_escalation = false

    volumes = [
      "configMap",
      "emptyDir",
      "projected",
      "secret",
      "downwardAPI",
      "persistentVolumeClaim",
    ]

    run_as_user {
      rule = "MustRunAsNonRoot"
    }

    se_linux {
      rule = "RunAsAny"
    }

    supplemental_groups {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    fs_group {
      rule = "MustRunAs"
      range {
        min = 1
        max = 65535
      }
    }

    read_only_root_filesystem = true
  }
}

// END
