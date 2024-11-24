from flask import Flask, Blueprint, request, jsonify
from datetime import datetime
from geopy.distance import geodesic
import uuid
import urllib
import urllib.request
import csv
import io

events_blueprint = Blueprint('events', __name__)

DEFAULT_EVENT_PIC = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEJElEQVR4nO2azWsVVxiHnzQlqdgPESJosAsbsJssbBG6S1bdqhDRxjZtgoUuWt0p/gklZFG6bAWl7kRR3Anix8JUKLXFhXbRQguNkrSFasEWNZEDp3AZzty5M3PnzDuZ3wMHkpkz70zOM+frnYAQQgghhBBCxGdNBUttUPsDqCAha4ZfhNofQIXuQkRcMnuIiIuEGENCmi5Eky79XUVJCKZeKgmhfgkSQouEiHxIiDEkxBgSYgwJMYaEGENCjCEhxpAQY0iIMSSkIMPAEeBb4B9f3M+f+XNFkZACjAI/dMk/3fZ1iiAhORnOkNEppUhPkZCcHMmRqf00b3AJyc+tHEIWC8RXD8nJoxxCXN3WCJkB/gSWgP3YFPKwLUKOAasd93gK7CUOGrI6GAA+T3kbHwOTEYS4fYYmdWAQ+DqjMf4GdlUsZNgvaXtZ9g6t1yHLNcL5QOwngWMPgDGqZTRDyrreGL4CXEnpDZPAQuDcL8BWqmXI7zMW/UTvyk1/rEjPaISQzf4PTsZ0q6t3OuaVk4E6d/z1TcOskG2+UZPxfgV2BuaXc4G6TuZGmoVJIW/6hk/GugtsT7lmA3AjcM0l4EWagzkhbwPLgTjfASMZ174GfB+49gzwAs3AlJBJP1knY1wFXu0xxhbgp0CML2kGZoTs8Zu75PUXgZdy/lFvAPcDsY5jHxNCZlL2FKdLjP/jwF+JeC7dchjb1C7kaCIv9X/5wi9pyzAR6HUu7zWFXWoT4hp7PlB/1ScP+8VeL6HzHo+9rDJMAyvA78BBGi7E7Ru+CtR1Dfcx/eeDQC90i4e3CsabBZ4lXqJPmirE5aXOBur9V/F3jeOBey4HNpl5ZfRbSlQhLwOXA3Xcv9C8S/XMl8x7pcnop5RoQkb85i553o3Du4nDAHAq8Aw/Apsyrp0LyHiWcszVNS3kdeBe4NySX57GZLBA3ivUM9zvH6WcK9NTKhfi8lK/BY7/DOygHjYA13vMe6XJ+DCjTlEplQv5o2Beqmo2+aEq+WynOvY/oWHqqV+19TqkzVkTkizXcuSlqmZLl7zXbIoMl1VIox89JaqQCwXyUlUz5j/7Jp91NSDDbQazKNtTogn5xvB3ifFA3isp4/0c8cr0lChCFvqQl6qaCeDfwLO7pOeBAvGK9pTKhZygGcwFGvBJyexBESmVC2myjKmKYneT0nohsymrqV4m8CrmlFYLmU2RcSjSvUJSWitkOkLPKDJ8tVLIQCCDkLYDjy2ltUJWuuSm6pTSSiGOfV6K+0j1HvFJk9JaIRYISZGQmsn6CplEPaRmKUkkpObhK4mERKTVqyyrSIgxJMQYEmIMCWmbEBVKtYGEYOslkhDqlyAhrGMholokxBgSYgwJaZoQFeqd9CUAU21Q+wOoICFrhl8EIYQQQgghhCAmzwFP3jk+Vt9ergAAAABJRU5ErkJggg=="
event_list = {}  # Dictionary to store events
date_format = "%Y-%m-%d %H:%M:%S"
possible_interests = [
    'Bouldering', 'Hiking', 'Pub Crawls', 'Chess', 'Picnics',
    'Museums', 'Boat', 'Running', 'Board Games', 'Meet new people'
]

