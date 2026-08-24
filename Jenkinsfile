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
                    echo "DOcker image built and tagged successfully."
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
        stage('pulling kubernetes manifests') {
            steps {
                sh '''
                    Update_Image="borravenkatesh/vmtblog:${BUILD_NUMBER}"
                    replicas=2
                    echo "Pulling kubernetes manifests from github"
                    git clone https://github.com/Venkatesh-Borra/vmt_blog_k8s_manifests.git
                    echo "Modifying the image name in deployment.yaml"
                    yq -i '.spec.template.spec.containers[0].image = $Update_Image' ./vmt_blog_k8s_manifests/deployment.yaml
                    echo "Image name updated successfully in deployment.yaml"
                    echo "---------------------------------------------------------"
                    echo "Updated Replicas in deployment.yaml"
                    yq -i '.spec.replicas = $replicas' ./vmt_blog_k8s_manifests/deployment.yaml
                    echo "comming the changes to github"
                    git add .
                    git commit -m "Updated image name in deployment.yaml"
                '''
            }
        }
        stage('Pushing kubernetes manifests to github') {
            steps {
                withCredentials([
                    usernamePassword([
                        credentialsId: 'github-creds',
                        usernameVariable: 'GITHUB_USERNAME',
                        passwordVariable: 'GITHUB_PASSWORD'])])
                        {
                            sh '''
                                git push origin main

                            '''
                        }
        }
    }
}}