terraform {
  required_version = ">= 1.0"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.108"
    }
  }
}

provider "yandex" {
  service_account_key_file  = "key.json"
  # token                     = ""
  cloud_id                  = "xxx"
  folder_id                 = "xxx"
  zone                      = "ru-central1-a"
}