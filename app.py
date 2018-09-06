from flask import Flask, render_template
import urllib.request

EC2DemoApp = Flask(__name__)

@EC2DemoApp.route("/")
def hello():
    with urllib.request.urlopen('http://169.254.169.254/latest/meta-data/instance-id') as response:
        instance_id = response.read()

    return render_template('index.html', instance_id=str(instance_id))

if __name__ == "__main__":
    EC2DemoApp.run(host='0.0.0.0')
