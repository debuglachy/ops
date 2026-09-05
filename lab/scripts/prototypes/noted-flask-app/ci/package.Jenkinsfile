pipeline {
	agent none
 
        stage("noted-flask-app-package") {
            agent any
            when {
                changeset "lab/scripts/prototypes/noted-flask-app/**"
                branch 'main'
            }
            steps {
              echo 'Packaging flask app with docker'
              script {
                docker.withRegistry('https://index.docker.io/v1/', 'dockerlogin') {
                    def notedImage = docker.build("${USER_NAME}/noted-app-flask:v${env.BUILD_ID}", "./lab/scripts/prototypes/noted-flask-app")
                    notedImage.push()
                    notedImage.push("latest")
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
                echo "${GIT_COMMIT}"​
                echo "triggering deployment"
                build job: 'py-pipe', parameters: [string(name: 'DOCKERTAG', value: GIT_COMMIT)]
           }
    }
}

