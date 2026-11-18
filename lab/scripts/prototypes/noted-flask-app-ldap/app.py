#!/usr/bin/env python3

# Noted-Flask-App is a simple web app for saving notes by LDAP-authenticated users to persistent storage.

import os
from pathlib import Path

from flask import Flask, render_template, render_template_string, request, redirect, url_for
from flask_ldap3_login import LDAP3LoginManager
from flask_login import LoginManager, login_user, UserMixin, current_user
from flask_ldap3_login.forms import LDAPLoginForm

app = Flask(__name__)
# setup from the env file
app.config.from_mapping(
        SECRET_KEY=os.environ.get('SECRET_KEY'),
        DEBUG=True,
        LDAP_HOST=os.environ.get('LDAP_HOST'),
	    LDAP_PORT=int(os.environ.get('LDAP_PORT')),
        LDAP_BASE_DN=os.environ.get('LDAP_BASE_DN'),
        LDAP_USER_DN='ou=users',
#		remove / change the group filter if using AD-based servers
	    LDAP_GROUP_OBJECT_FILTER='(objectclass=posixGroup)',
        LDAP_GROUP_DN='ou=groups',
        LDAP_USER_RDN_ATTR='uid',
        LDAP_USER_LOGIN_ATTR='uid',
        LDAP_BIND_USER_DN=os.environ.get('LDAP_BIND_USER_DN'),
        LDAP_BIND_USER_PASSWORD=os.environ.get('LDAP_BIND_USER_PASSWORD')
    )

# create note storage
WORK_FOLDER = Path(__file__).resolve().parent
DATA_FOLDER = WORK_FOLDER / "data"
os.makedirs(DATA_FOLDER, exist_ok=True)

# initialise (empty) memory for listing users encountered
users = {}

# see LDAP3 plugin official tutorial
login_manager = LoginManager(app)
ldap_manager = LDAP3LoginManager(app)
class User(UserMixin):
	def __init__(self, dn, username, data):
		self.dn = dn
		self.username = username
		self.data = data

	def __repr__(self):
		return self.dn
	
	def get_id(self):
		return self.dn

# required as per flask-login 'how it works' documentation
@login_manager.user_loader
def load_user(id):
	if id in users:
		return users[id]
	return None
@ldap_manager.save_user
def save_user(dn, username, data, memberships):
	user = User(dn, username, data)
	users[dn] = user
	return user

# root path composes of all routes
@app.route('/', methods=['GET', 'POST'])

def index():
#	ensure page loads only when logged in
	if not current_user or current_user.is_anonymous:
		return redirect(url_for('login'))
	if request.method == 'POST':
		if not current_user or current_user.is_anonymous:
			return redirect(url_for('login'))
#		data from the note form gets ingested
		filename = request.form.get('tags')
		content = request.form.get('content')

#		clean up to prevent traversing and invalid path/file combos
		filename_trimmed = os.path.basename(filename)
		file_path = os.path.join(DATA_FOLDER, filename_trimmed + '.txt')

		with open(file_path, 'a') as f:
#			adds full tags on first line for other scripts to work with
			f.write('#' + filename + '\n\n')
			f.write(content + '\n')
		return render_template('saved.html')

#	note form load
	return render_template('index.html')

@app.route('/login', methods=['GET','POST'])
def login():
#	login form definition
	template = """
	{{ get_flashed_messages() }}
	{{ form.errors }}
	<h2>Login Required</h2>
	<form method="POST">
		<br>
		<label>Username: {{ form.username() }}</label>
		<br>
		<label>Password: {{ form.password() }}</label>
		<br>
		{{ form.submit() }}
		{{ form.hidden_tag() }}
	</form>
	"""

#	inject ldap and flask-login manager components into login form
	form = LDAPLoginForm()

#	continue reloading form following login validation failures, otherwise redirect to '/' as logged in users will load into the index page
	if form.validate_on_submit():
		login_user(form.user)
		return redirect('/')

#	login form load
	return render_template_string(template, form=form)


# below has been replaced with gunicorn
# if __name__ == '__main__':
#	port = int(os.environ.get('NOTED_APP_PORT', 8080))
#	app.run(host='0.0.0.0', port=port)
