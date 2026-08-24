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

                    echo "Docker image built and tagged successfully."
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
                        echo "$DOCKER_PASSWORD" | docker login \
                            -u "$DOCKER_USERNAME" \
                            --password-stdin

                        docker push borravenkatesh/vmtblog:${BUILD_NUMBER}

                        docker logout
                    '''
                }
            }
        }

              // This runs AFTER Docker Push succeeds
        stage('Update Kubernetes Manifest') {
            steps {

                dir('manifests') {

                    deleteDir()

                    git branch: 'main',
                        credentialsId: 'github-creds',
                        url: 'https://github.com/Venkatesh-Borra/vmt_blog_k8s_manifests.git'

                    sh '''
                        IMAGE="borravenkatesh/vmtblog:${BUILD_NUMBER}"
                        export IMAGE

                        echo "Updating image to: $IMAGE"

                        yq -i \
                            '.spec.template.spec.containers[0].image = strenv(IMAGE)' \
                            deployment.yaml

                        echo "Updated deployment.yaml:"
                        cat deployment.yaml

                        git config user.name "Jenkins"
                        git config user.email "jenkins@localhost"

                        git add deployment.yaml

                        git commit \
                            -m "Update image to ${IMAGE}"
                    '''
                }
            }
        }

        stage('Push Kubernetes Manifest') {
            steps {

                dir('manifests') {

                    withCredentials([
                        usernamePassword(
                            credentialsId: 'github-creds',
                            usernameVariable: 'GITHUB_USERNAME',
                            passwordVariable: 'GITHUB_PASSWORD'
                        )
                    ]) {

                        sh '''
                            git config credential.helper \
                                "!f() { echo username=$GITHUB_USERNAME; echo password=$GITHUB_PASSWORD; }; f"

                            git push origin HEAD:main

                            git config --unset credential.helper
                        '''
                    }
                }
            }
        }
    }}