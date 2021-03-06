#!/usr/bin/env bash
# Enable EPEL repo
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum makecache fast
sudo yum update -y

# Install the necessary packages
yum install -y git python3-pip python36 python36-devel gcc nginx

# Upgrade Pip
/bin/pip3 install --upgrade pip

# Install Pipenv
/usr/local/bin/pip3 install pipenv

# Download the code from GitHub and install dependencies
git clone https://github.com/Northwood128/ec2-demo-app.git /opt/EC2DemoApp
cd /opt/EC2DemoApp
# https://pipenv.readthedocs.io/en/latest/advanced/#custom-virtual-environment-location
export PIPENV_VENV_IN_PROJECT=true
/usr/local/bin/pipenv install

# Move Nginx configuration
mv nginx.conf /etc/nginx/nginx.conf
# Move SystemD Unit file
mv demoapp.service /etc/systemd/system/demoapp.service

# Create a service user to run the app and grant him sudo access
adduser demo-user
gpasswd -a demo-user wheel

# Setup right permissions on the directory
chmod 710 /opt/EC2DemoApp
chown -R demo-user:demo-user /opt/EC2DemoApp


# Add the Nginx user to the service user's group, to allow it to access the app
sudo usermod -a -G demo-user nginx
/usr/sbin/nginx -t

# Start Gunicorn
systemctl start demoapp
systemctl enable demoapp

# Start Nginx
systemctl start nginx
systemctl enable nginx