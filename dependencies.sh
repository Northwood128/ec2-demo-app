#!/usr/bin/env bash
# Enable EPEL repo
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install the necessary packages
yum install -y git python-pip python36 python36-devel gcc nginx

# Upgrade Pip
pip install --upgrade pipenv

# Install Pipenv
pip install pipenv

# Download the code from GitHub
git clone git@github.com:Northwood128/ec2-demo-app.git

# Install app
export PIPENV_VENV_IN_PROJECT=true

# Create a service user to run the app
adduser demo-user

# Add the Nginx user to the service user, to allow it to access the app
sudo usermod -a -G demo-user nginx
chmod 710 /opt/EC2DemoApp
nginx -t

systemctl start ec2demoapp
systemctl enable ec2demoapp
systemctl start nginx
systemctl enable nginx