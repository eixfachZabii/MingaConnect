from flask import Flask, Blueprint, request, jsonify
from datetime import datetime
import uuid
import urllib
import urllib.request
import csv
import io
import Users
import Events

app = Flask(__name__)
app.register_blueprint(Users.users_blueprint, url_prefix='/')
app.register_blueprint(Events.events_blueprint, url_prefix='/')

possible_interests = [
    'Bouldering', 'Hiking', 'Pub Crawls', 'Chess', 'Picnics',
    'Museums', 'Boccia', 'Running', 'Board Games', 'Meet new people'
]

@app.route('/join_event', methods=['POST'])
def join_event():
    try:
        data = request.get_json()

        # Retrieve user and event from dictionaries
        user = Users.user_list.get(data.get('user_id', '0'))
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        event = Events.event_list.get(data.get('event_id', '0'))
        if not event:
            return jsonify({'error': 'Event not found'}), 404

        # Check if user is already participating
        if event.id in user.events or user.id in event.participants:
            return jsonify({'error': 'User already joined the event'}), 409

        # Add event to user's events and user to event's participants
        user.events[event.id] = event
        event.participants[user.id] = user

        return jsonify({
            'event_id': event.id,
            'participants': list(event.participants.keys())
        }), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/leave_event', methods=['DELETE'])
def leave_event():
    try:
        data = request.get_json()

        # Retrieve user and event from dictionaries
        user = Users.user_list.get(data.get('user_id', '0'))
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        event = Events.event_list.get(data.get('event_id', '0'))
        if not event:
            return jsonify({'error': 'Event not found'}), 404

        # Check if user is participating
        if event.id not in user.events or user.id not in event.participants:
            return jsonify({'error': 'User was not a participant'}), 400

        # Remove event from user's events and user from event's participants
        del user.events[event.id]
        del event.participants[user.id]

        return jsonify({'message': 'User successfully left the event'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/get_possible_interests', methods=['GET'])
def get_possible_interests():
    return jsonify(possible_interests)


def add_baenke():
    try:
        url = 'URL: https://opendata.muenchen.de/dataset/5623e119-9a3c-420b-8925-af53bc57c5cd/resource/b000b282-c52f-44eb-a97e-851a4b999aa0/download/ratschbankerl_2024-11-13_standorte.csv'  
        fileobj = (urllib.request.urlopen(url)).read()
        csv_file = io.StringIO(fileobj.decode())
        csv_reader = csv.reader(csv_file)
        headers = next(csv_reader)
        locations = []
        for row in csv_reader:
            latitude = float(row[5])
            longitude = float(row[6])
            locations.append([latitude, longitude])


        title = 'Ratschbankerl'
        description = 'Ratschbankerl description'
        picture = 'Ratschbankerl picture'
        date = None
        host = 'stadt_muenchen'
        interests = ['Meet new people']
        baenke = Events.Event(title, description, picture, date, locations, host, interests)
        Events.event_list[baenke.id] = baenke

        return baenke.id

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
if __name__ == '__main__':
    user_stadt_muenchen = Users.User('Stadt München', "pic", None, [], None)
    user_stadt_muenchen.set_id('stadt_muenchen')
    Users.user_list[user_stadt_muenchen.id] = user_stadt_muenchen

    dummy = Events.Event("title", "description", "pic", datetime.now(), [[48.29816, 11.70607]], "None", ["Bouldering"])
    Events.event_list[dummy.id] = dummy
    add_baenke()

    app.run(host='0.0.0.0', debug=True)
    