class Event:
    def __init__(self, event_title, event_description, event_picture, event_date, event_location, event_host, event_interests):
        self.id = str(uuid.uuid4()) # String
        self.title = event_title # String
        self.description = event_description # String
        self.picture = event_picture # Base64 String
        self.event_date = event_date # datetime
        self.create_date = datetime.now() # datetime
        self.location = event_location # double list
        self.host = event_host # String
        self.interests = event_interests # String list
        self.participants = {}  # dict with userID key


@events_blueprint.route('/create_event', methods=['POST'])
def create_event():
    try:
        data = request.get_json()

        # Set default values for attributes
        title = data.get('title', 'Untitled Event')
        description = data.get('description', 'No description provided')
        picture = data.get('picture', DEFAULT_EVENT_PIC)
        date = data.get('event_date', None)
        if (date):
            date = datetime.strptime(date, date_format)
        location = data.get('location', [])
        host = data.get('host', 'Anonymous')
        interests = data.get('interests', [])

        # Create a new Event object
        new_event = Event(title, description, picture, date, location, host, interests)

        # Add the event to the event_list dictionary
        event_list[new_event.id] = new_event

        # Return the event_id
        return jsonify({'event_id': new_event.id}), 201

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@events_blueprint.route('/update_event', methods=['PUT'])
def update_event():
    try:
        data = request.get_json()

        # Retrieve the event from the dictionary
        event = event_list.get(data.get('event_id', '0'))
        if not event:
            return jsonify({'error': 'Event not found'}), 404

        # Update the given attributes
        event.title = data.get('title', event.title)
        event.description = data.get('description', event.description)
        event.picture = data.get('picture', event.picture)
        event.location = data.get('location', event.location)
        if (data.get('event_date')):
            event.date = datetime.strptime(data.get('event_date'), date_format)
        event.host = data.get('host', event.host)
        event.interests = data.get('interests', event.interests)
        
        # Return the event_id
        return jsonify({'event_id': event.id}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@events_blueprint.route('/delete_event', methods=['DELETE'])
def delete_event():
    try:
        data = request.get_json()

        # Retrieve the event from the dictionary
        event_id = data.get('event_id', 0)
        if not event_list.get(event_id):
                    return jsonify({'error': 'Event not found'}), 404

        del event_list[event_id]
        return jsonify({'event_id': event_id}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@events_blueprint.route('/get_event_list', methods=['POST'])
def get_event_list():
    try:
        data = request.get_json()

        # Create filtered list
        filtered_list = {}
        filter_interests = data.get('filter_interests', possible_interests)
        '''filter_dates = data.get('filter_dates', None)
        if (filter_dates):
            filter_dates[0] = datetime.strptime(filter_dates[0], date_format)
            filter_dates[1] = datetime.strptime(filter_dates[1], date_format)
        filter_location = data.get('filter_location', None)
        filter_location_radius = data.get('filter_location_radius', 0)'''

        for event_id, event in event_list.items():
            if all(interest not in filter_interests for interest in event.interests):
                continue
            '''if filter_dates:
                if (event.event_date < filter_dates[0]) or (event.event_date > filter_dates[1]):
                    continue
            if (filter_location) and (filter_location_radius != 0):
                if geodesic((filter_location[0], filter_location[1]),(event.location[0], event.location[1])).kilometers > filter_location_radius:
                    continue'''
            filtered_list[event_id] = event
        
        
        # Convert events to a list of dictionaries for JSON serialization
        return jsonify({event_id: {
        'id': event.id,
        'title': event.title,
        'description': event.description,
        #'picture': event.picture,
        'event_date': event.event_date.strftime(date_format) if event.event_date else None,
        'create_date': event.create_date.strftime(date_format),
        'host': event.host,
        'location': event.location,
        'interests': event.interests,
        'participants': list(event.participants.keys())
        } for event_id, event in filtered_list.items()})
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@events_blueprint.route('/get_event', methods=['POST'])
def get_event():
    try:
        data = request.get_json()

        # Retrieve the event from the dictionary
        event = event_list.get(data.get('event_id', '0'))
        if not event:
            return jsonify({'error': 'Event not found'}), 404
        
        return jsonify({
        'id': event.id,
        'title': event.title,
        'description': event.description,
        'picture': event.picture,
        'event_date': event.event_date.strftime(date_format) if event.event_date else None,
        'create_date': event.create_date.strftime(date_format),
        'host': event.host,
        'interests': event.interests,
        'location': event.location,
        'participants': list(event.participants.keys())
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500
