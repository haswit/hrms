from flask import *



app = Flask(__name__)
@app.route("/")
def home():
    return {"data" : "data"}


if __name__=="__main__":app.run()