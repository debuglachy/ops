pipeline {
	agent {
	    kubernetes {
		yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker-cli
    image: docker:cli
    command: ['cat']
    tty: true
    env:
    - name: DOCKER_HOST
      value: tcp://localhost:2375
  - name: dind
    image: docker:dind
    securityContext:
      priveleged: true
    env:
    - name: DOCKER_TLS_CERTDIR
      value: ""
    - name: DOCKER_LEGACY_IPTABLES
      value: 1
'''
	    }
	}
 	stages {
		stage("noted-flask-app-package") {
		    when {
		        allOf {
		            changeset 'lab/scripts/prototypes/noted-flask-app/**'
		        }
		    }
		    steps {
		      echo 'Packaging flask app with docker'
		      container('docker-cli') {
		          withCredentials([usernamePassword(credentialsId: 'dockerlogin', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
		              sh 'echo "$DOCKER_PASSWORD" | docker login index.docker.io -u "$DOCKER_USERNAME" --password-stdin'
		              sh 'docker build -t noted-desk-app:${env.BUILD_NUMBER} .'
		              sh 'docker push noted-desk-app:${env.BUILD_NUMBER}'
		        }
		      }
		    }
		}
	    stage('Trigger commit pipe') {
		    agent any
		    environment{
		      def GIT_COMMIT = "${env.GIT_COMMIT}"
		    }
		    steps {
		    	script {
			    	echo "${GIT_COMMIT}"
				echo "triggering deployment"
				build job: 'py-pipe', parameters: [string(name: 'DOCKERTAG', value: GIT_COMMIT)]
		    	}

		   }
	    }


        }
        post {
		always{
		    echo 'Package pipeline completed'
		}
	}
}

