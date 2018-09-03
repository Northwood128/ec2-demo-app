from flask import Flask, render_template
import urllib.request
from urllib.error import HTTPError

EC2DemoApp = Flask(__name__)

@EC2DemoApp.route("/")
def hello():
    try:
        with urllib.request.urlopen('http://169.254.169.254/latest/meta-data/instance-id') as response:
        #with urllib.request.urlopen('http://httpbin.org/status/418') as response:
            instance_id = response.read()
    except HTTPError as e:
        instance_id = "Teapot"

    return render_template('index.html', instance_id=instance_id)

if __name__ == "__main__":
    EC2DemoApp.run(host='0.0.0.0')