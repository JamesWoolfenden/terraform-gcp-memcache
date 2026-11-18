variable "name" {
  type        = string
  description = "Name of the Memorystore for Memcached instance"

  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]{0,38}[a-z0-9])?$", var.name))
    error_message = "var.name must be 1-40 characters of lowercase letters, numbers and hyphens, starting with a letter"
  }
}

variable "region" {
  type        = string
  description = "Region for the instance"

  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "var.region must be a non-empty string"
  }
}

variable "display_name" {
  type        = string
  description = "Human-readable display name. Null to use the name"
  default     = null

  validation {
    condition     = var.display_name == null || length(trimspace(coalesce(var.display_name, " "))) > 0
    error_message = "var.display_name must be null or a non-empty string"
  }
}

variable "authorized_network" {
  type        = string
  description = "Full name of the VPC network (projects/P/global/networks/N) the instance is attached to via private service access. The network must already have a private service connection to servicenetworking.googleapis.com"

  validation {
    condition     = can(regex("^projects/[^/]+/global/networks/[^/]+$", var.authorized_network))
    error_message = "var.authorized_network must be a network name in the form projects/P/global/networks/N (not the implicit default network)"
  }

  validation {
    condition     = !can(regex("/networks/default$", var.authorized_network))
    error_message = "var.authorized_network must not be the default network"
  }
}

variable "reserved_ip_range_id" {
  type        = list(string)
  description = "Names of allocated private service access ranges to place the instance in. Empty to let Google pick from the network's allocated ranges"
  default     = []

  validation {
    condition     = alltrue([for r in var.reserved_ip_range_id : length(trimspace(r)) > 0])
    error_message = "var.reserved_ip_range_id entries must be non-empty strings"
  }
}

variable "zones" {
  type        = list(string)
  description = "Zones to spread nodes across. Empty to let Google spread them across all zones in the region"
  default     = []

  validation {
    condition     = alltrue([for z in var.zones : can(regex("^[a-z]+-[a-z]+[0-9]+-[a-z]$", z))])
    error_message = "var.zones entries must be zone names such as europe-west2-a"
  }
}

variable "node_count" {
  type        = number
  description = "Number of nodes in the instance"
  default     = 2

  validation {
    condition     = var.node_count >= 1 && var.node_count <= 20 && floor(var.node_count) == var.node_count
    error_message = "var.node_count must be a whole number between 1 and 20"
  }
}

variable "cpu_count" {
  type        = number
  description = "vCPUs per node"
  default     = 1

  validation {
    condition     = var.cpu_count >= 1 && floor(var.cpu_count) == var.cpu_count
    error_message = "var.cpu_count must be a whole number of at least 1"
  }
}

variable "memory_size_mb" {
  type        = number
  description = "Memory per node in MiB (1024-307200)"
  default     = 1024

  validation {
    condition     = var.memory_size_mb >= 1024 && var.memory_size_mb <= 307200
    error_message = "var.memory_size_mb must be between 1024 and 307200"
  }
}

variable "memcache_version" {
  type        = string
  description = "Memcached major version to pin to, so upgrades happen deliberately"
  default     = "MEMCACHE_1_6_15"

  validation {
    condition     = contains(["MEMCACHE_1_5", "MEMCACHE_1_6_15"], var.memcache_version)
    error_message = "var.memcache_version must be MEMCACHE_1_5 or MEMCACHE_1_6_15"
  }
}

variable "memcache_parameters" {
  type        = map(string)
  description = "Memcached configuration parameters (e.g. listen-backlog, max-item-size)"
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.memcache_parameters : length(trimspace(k)) > 0])
    error_message = "var.memcache_parameters keys must be non-empty strings"
  }
}

variable "maintenance_window" {
  type = object({
    day        = optional(string, "SUNDAY")
    start_hour = optional(number, 2)
    duration   = optional(string, "10800s")
  })
  description = "Weekly maintenance window (UTC) so Google-initiated updates happen at a predictable, low-traffic time"
  default     = {}

  validation {
    condition     = contains(["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"], var.maintenance_window.day)
    error_message = "var.maintenance_window.day must be a day of the week in upper case"
  }

  validation {
    condition     = var.maintenance_window.start_hour >= 0 && var.maintenance_window.start_hour <= 23
    error_message = "var.maintenance_window.start_hour must be between 0 and 23"
  }

  validation {
    condition     = can(regex("^[0-9]+s$", var.maintenance_window.duration))
    error_message = "var.maintenance_window.duration must be a duration string like \"10800s\""
  }
}

variable "deletion_protection" {
  type        = bool
  description = "Prevent Terraform from destroying the instance"
  default     = true

  validation {
    condition     = var.deletion_protection != null
    error_message = "var.deletion_protection must be true or false"
  }
}

variable "labels" {
  type        = map(string)
  description = "Labels applied to the instance for cost allocation and ownership tracking"
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.labels : can(regex("^[a-z0-9_-]{1,63}$", k)) && can(regex("^[a-z0-9_-]{0,63}$", v))])
    error_message = "var.labels keys and values must be lowercase letters, numbers, underscores, or dashes (GCP label constraints)"
  }
}
