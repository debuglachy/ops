pipeline {
	agent {
	    kubernetes {
		yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command: ['cat']
    tty: true
    volumeMounts:
    - name: kaniko
      mountPath: /kaniko/.docker/config.json
      subPath: .dockerconfigjson
  volumes:
  - name: kaniko
    secret:
      secretName: kaniko-docker
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
		      container('kaniko') {
		          withCredentials([usernamePassword(credentialsId: 'dockerlogin', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
		              sh '''
		                  /kaniko/executor \
		                  --context='pwd' \
		                  --dockerfile=lab/scripts/prototypes/noted-flask-app/Dockerfile \
		                  --destination=${DOCKER_USERNAME}/noted-flask-app:${env.BUILD_NUMBER}
		              '''
		              sh '''
		                  /kaniko/executor \
		                  --context='pwd' \
		                  --dockerfile=lab/scripts/prototypes/noted-flask-app/Dockerfile \
		                  --destination=${DOCKER_USERNAME}/noted-flask-app:latest
		              '''
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

