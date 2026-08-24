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

                dir('manifests') {

                    sh '''
                        echo "========================================="
                        echo "Updating Kubernetes Manifest"
                        echo "========================================="

                        Update_Image="borravenkatesh/vmtblog:${BUILD_NUMBER}"
                        replicas=2

                        export Update_Image
                        export replicas

                        echo "New Docker Image : ${Update_Image}"
                        echo "Replicas         : ${replicas}"

                        echo "========================================="
                        echo "Updating Image"
                        echo "========================================="

                        yq -i \
                            '.spec.template.spec.containers[0].image = strenv(Update_Image)' \
                            deployment.yaml

                        echo "Image updated successfully"

                        echo "========================================="
                        echo "Updating Replicas"
                        echo "========================================="

                        yq -i \
                            '.spec.replicas = env(replicas)' \
                            deployment.yaml

                        echo "Replicas updated successfully"

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
                        echo "Git Status"
                        echo "========================================="

                        git status

                        echo "========================================="
                        echo "Adding Changes"
                        echo "========================================="

                        git add deployment.yaml

                        echo "========================================="
                        echo "Committing Changes"
                        echo "========================================="

                        git commit \
                            -m "Update image to ${Update_Image}"

                        echo "Manifest committed successfully"
                    '''
                }
            }
        }


        // =========================================================
        // 6. Push Kubernetes Manifest
        // =========================================================
        stage('Push Kubernetes Manifest') {
            steps {

                dir('manifests') {

                    echo "========================================="
                    echo "Pushing Kubernetes Manifest"
                    echo "========================================="

                    withCredentials([
                        usernamePassword(
                            credentialsId: 'github-creds',
                            usernameVariable: 'GITHUB_USERNAME',
                            passwordVariable: 'GITHUB_PASSWORD'
                        )
                    ]) {

                        sh '''
                            git push \
                                https://${GITHUB_USERNAME}:${GITHUB_PASSWORD}@github.com/Venkatesh-Borra/vmt_blog_k8s_manifests.git \
                                HEAD:main

                            echo "Kubernetes manifest pushed successfully"
                        '''
                    }
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