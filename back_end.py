from flask import Flask, request
from datetime import datetime
import uuid

app = Flask(__name__)


class Event:

    def __init__(self, event_title, event_description, event_picture, event_date, event_location, event_host, event_visitors):
        self.id = str(uuid.uuid4())
        self.title = event_title
        self.description = event_description
        self.picture = event_picture
        self.event_date = event_date
        self.create_date = datetime.now()
        self.location = event_location
        self.host = event_host
        self.visitors = event_visitors
