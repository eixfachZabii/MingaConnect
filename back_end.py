from flask import Flask, request, jsonify
from datetime import datetime
import uuid

app = Flask(__name__)

event_list = []

class Event:

    def __init__(self, event_title, event_description, event_picture, event_date, event_location, event_host):
        self.id = str(uuid.uuid4())
        self.title = event_title
        self.description = event_description
        self.picture = event_picture
        self.event_date = event_date
        self.create_date = datetime.now()
        self.location = event_location
        self.host = event_host
        self.visitors = []

class User:

    def __init__(self, user_name, user_profilepic, user_dateofbirth, user_interests, user_email):
        self.id = str(uuid.uuid4())
        self.username = user_name
        self.profilepic = user_profilepic
        self.dateofbirth = user_dateofbirth
        self.interests = user_interests
        self.email = user_email

@app.route('/create_event', methods=['POST'])
def create_event():
    try:
        # Parse JSON data from the request
        data = request.get_json()

        # Set default values for attributes
        title = data.get('title', 'Untitled Event')
        description = data.get('description', 'No description provided')
        picture = data.get('picture', 'default-picture-url.jpg TODO')
        date = data.get('date', None)
        location = data.get('location', 'No location specified')
        host = data.get('host', 'Anonymous')

        # Create a new Event object
        new_event = Event(
            event_title=data['title'],
            event_description=data['description'],
            event_picture=data['picture'],
            event_date=data['date'],
            event_location=data['location'],
            event_host=data['host']
        )

        # Add the event to the event_list
        event_list.append(new_event)

        # Return the event_id
        return jsonify({'event_id': new_event.id}), 201

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/update_event', methods=['PUT'])
def update_event():
    try:
        # Parse JSON data from the request
        data = request.get_json()

        # Check if an id was given
        if 'event_id' not in data:
            return jsonify({'error': 'No event specified'}), 400
        else:
            for element in event_list:
                if element.id == data.get('event_id'):
                    event = element
                    break
        
        # Update the given attributes
        if 'title' in data:
            event.title = data.get('title')
        if 'description' in data:
            event.description = data.get('description')
        if 'picture' in data:
            event.picture = data.get('picture')
        if 'date' in data:
            event.event_date = data.get('date')
        if 'location' in data:
            event.location = data.get('location')
        if 'host' in data:
            event.host = data.get('host')

        # Return the event_id
        return jsonify({'event_id': event.id}), 201

    except Exception as e:
        return jsonify({'error': str(e)}), 500

#delete event


@app.route('/create_user', methods=['POST'])
def create_user():
    try:
        # Parse JSON data from the request
        data = request.get_json()

        # Set default values for attributes
        title = data.get('title', 'Untitled Event')
        description = data.get('description', 'No description provided')
        picture = data.get('picture', 'default-picture-url.jpg TODO')
        date = data.get('date', None)
        location = data.get('location', 'No location specified')
        host = data.get('host', 'Anonymous')

        # Create a new Event object
        new_event = Event(
            event_title=data['title'],
            event_description=data['description'],
            event_picture=data['picture'],
            event_date=data['date'],
            event_location=data['location'],
            event_host=data['host']
        )

        # Add the event to the event_list
        event_list.append(new_event)

        # Return the event_id
        return jsonify({'event_id': new_event.id}), 201

    except Exception as e:
        return jsonify({'error': str(e)}), 500

#update user