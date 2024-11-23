from flask import Flask, request, jsonify
from datetime import datetime
import uuid

app = Flask(__name__)

event_list = []
user_list = []
possible_intersts = [
    'Bouldering',
    'Hiking',
    'Pub Crawls',
    'Chess',
    'Picnics',
    'Museums', 
    'Boccia',
    'Running',
    'Board Games'
]

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
        self.events = []

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
        new_event = Event(title, description, picture, date, location, host)

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
    
@app.route('/delete_event', methods=['DELETE'])
def delete_event():
    try:
        # Parse JSON data from the request
        data = request.get_json()
        
        for event in event_list:
            if event.id == data.get('event_id'):
                event_list.remove(event)
                return jsonify({'event_id': event.id}), 200
        return jsonify({'error': 'Event not found'}), 404
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    

@app.route('/create_user', methods=['POST'])
def create_user():
    try:
        # Parse JSON data from the request
        data = request.get_json()

        # Set default values for attributes
        name = data.get('name', 'Anonymous')
        profilepic = data.get('profilepic', 'default-picture-url.jpg TODO')
        dateofbirth = data.get('dateofbirth', None)
        interests = data.get('interests', [])
        email = data.get('email', 'No email specified')

        # Create a new Event object
        new_user = User(name, profilepic, dateofbirth, interests, email)

        # Add the event to the event_list
        user_list.append(new_user)

        # Return the user_id
        return jsonify({'user_id': new_user.id}), 201

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/update_user', methods=['PUT'])
def update_user():
    try:
        # Parse JSON data from the request
        data = request.get_json()

        # Check if an id was given
        if 'user_id' not in data:
            return jsonify({'error': 'No user specified'}), 400
        else:
            for element in user_list:
                if element.id == data.get('user_iid'):
                    user = element
                    break
        
        # Update the given attributes
        user.name = data.get('name', user.name)
        user.profilepic = data.get('profilepic', user.profilepic)
        user.date = data.get('date', user.date)
        user.location = data.get('location', user.location)
        user.host = data.get('host', user.host)
        user.interests = data.get('interests', user.interests)
        user.email = data.get('email', user.email)

        # Return the user_id
        return jsonify({'user_id': user.id}), 201

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/delete_user', methods=['DELETE'])
def delete_user():
    try:
        # Parse JSON data from the request
        data = request.get_json()
        
        for user in user_list:
            if user.id == data.get('user_id'):
                user_list.remove(user)
                return jsonify({'user_id': user.id}), 200
        return jsonify({'error': 'User not found'}), 404
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@app.route('/join_event', methods=['POST'])
def join_event():
    try:
        data = request.get_json()
        for user in user_list:
            if user.id == data.get('user_id'):
            
                for event in event_list:
                    if event.id == data.get('event_id'):
                        
                        if event.id in user.events or user.id in event.participants:
                            return jsonify({'error': 'User already joined the event'}), 409
                        else:
                            user.event.append(event.id)
                            event.participants.append(user.id)
                            return jsonify({'event_id': event.id,'participants': event.participants}), 200
                return jsonify({'error': 'Event not found'}), 404
        return jsonify({'error': 'User not found'}), 404

    except Exception as e:
        return jsonify({'error': str(e)}), 500

    
@app.route('/get_interests', methods=['GET'])
def get_interests():
    return jsonify(possible_intersts)

print('Success')