user_data = <<-EOF
#!/bin/bash
sudo yum -y update
sudo yum install -y httpd
sudo service httpd start
echo '<!doctype html><html><head><title>CONGRATULATIONS!!..You are on your way to become a Terraform expert!</title><style>body {background-color: #1c87c9;}</style></head><body></body></html>' | sudo tee /var/www/html/index.html
echo "<BR><BR>Terraform autoscaled app multi-cloud lab<BR><BR>" >> /var/www/html/index.html
EOF

az = "us-east-2b"
region = "us-east-2"


