pipeline {
    agent any

    stages {

        // =========================================================
        // 1. Pull Application Code
        // =========================================================
        stage('Code Pull') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-creds',
                    url: 'https://github.com/Venkatesh-Borra/nodejsapp.git'
            }
        }


        // =========================================================
        // 2. Docker Build
        // =========================================================
        stage('Docker Build') {
            steps {
                sh '''
                    echo "========================================="
                    echo "Building Docker Image"
                    echo "========================================="

                    docker build \
                        -t vmtblog:${BUILD_NUMBER} .

                    docker tag \
                        vmtblog:${BUILD_NUMBER} \
                        borravenkatesh/vmtblog:${BUILD_NUMBER}

                    echo "Docker image built successfully"
                '''
            }
        }


        // =========================================================
        // 3. Docker Push
        // =========================================================
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
                        echo "========================================="
                        echo "Docker Login"
                        echo "========================================="

                        echo "$DOCKER_PASSWORD" | \
                            docker login \
                            -u "$DOCKER_USERNAME" \
                            --password-stdin

                        echo "========================================="
                        echo "Docker Push"
                        echo "========================================="

                        docker push \
                            borravenkatesh/vmtblog:${BUILD_NUMBER}

                        docker logout

                        echo "Docker image pushed successfully"
                    '''
                }
            }
        }


        // =========================================================
        // 4. Checkout Kubernetes Manifest Repository
        // =========================================================
        stage('Checkout Kubernetes Manifest') {
            steps {

                dir('manifests') {

                    deleteDir()

                    echo "========================================="
                    echo "Checking out Kubernetes Manifest Repository"
                    echo "========================================="

                    git branch: 'main',
                        credentialsId: 'github-creds',
                        url: 'https://github.com/Venkatesh-Borra/vmt_blog_k8s_manifests.git'
                }
            }
        }


        // =========================================================
        // 5. Update Kubernetes Manifest
        // =========================================================
        stage('Update Kubernetes Manifest') {
            steps {
                sh '''
                    echo "Cleaning old mainifests if any"
                    rm -rf vmt_blog_k8s_manifests
                    rm -rf manifests
                    mkdir manifests
                    cd manifests
                    Update_Image="borravenkatesh/vmtblog:${BUILD_NUMBER}"
                    replicas=2
                    echo "Pulling kubernetes manifests from github"
                    git clone https://github.com/Venkatesh-Borra/vmt_blog_k8s_manifests.git .
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
                                cd manifests
                                git config user.name "Jenkins"
                                git config user.email "jenkins@localhost"
                                git push origin main
                            '''
                        }
        }
    }
}


    // =============================================================
    // Post Actions
    // =============================================================
    post {

        success {
            echo """
            =========================================
            PIPELINE SUCCESS
            =========================================

            Build Number:
            ${BUILD_NUMBER}

            Docker Image:
            borravenkatesh/vmtblog:${BUILD_NUMBER}

            Kubernetes Manifest:
            Updated and pushed successfully

            =========================================
            """
        }

        failure {
            echo """
            =========================================
            PIPELINE FAILED
            =========================================

            Build Number:
            ${BUILD_NUMBER}

            Check the failed stage in the console output.

            =========================================
            """
        }

        always {
            echo "Pipeline execution completed."
        }
    }
}