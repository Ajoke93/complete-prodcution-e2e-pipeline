pipeline {
    agent {
        label 'Agent-1'
    }
    tools {
        maven 'maven3'
    }
    
    environment {
        APP_NAME = "complete-prodcution-e2e-pipeline"
        RELEASE = "1.0.0"
        DOCKER_USER = 'ajoke93'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
        JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN")
        GITHUB_URL = 'https://github.com/Ajoke93/complete-prodcution-e2e-pipeline.git' // Define GITHUB_URL
    }

    stages {
        
        stage('Checkout from SCM') {
            steps {
                git branch: 'dev', credentialsId: 'Teckvisuals-Git-Cred', url: GITHUB_URL
            }
        }

        stage('Build Application') {
            steps {
                script {
                    try {
                        sh 'mvn clean package'
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error("Build failed: ${e.message}")
                    } finally {
                        // Perform cleanup or post-build actions here, if needed
                    }
                }
            }
        }

        stage('Test Application') {
            steps {
                script {
                    try {
                        sh 'mvn test'
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error("Tests failed: ${e.message}")
                    } finally {
                        // Perform cleanup or post-test actions here, if needed
                    }
                }
            }
        }

        // Add similar error handling to other stages...

        stage('Trigger CD Pipeline') {
            steps {
                script {
                    try {
                        sh "curl -v -k --user ajoke:\${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=\${IMAGE_TAG}' '${JENKINS_SERVER_URL}/job/teckvisuals-CD-job/buildWithParameters?token=gitops-token'"
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error("CD Pipeline trigger failed: ${e.message}")
                    } finally {
                        // Perform cleanup or post-trigger actions here, if needed
                    }
                }
            }
        }
    }

    post {
        failure {
            emailext body: '''
                ${SCRIPT, template="groovy-html.template"}
            ''',
            subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Failed",
            mimeType: 'text/html',
            to: 'ajokecloud@gmail.com'
        }
        success {
            emailext body: '''
                ${SCRIPT, template="groovy-html.template"}
            ''',
            subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Successful",
            mimeType: 'text/html',
            to: 'ajokecloud@gmail.com'
        }
    }
}
