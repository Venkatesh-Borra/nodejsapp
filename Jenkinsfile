pipeline {
    agent any

    stages {

        stage('Code Pull') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-creds',
                    url: 'https://github.com/Venkatesh-Borra/nodejsapp.git'
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t vmtblog:${BUILD_NUMBER} .
                    docker tag vmtblog:${BUILD_NUMBER} borravenkatesh/vmtblog:${BUILD_NUMBER}
                '''
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-cred',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

                        docker push borravenkatesh/vmtblog:${BUILD_NUMBER}

                        docker logout
                    '''
                }
            }
        }
    }
}