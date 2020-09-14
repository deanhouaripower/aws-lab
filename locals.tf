locals {
  ingress_config = toset([80,22,443,52])
  ingress_config2 = [{port=80,description="http",protocol="tcp"},
    {port=22,description="ssh",protocol="tcp"},
    {port=443,description="ssl",protocol="tcp"},
    {port=53,description="dns",protocol="tcp"}]

}