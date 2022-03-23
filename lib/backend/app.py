from distutils.log import debug
from flask import Flask, render_template
from flask_socketio import SocketIO, emit
from flask_cors import CORS, cross_origin

    
app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


    
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app)

@app.route('/')
def index():
    return "SOCKET IO SERVER"


@socketio.on('my event')
def handle_my_custom_event(json):
    print('received json: ' + str(json))
    
    
if __name__ == '__main__':
    print("starting socket IO server")
    socketio.run(app, debug= True)
    