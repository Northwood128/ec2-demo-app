#!/usr/bin/env bash
# Enable EPEL repo
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum makecache fast
sudo yum update -y

# Install the necessary packages
yum install -y git python3-pip python36 python36-devel gcc nginx

# Upgrade Pip
/usr/local/bin/pip3 install --upgrade pipenv

# Install Pipenv
/usr/local/bin/pip3 install pipenv

# Download the code from GitHub and install dependencies
git clone https://github.com/Northwood128/ec2-demo-app.git /opt/EC2DemoApp

cd /opt/EC2DemoApp
# https://pipenv.readthedocs.io/en/latest/advanced/#custom-virtual-environment-location
export PIPENV_VENV_IN_PROJECT=true
pipenv install

# Move Nginx configuration
mv nginx.conf /etc/nginx.conf
# Move SystemD Unit file
mv demoapp.service /etc/systemd/system/demoapp.service

# Setup right permissions on the directory
chmod 710 /opt/EC2DemoApp

# Create a service user to run the app
adduser demo-user

# Add the Nginx user to the service user's group, to allow it to access the app
sudo usermod -a -G demo-user nginx
/usr/sbin/nginx -t

# Start Gunicorn
systemctl start demoapp
systemctl enable demoapp

# Start Nginx
systemctl start nginx
systemctl enable nginx