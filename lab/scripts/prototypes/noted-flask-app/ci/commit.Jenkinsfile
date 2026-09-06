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
		                string(
		                    credentialsId: 'dockerlogin-name',
		                    variable: 'DOCKER_NAME'
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
                            sh "git config user.email ${env.GIT_EMAIL}"
                            sh "git config user.name ${env.GIT_NAME}"
                            sh "cat lab/scripts/prototypes/noted-flask-app/ci/noted-flask-app.yaml"
                            sh "sed -i 's+${env.DOCKER_NAME}/noted-flask-app.*+${env.DOCKER_NAME}/noted-flask-app:${env.DOCKERTAG}+g' lab/scripts/prototypes/noted-flask-app/ci/noted-flask-app.yaml"
                            sh "cat lab/scripts/prototypes/noted-flask-app/ci/noted-flask-app.yaml"
                            sh "git add ."
                            sh "git commit -m 'Done by Jenkins Job deployment: ${env.BUILD_NUMBER}'"
                            sh "git push https://${env.GIT_USERNAME}:${env.GIT_PASSWORD}@github.com/${env.GIT_USERNAME}/ops.git HEAD:main"
                    }
                }
            }
    }

}

