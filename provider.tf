provider "aws" {
  region = var.region
}


provider "google" {
  region = "us-east4"
  zone = "us-east4-a"
  #credentials = file("~/terraform-5e2746cbd236.json")
  project = "terraform-287403"
}