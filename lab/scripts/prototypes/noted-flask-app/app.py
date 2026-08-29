import os
from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

DATA_FOLDER = '/app/data'
os.makedirs(DATA_FOLDER, exist_ok=True)

#defaults root path for all requests
@app.route('/', methods=['GET', 'POST'])

def index():
	if request.method == 'POST':

		#data from the form gets ingested
		filename = request.form.get('tags')
		content = request.form.get('content')

		#clean up to prevent traversing and invalid path/file combos
		filename_trimmed = os.path.basename(filename)
		file_path = os.path.join(DATA_FOLDER, filename_trimmed)

		with open(file_path, 'w') as f:
			f.write(content)

		return f"File saved to {file_path}"

	#form load
	return render_template('index.html')


if __name__ == '__main__':

	#check for custom port selection
	port = int(os.environ.get('NOTED_APP_PORT', 8080))

	#launch flask binded to all ifaces (planning to replace with gunicorn)
	app.run(host='0.0.0.0', port=port)
