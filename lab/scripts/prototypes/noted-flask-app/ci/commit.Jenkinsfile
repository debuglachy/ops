node {
    def app

    
    stage('Clone repository') {
      
      
        checkout scm
    }
    
    stage('Update GIT') {
            script {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    withCredentials([
		                usernamePassword(
		                    credentialsId: 'maingithub',
		                    passwordVariable: 'GIT_PASSWORD',
		                    usernameVariable: 'GIT_USERNAME'
		                ),
		                usernamePassword(
		                    credentialsId: 'dockerlogin',
		                    usernameVariable: 'DOCKER_NAME'
		                ),
		                string(
		                    credentialsId: 'git-email',
		                    variable: 'GIT_EMAIL'
		                ),
		                string(
		                    credentialsId: 'git-name',
		                    variable: 'GIT_NAME'
		                )
                        ]) {
                            sh "git config user.email ${GIT_EMAIL}"
                            sh "git config user.name ${GIT_NAME}"
                            sh "cat lab/scripts/prototypes/noted-flask-app/ci/noted-flask-app.yaml"
                            sh "sed -i 's+${DOCKER_NAME}/noted-flask-app.*+${DOCKER_NAME}/noted-flask-app:${DOCKERTAG}+g' lab/scripts/prototypes/noted-flask-app/ci/noted-flask-app.yaml"
                            sh "cat lab/scripts/prototypes/noted-flask-app/ci/noted-flask-app.yaml"
                            sh "git add ."
                            sh "git commit -m 'Done by Jenkins Job deployment: ${env.BUILD_NUMBER}'"
                            sh "git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/ops.git HEAD:main"
                    }
                }
            }
    }

}

