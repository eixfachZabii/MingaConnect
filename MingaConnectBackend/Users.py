from flask import Flask, Blueprint, request, jsonify
from datetime import datetime
import uuid
import urllib
import urllib.request
import csv
import io

users_blueprint = Blueprint('users', __name__)

DEFAULT_PROFILE_PIC = "data:image/png;base64,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"
user_list = {}  # Dictionary to store users

class User:
    def __init__(self, user_name, user_profile_pic, user_date_of_birth, user_interests, user_email):
        self.id = str(uuid.uuid4()) # String
        self.username = user_name # String
        self.profile_pic = user_profile_pic # Base64 String
        self.date_of_birth = user_date_of_birth # String (xx.xx.xxxx)
        self.interests = user_interests # String list
        self.email = user_email # String
        self.events = {}  # Dict with userID key
    def set_id(self, id):
        self.id = id


@users_blueprint.route('/create_user', methods=['POST'])
def create_user():
    try:
        data = request.get_json()

        # Set default values for attributes
        name = data.get('name', 'Anonymous')
        profile_pic = data.get('profile_pic', DEFAULT_PROFILE_PIC)
        date_of_birth = data.get('date_of_birth', None)
        interests = data.get('interests', [])
        email = data.get('email', 'No email specified')

        # Create a new User object
        new_user = User(name, profile_pic, date_of_birth, interests, email)

        # Add the user to the user_list dictionary
        user_list[new_user.id] = new_user

        # Return the user_id
        return jsonify({'user_id': new_user.id}), 201
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@users_blueprint.route('/update_user', methods=['PUT'])
def update_user():
    try:
        data = request.get_json()

        # Retrieve the user from the dictionary
        user = user_list.get(data.get('user_id', '0'))
        if not user:
            return jsonify({'error': 'User not found'}), 404

        # Update the given attributes
        user.username = data.get('name', user.username)
        user.profile_pic = data.get('profile_pic', user.profile_pic)
        user.date_of_birth = data.get('date', user.date_of_birth)
        user.interests = data.get('interests', user.interests)
        user.email = data.get('email', user.email)

        # Return the user_id
        return jsonify({'user_id': user.id}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@users_blueprint.route('/delete_user', methods=['DELETE'])
def delete_user():
    try:
        data = request.get_json()

        # Retrieve the user from the dictionary
        user_id = data.get('user_id', '0')
        if not user_list.get(user_id):
            return jsonify({'error': 'User not found'}), 404
        del user_list[user_id]
        return jsonify({'user_id': user_id}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
   
@users_blueprint.route('/get_user_list', methods=['GET'])
def get_user_list():
    # Convert users to a list of dictionaries for JSON serialization
    return jsonify({user_id: {
        'id': user.id,
        'username': user.username,
        'profile_pic': user.profile_pic,
        'date_of_birth': user.date_of_birth,
        'interests': user.interests,
        'email': user.email,
        'events': list(user.events.keys())
    } for user_id, user in user_list.items()})


@users_blueprint.route('/get_user', methods=['GET'])
def get_user():
    try:
        data = request.get_json()

        # Retrieve the user from the dictionary
        user = user_list.get(data.get('user_id', '0'))
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        return jsonify({
            "id": user.id,
            "username": user.username,
            "profile_pic": user.profile_pic,
            "date_of_birth": user.date_of_birth,
            "interests": user.interests,
            "email": user.email,
            "events": list(user.events.keys())
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500
