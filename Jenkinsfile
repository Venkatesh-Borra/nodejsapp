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

                    docker images | grep vmtblog
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
                        echo "Logging into Docker Hub"
                        echo "========================================="

                        echo "$DOCKER_PASSWORD" | \
                            docker login \
                            -u "$DOCKER_USERNAME" \
                            --password-stdin

                        echo "Pushing Docker image"

                        docker push \
                            borravenkatesh/vmtblog:${BUILD_NUMBER}

                        echo "Docker image pushed successfully"

                        docker logout
                    '''
                }
            }
        }


        // =========================================================
        // 4. Pull and Update Kubernetes Manifest
        // =========================================================
        stage('Update Kubernetes Manifest') {
            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'github-creds',
                        usernameVariable: 'GITHUB_USERNAME',
                        passwordVariable: 'GITHUB_PASSWORD'
                    )
                ]) {

                    sh '''
                        echo "========================================="
                        echo "Cleaning Old Kubernetes Manifests"
                        echo "========================================="

                        rm -rf manifests
                        mkdir manifests

                        cd manifests


                        echo "========================================="
                        echo "Variables"
                        echo "========================================="

                        Update_Image="borravenkatesh/vmtblog:${BUILD_NUMBER}"
                        replicas=2

                        echo "Image    : ${Update_Image}"
                        echo "Replicas : ${replicas}"


                        echo "========================================="
                        echo "Cloning Kubernetes Manifest Repository"
                        echo "========================================="

                        git clone \
                            https://${GITHUB_USERNAME}:${GITHUB_PASSWORD}@github.com/Venkatesh-Borra/vmt_blog_k8s_manifests.git .


                        echo "========================================="
                        echo "Updating Docker Image"
                        echo "========================================="

                        export Update_Image

                        yq -i \
                            '.spec.template.spec.containers[0].image = strenv(Update_Image)' \
                            deployment.yaml


                        echo "========================================="
                        echo "Updating Replicas"
                        echo "========================================="

                        export replicas

                        yq -i \
                            '.spec.replicas = env(replicas)' \
                            deployment.yaml


                        echo "========================================="
                        echo "Updated deployment.yaml"
                        echo "========================================="

                        cat deployment.yaml


                        echo "========================================="
                        echo "Git Configuration"
                        echo "========================================="

                        git config user.name "Jenkins"
                        git config user.email "jenkins@localhost"


                        echo "========================================="
                        echo "Committing Kubernetes Manifest"
                        echo "========================================="

                        git add deployment.yaml

                        git commit \
                            -m "Update image to ${Update_Image}"

                        echo "Kubernetes manifest committed successfully"
                    '''
                }
            }
        }


        // =========================================================
        // 5. Push Kubernetes Manifest
        // =========================================================
        stage('Push Kubernetes Manifest') {
            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'github-creds',
                        usernameVariable: 'GITHUB_USERNAME',
                        passwordVariable: 'GITHUB_PASSWORD'
                    )
                ]) {

                    sh '''
                        echo "========================================="
                        echo "Pushing Kubernetes Manifest to GitHub"
                        echo "========================================="

                        cd manifests

                        git push \
                            https://${GITHUB_USERNAME}:${GITHUB_PASSWORD}@github.com/Venkatesh-Borra/vmt_blog_k8s_manifests.git \
                            HEAD:main

                        echo "Kubernetes manifest pushed successfully"
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
            echo '''
            =========================================
            PIPELINE SUCCESS
            =========================================

            Docker Image:
            borravenkatesh/vmtblog:${BUILD_NUMBER}

            Kubernetes Manifest:
            Updated and pushed successfully

            =========================================
            '''
        }

        failure {
            echo '''
            =========================================
            PIPELINE FAILED
            =========================================

            Check the stage that failed above.

            =========================================
            '''
        }

        always {
            echo "Build Number: ${BUILD_NUMBER}"
            echo "Pipeline execution completed."
        }
    }
}