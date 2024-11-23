from flask import Flask, request, jsonify
from datetime import datetime
import uuid

app = Flask(__name__)

DEFAULT_PROFILEPIC = "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEBBQEFAAD/4QCCRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAABJADAAIAAAAUAAAAUJAEAAIAAAAUAAAAZJKRAAIAAAADMDAAAJKSAAIAAAADMDAAAAAAAAAyMDIzOjA1OjI1IDE2OjQwOjU3ADIwMjM6MDU6MjUgMTY6NDA6NTcAAAD/4QGcaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLwA8P3hwYWNrZXQgYmVnaW49J++7vycgaWQ9J1c1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCc/Pg0KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyI+PHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj48cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0idXVpZDpmYWY1YmRkNS1iYTNkLTExZGEtYWQzMS1kMzNkNzUxODJmMWIiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyI+PHhtcDpDcmVhdGVEYXRlPjIwMjMtMDUtMjVUMTY6NDA6NTc8L3htcDpDcmVhdGVEYXRlPjwvcmRmOkRlc2NyaXB0aW9uPjwvcmRmOlJERj48L3g6eG1wbWV0YT4NCjw/eHBhY2tldCBlbmQ9J3cnPz7/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAGQAZADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD6pooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKjmmjhGZHC1nz6qOkKZ92oA1KiluYYvvyKD6ZyawprqaX78hx6DgVBQBtSapCv3FZv0qu+qyH7kaj6nNZtFAFxtRuT0YD6LUZvbg9ZW/Diq9FAE32qf8A57P/AN9Ufap/+ez/AJ1DRQBYW9uB0lb8eakXUrgdWVvqtU6KANJNWcffjU/Q4qxHqkLffDJ+GaxaKAOliuIpf9XIp9s81JXLVYhvJ4vuuSPRuaAOhorNg1VTxMm33XkVfilSVcxsGHtQA+iiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKM461m3mpBMrBhm/vdhQBemmjhXMjAenqay7nU3fIhGxfU9aoSO0jFnYsT3NNoAVmLNliST3NJRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFOR2RtyMVPqDTaKANO21RhhZxuH94da04pUlXdGwYe1czT4pXibdGxU0AdNRVCz1FZcLNhH9exq/QAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABTJpUhQvIcAU25uEt49zn6Duawbm4e4k3OeOw7CgCW8vnuCVXKx+nr9aqUUUAFFFFABRRRQAUUUUAFFFFABRUc08UC7ppEjX1dgKzptf02Lg3IY/7Ck/0oA1aKwW8U6eOnnH6J/9elXxRp56+cv1T/69AG7RWZDr2my8LdKp/wBsFf51oRSxyruidHX1U5FAD6KKKACiiigAooooAKKKKACr1lftDhJMtH+oqjRQB08brIgZCCp6EU6uetLp7Z8ryp6r61uwTJPGHjOR/KgCSiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACobq4S3j3P8AgPWnzSrDGXc4Arn7qdriUu/4D0oAbcTPPIXc89h6VHRRQAUUUUAFFFFABRRRQAUUyaRIY2klYIijJYnAFcbrfiSS4LQ2JMUPQv0Zv8BQB0Oqa5aaflWbzJh/yzTkj6+lctf+Jb65yIiLeP0Tr+f+GKxOtFADpJHkYtIzOx6ljk02iigAooooAKfDLJC++GR429VODTKKAN7T/E95b4W4xcJ78N+ddVpmr2mojEL7ZO8b8N/9evN6VWKsGUkEcgjtQB6vRXIaH4lZSsOoncvQTdx9f8a65WDqGQhlIyCDkGgBaKKKACiiigAooooAKmtbh7eTcnTuPWoaKAOlgmWeMOhyD+lSVz1nctbS5HKn7w9a343WRAyHKkZBoAdRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUE4GTRWbq1ztXyUPJ+97D0oAp6hdG4lwv+rXp7+9VKKKACiiigAooooAKKKKACmTSpBE0krBUUZJPan1w/ivVvtc5tYG/cRn5iP42/wFAFXXtYk1KbauUtlPyp6+5rJoooAKKKKACiiigAooooAKKKKACiiigArd8O621hIILglrVj9SnuPb2rCooA9XVg6hlIZSMgjoaWuP8I6sUcWNw3yt/qiex/u12FABRRRQAUUUUAFFFFABV7TLvyX8tz+7Y/kao0UAdTRVDSrnzY/Lc/OvT3FX6ACiiigAooooAKKKKACiiigAooooAKKKKAI7mYQQs7dug9TXOSOZHZmOSTk1e1effMIlPyp1+tZ9ABRRRQAUUUUAFFFFABRRRQBj+KNR+w6eVjOJ5vlX2Hc/59a8/rW8TXn2zVpcHMcX7tfw6/rmsmgAooooAKKKKACiiigAooooAKKKKACiiigAooooAVSVYFSQQcgjtXo2g3/9o6ckpP71flkHuO/415xW94PvPs+peSx/dzjb/wACHT+o/GgDuqKKKACiiigAooooAKKKKAHwStDKrr1B/OukikEsauvRhmuYrT0afDGFu/K0Aa1FFFABRRRQAUUUUAFFFFABRRRQAVFcyiGB5D2HH1qWsrWpuUiH+8f6UAZjEsxJ5JOTSUUUAFFFFABRRRQAUUUUAFVtSuPsthcT90QkfXt+tWaw/GUvl6MVH/LSRV/r/SgDgycnJooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACnwyNFKkiHDIwYH3FMooA9UglE0Ecq/ddQw/EVJWV4Yl83Q7YnqoKH8Cf6Vq0AFFFFABRRRQAUUUUAFOjcxyK69VORTaKAOnicSRq69GGadWdo0u6Joj/AAnI+laNABRRRQAUUUUAFFFFABRRRQAVzd3L51w79iePpW7fSeVayN3xgfjXO0AFFFFABRRRQAUUUUAFFFFABXM+Om/0S2X1cn9P/r101cv46/497T/eb+QoA4+iiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAO68FtnR2H92Vh+grern/BP/IJk/wCux/ktdBQAUUUUAFFFFABRRRQAUUUUAWdOl8q7Q9m+U/jXQVy3TpXTQP5kKP8A3gDQA+iiigAooooAKKKKACiiigDO1p8Qon95s/lWPWhrTZuEX+6uaz6ACiiigAooooAKKKKACiiigArl/HX/AB72n+838hXUVy/jr/j3tP8Aeb+QoA4+iiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAO48E/8gmT/rsf5LXQVz/gn/kEyf8AXY/yWugoAKKKKACiiigAooooAKKKKACtzSH3WmP7rEVh1qaI3zSr9DQBq0UUUAFFFFABRRRQAUUUUAYGqNuvZPbA/SqtTXhzdy/7xFQ0AFFFFABRRRQAUUUUAFFFFABXL+Ov+Pe0/wB5v5CuormPHSn7Lat2Dkfp/wDWoA46iiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAO48E/8gmT/rsf5LXQVgeClI0hif4pWI/IVv0AFFFFABRRRQAUUUUAFFFFABV7R2xd49VIqjVrTDi+j/EfpQBv0UUUAFFFFABRRRQAUUUUAc1c/wDHxL/vn+dR1Jc/8fEv++f51HQAUUUUAFFFFABRRRQAUUUUAFUtYsRqNhJASA33kJ7MOlXaKAPK7iCS2maKdCkinBBqOvTr6wtb5QLqFXx0PQj8a47xRpUOmvAbbdskDZ3HOCMf40AYVFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABU9laTXtwsNupZ2/ID1NbfhfR7fUIJpboOQrhVAbHbn+lddZ2dvZx7LaJY1746n6nvQAafapZWcVvHyEGM+p7mrFFFABRRRQAUUUUAFFFFABRRRQAVY0/8A4/IvrVerGn83kX1oA6GiiigAooooAKKKKACiiigDnL0Yu5f94moataou29k98H9Kq0AFFFFABRRRQAUUUUAFFFFABRRRQAVz3jaLfpkUg6pIPyIP/wBauhrN8RQ+fot0oGSF3j8Dn+lAHnNFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFAHfeEYvL0SNv8AnozP+uP6VtVV0uE2+m20RGCsag/XHNWqACiiigAooooAKKKKACiiigAooooAKtaYM30f4/yqrV7R1zd59FJoA26KKKACiiigAooooAKKKKAMbWlxcI395az62NaTMKP/AHWx+dY9ABRRRQAUUUUAFFFFABRRRQAUUUUAFIwDKQwyCMEUtFAHmerWbWGoSwHO0HKH1U9Kp16B4k0n+0rYNEALmMfL/tD0rgHVkcq4KspwQRgigBKKKKACiiigAooooAKKKKACiiigArT8O2JvtUiUjMUZ3v8AQdvxrPgiknmWKFS8jHAUd69D0LTF0yzCcGZ+ZGHc+n0FAGlRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABWpoi/NK/0FZdbmkJttM/3iTQBdooooAKKKKACiiigAooooAgvo/NtZF74yPwrna6mubu4/JuJE7A8fSgCKiiigAooooAKKKKACiiigAooooAKKKKACsfW9Dh1IGRcRXOOHA4b61sUUAeYX9lPYzGK5jKnsezfQ1Wr1G8tYbyExXMYdD69vpXGa34elsVee3bzbccnP3l+vrQBg0UUUAFFFFABRRRQAVc03TbjUZdlunyj7znhVrX0Xw29yqT3p2QsNyoD8zD+ldjbwRW8KxQIqRr0UCgCho+jwaYmU+eYjDSEc/QegrToooAKKKKACiiigAooooAKKKKACiiigAooooABz0rpoE8uFE/ujFYWnRebdoOy/MfwroKACiiigAooooAKKKKACiiigArK1qL7ko/3T/StWo7mITQPGe44+tAHNUUrAqxBGCDg0lABRRRQAUUUUAFFFFABRRRQAUUUUAFFVrq+trQZuZ44/Ynn8utYl54rto8i1ieY+rfKP8aAOkrM8RyImj3Ku6qzJhQTgn6VyV54j1C4yFkEK+kYwfz61kyO8jFpGZ2PUscmgBtFFFABRRRQAUUUUAem6VIkmn2/lur4jUHac4OKt15VDLJC++F3RvVTg1sWfiW/gwJGWdfRxz+YoA72iues/FVpLgXKPA3r95f05/Stq2u7e6XdbzRyD/ZbOKAJ6KKKACiiigAooooAKKKKACiiigAoop0aGSRUXqxwKANbRotsTSnqxwPpWjTYkEcaovRRinUAFFFFABRRRQAUUUUAFFFFABRRRQBjavBsmEqj5X6/Ws+uluYRPC0bd+h9DXOSIY3KsMMDg0ANooooAKKKKACiis/VdWttNX9826UjiNep/wAKANCqd5qdnZ5FxcIrD+EHLfkK4rUvEF7ekqr+REf4Izg/iayKAOwvPFsa5Fpbs5/vSHA/IVh3mvahdZDTmNT/AAx/L/8AXrLooAUkkkkkk9SaSiigAooooAKKKKACiiigAooooAKKKKAClVmRgyEqw6EHBFJRQBrWfiHULbA87zl9JRn9etbln4sgfAu4XiP95DuH+NcbRQB6dZ6haXg/0adHP90HB/LrVqvKFJUggkEdCK2tM8R3doQs5+0Rejn5h9D/AI0Ad7RVLTdSttRj3W7/ADD7yHhl/CrtABRRRQAUUUUAFamjQZJmYdOFrOgiaaVUXqT+VdJFGsUaonRRigB1FFFABRRRQAUUUUAFFFFABRRRQAUUUUAFZurW25fOQcj73uPWtKg89aAOWoq3qNr9nlyv+rbp7e1VKACiisTxNq/9n2/lQH/SZBx/sD1oAh8Ra8LLdb2hDXHRm6hP/r1xUkjyyM8jFnY5LE5JpGJZiWJJPJJ70lABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUASW88lvMssDskinIYV3Ph/XE1FfKmwl0B07P7j/AArgqdG7RSK8bFXU5BHUGgD1aisrw/qq6na/PgXEfDr6+4rVoAKKKv6Xaec/mOP3anj3NAFzS7byo/McfOw/IVeoooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAGTRLNGUcZBrn7qBreUo3TsfUV0dRXUCXEZR/wPpQByt5cJaWsk8pwiLk+/tXml7cyXl1JPMcu5z9Paur8fyyWzQ2JyN37xj2YdB/WuNoAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKALelXr6ffRzpkgHDL/eXuK9KhkWaJJIzuRwGU+oNeVV3ngF5L61e15/cNncegU//XzQB0llbNcyYHCD7xrfjRY0CoMKBgCmwRLDGEQYA/WpKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAM7XdHtdZszBdLyOUkH3kPqK8h17RrrRbsw3S5U8pIPuuPb/Cvb6rajY2+o2r295EJIm7HqD6j0NAHg9FdJ4o8KXOjs00O6eyzxIByn+8P61zdABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFdZ4V8Hz6mUub4NBZ9QOjSfT0HvQBmeG9AutcudsQ8u3U/vJiOB7D1NeuaTpttpVmltZptReSe7H1J9ams7aGzt0gto1jiQYVVHSpqACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAGAZSGAIPBB71xHiTwPFc7rjSNsMvUwnhG+np/L6V29FAHgt5aT2Vw0N3E8Uq9VYYqCvddU0yz1SDyr6BZV7E8Ffoeorz/AFzwHc2+6XS3+0xdfLbhx/Q/pQBxVFSTwy28rRzxvHIvBVxgj8KjoAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiprW2nu5hFaxPLIeiouTQBDVrTrC61G4ENlC8sh9BwPcntXY6H4Clk2y6vJ5S9fJjOWP1PQfhmu90+xttPtxDZQpDGOyjr9T3oA5nw14Lt7DZcajtubkchMfIh/qfrXX0UUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQBT1LTLLUo9l9bxzDsSOR9D1Fcbqvw+Rsvpd0V9I5uR/30P8K76igDxTUvD2qadk3NnJsH8aDev5jp+NZNfQNZ1/omm3+Td2ULserbcN+Y5oA8Por1G88AabLk20txAfTIZR+fP61jXPw8u1z9mvYJP+uilP5ZoA4eiumm8Ea3H9yCKX/clH9cVTk8La1H97T5j/ukN/I0AYtFah8P6uP+YbdfhGTQPD+rnppt1+MZFAGXRW1H4W1uT7unyj/eIX+Zq7B4H1qT78UMX+/KD/LNAHMUV3Vr8O7hsfar6JPURoW/nitmz8BaXDg3Dz3B7hm2j9Of1oA8sHPStnTfDOrahgw2jpGf45fkH68n8K9asdI0+wx9js4YiP4gvzfn1q9QBw2k/D+CPD6ncNMf+ecXyr+fU/pXYWFha6fD5VlBHCncIMZ+p71ZooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKAP//Z"
DEFAULT_EVENTPIC =

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