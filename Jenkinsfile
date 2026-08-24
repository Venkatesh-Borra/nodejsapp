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

        stage('pulling kubernetes manifests') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'github-creds',
                        usernameVariable: 'GITHUB_USERNAME',
                        passwordVariable: 'GITHUB_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "Cleaning old manifests if any"

                        rm -rf manifests
                        mkdir manifests

                        cd manifests

                        Update_Image="borravenkatesh/vmtblog:${BUILD_NUMBER}"
                        replicas=2

                        echo "Pulling kubernetes manifests from github"

                        git clone \
                            https://${GITHUB_USERNAME}:${GITHUB_PASSWORD}@github.com/Venkatesh-Borra/vmt_blog_k8s_manifests.git .

                        echo "Modifying the image name in deployment.yaml"

                    
                        yq -i '.spec.template.spec.containers[0].image = $Update_Image' deployment.yaml

                        echo "Image name updated successfully in deployment.yaml"

                        echo "---------------------------------------------------------"

                        echo "Updated Replicas in deployment.yaml"

                        yq -i '.spec.replicas = $replicas' deployment.yaml

                        echo "Updated deployment.yaml:"
                        cat deployment.yaml

                        echo "Committing changes to github"

                        git config user.name "Jenkins"
                        git config user.email "jenkins@localhost"

                        git add deployment.yaml

                        git commit -m "Updated image to ${Update_Image}"
                    '''
                }
            }
        }

        stage('Pushing kubernetes manifests to github') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'github-creds',
                        usernameVariable: 'GITHUB_USERNAME',
                        passwordVariable: 'GITHUB_PASSWORD'
                    )
                ]) {
                    sh '''
                        cd manifests

                        echo "Pushing Kubernetes manifests to GitHub"

                        git push \
                            https://${GITHUB_USERNAME}:${GITHUB_PASSWORD}@github.com/Venkatesh-Borra/vmt_blog_k8s_manifests.git \
                            HEAD:main
                    '''
                }
            }
        }
    }
}