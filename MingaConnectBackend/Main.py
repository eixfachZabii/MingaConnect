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
    return jsonify(Events.possible_interests)


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
        host = user_stadt_muenchen.id
        interests = ['Meet new people']
        for location in locations:
            baenke = Events.Event(title, description, picture, date, location, host, interests)
            Events.event_list[baenke.id] = baenke
        return

    except Exception as e:
        print("Something went wrong while adding Baenke: " + str(e))
        return
    
if __name__ == '__main__':
    # Adds Bänke
    user_stadt_muenchen = Users.User('Stadt München', "pic", None, [], "egovernment@muenchen.de")
    user_stadt_muenchen.set_id('stadt_muenchen')
    Users.user_list[user_stadt_muenchen.id] = user_stadt_muenchen
    add_baenke()

    # Adds Users
    x = Users.User('Alice', Users.DEFAULT_PROFILE_PIC, '01.01.1990', [], 'alice@gmail.com')
    Users.user_list[x.id] = x
    x = Users.User('Bob', Users.DEFAULT_PROFILE_PIC, '15.02.1985', [], 'bob@gmail.com')
    Users.user_list[x.id] = x
    x = Users.User('Charlie', Users.DEFAULT_PROFILE_PIC, '22.03.1992', [], 'charlie@gmail.com')
    Users.user_list[x.id] = x
    x = Users.User('David', Users.DEFAULT_PROFILE_PIC, '12.04.1988', [], 'david@gmail.com')
    Users.user_list[x.id] = x
    x = Users.User('Eva', Users.DEFAULT_PROFILE_PIC, '30.05.1995', [], 'eva@gmail.com')
    Users.user_list[x.id] = x
    x = Users.User('Frank', Users.DEFAULT_PROFILE_PIC, '18.06.1987', [], 'frank@gmail.com')
    Users.user_list[x.id] = x
    x = Users.User('Grace', Users.DEFAULT_PROFILE_PIC, '07.07.1993', [], 'grace@gmail.com')
    Users.user_list[x.id] = x
    x = Users.User('Hannah', Users.DEFAULT_PROFILE_PIC, '21.08.1991', [], 'hannah@gmail.com')
    Users.user_list[x.id] = x
    x = Users.User('Ivy', Users.DEFAULT_PROFILE_PIC, '09.09.1994', [], 'ivy@gmail.com')
    Users.user_list[x.id] = x
    x = Users.User('Jack', Users.DEFAULT_PROFILE_PIC, '16.10.1989', [], 'jack@gmail.com')
    Users.user_list[x.id] = x

    
    user_id_1 = list(Users.user_list.keys())[1]
    user_id_2 = list(Users.user_list.keys())[2]
    user_id_3 = list(Users.user_list.keys())[3]


    # Adds Events
    # Bouldering
    x = Events.Event("Bouldering Basics", "Learn the basics of bouldering.", "pic", datetime(2024,12,1,10,0,0), [48.1455, 11.5657], user_id_1, ["Bouldering"])
    Events.event_list[x.id] = x
    x = Events.Event("Advanced Bouldering", "Challenge yourself with advanced techniques.", "pic", datetime(2024,12,5,18,0,0), [48.1345, 11.5657], user_id_1, ["Bouldering"])
    Events.event_list[x.id] = x
    x = Events.Event("Family Bouldering", "Fun for the whole family!", "pic", datetime(2024,12,10,14,0,0), [48.1567, 11.5678], user_id_2, ["Bouldering"])
    Events.event_list[x.id] = x

    # Hiking
    x = Events.Event("Sunrise Hike to the Alps", "Experience the Alps at sunrise.", "pic", datetime(2024,12,3,5,0,0), [48.1421, 11.5648], user_id_3, ["Hiking"])
    Events.event_list[x.id] = x
    x = Events.Event("Forest Walk in Englischer Garten", "Relaxing walk through the forest paths.", "pic", datetime(2024,12,8,11,0,0), [48.1534, 11.5796], user_id_1, ["Hiking"])
    Events.event_list[x.id] = x

    # Pub Crawls
    x = Events.Event("Historic Pub Crawl", "Explore historic pubs in Munich.", "pic", datetime(2024,12,9,20,0,0), [48.1374, 11.5755], user_id_3, ["Pub Crawls"])
    Events.event_list[x.id] = x
    x = Events.Event("Craft Beer Tour", "Taste some of Munich's finest craft beers.", "pic", datetime(2024,12,15,19,30,0), [48.1355, 11.5796], user_id_2, ["Pub Crawls"])
    Events.event_list[x.id] = x

    # Chess
    x = Events.Event("Beginner Chess Workshop", "Learn chess from the basics.", "pic", datetime(2024,12,1,18,0,0), [48.1361, 11.5673], user_id_2, ["Chess"])
    Events.event_list[x.id] = x
    x = Events.Event("Chess Club Meet", "Join local chess enthusiasts.", "pic", datetime(2024,12,12,16,0,0), [48.1473, 11.5673], user_id_3, ["Chess"])
    Events.event_list[x.id] = x

    # Picnics
    x = Events.Event("Picnic in Englischer Garten", "Enjoy a sunny day in the park.", "pic", datetime(2024,12,2,13,0,0), [48.1527, 11.5866], user_id_1, ["Picnics"])
    Events.event_list[x.id] = x
    x = Events.Event("Lake Picnicking at Starnberger See", "Picnic by the lake.", "pic", datetime(2024,12,7,12,0,0), [48.1584, 11.5823], user_id_1, ["Picnics"])
    Events.event_list[x.id] = x

    # Museums
    x = Events.Event("Art Exhibit at Pinakothek", "Discover amazing art pieces.", "pic", datetime(2024,12,4,10,30,0), [48.1488, 11.5706], user_id_2, ["Museums"])
    Events.event_list[x.id] = x
    x = Events.Event("Science at Deutsches Museum", "Explore interactive science exhibits.", "pic", datetime(2024,12,11,14,0,0), [48.1306, 11.6012], user_id_3, ["Museums"])
    Events.event_list[x.id] = x

    # Boat
    x = Events.Event("Boat Ride on Isar", "Relax with a boat ride on the Isar.", "pic", datetime(2024,12,6,10,0,0), [48.1324, 11.6037], user_id_1, ["Boat"])
    Events.event_list[x.id] = x
    x = Events.Event("Sunset Cruise", "Watch the sunset from the water.", "pic", datetime(2024,12,13,17,0,0), [48.1389, 11.6064], user_id_3, ["Boat"])
    Events.event_list[x.id] = x

    # Running
    x = Events.Event("Morning Run in Englischer Garten", "Start your day with a run.", "pic", datetime(2024,12,5,6,30,0), [48.1573, 11.5846], user_id_2, ["Running"])
    Events.event_list[x.id] = x
    x = Events.Event("10k Challenge at Olympiapark", "Push yourself in this 10k run.", "pic", datetime(2024,12,10,9,0,0), [48.1745, 11.5566], user_id_1, ["Running"])
    Events.event_list[x.id] = x

    # Board Games
    x = Events.Event("Board Game Night", "Enjoy a fun night of board games.", "pic", datetime(2024,12,2,19,0,0), [48.1384, 11.5743], user_id_2, ["Board Games"])
    Events.event_list[x.id] = x
    x = Events.Event("Strategy Games Meetup", "Test your strategic skills.", "pic", datetime(2024,12,9,15,0,0), [48.1399, 11.5718], user_id_3, ["Board Games"])
    Events.event_list[x.id] = x

    # Meet new people
    x = Events.Event("Coffee and Chat Meetup", "Make new friends over coffee.", "pic", datetime(2024,12,3,16,0,0), [48.1445, 11.5604], user_id_1, ["Meet new people"])
    Events.event_list[x.id] = x
    x = Events.Event("Outdoor Games Day", "Play outdoor games and socialize.", "pic", datetime(2024,12,8,14,0,0), [48.1503, 11.5756], user_id_2, ["Meet new people"])
    Events.event_list[x.id] = x


    # Starts the application
    app.run(host='0.0.0.0', debug=True)
        