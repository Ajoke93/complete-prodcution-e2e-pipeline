pipeline {
    agent {
        label 'Agent-1'
    }
    tools {
        // Define the Maven tool named 'maven3' to be used in the pipeline
        maven 'maven3'
    }
    
    environment {
        // Define environment variables to be used in the pipeline
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
        // Stage to clean up the workspace
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }

        // Stage to checkout code from SCM (Git repository)
        stage('Checkout from SCM') {
            steps {
                git branch: 'dev', credentialsId: 'Teckvisuals-Git-Cred', url: GITHUB_URL
            }
        }

        // Stage to build the application using Maven
        stage('Build Application') {
            steps {
                script {
                    try {
                        sh 'mvn clean package' // Build the application
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error("Build failed: ${e.message}")
                    } finally {
                        // Perform cleanup or post-build actions here, if needed
                    }
                }
            }
        }

        // Stage to test the application using Maven
        stage('Test Application') {
            steps {
                script {
                    try {
                        sh 'mvn test' // Run tests
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

        // Stage to trigger a CD (Continuous Deployment) pipeline
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
            // Send an email notification in case of failure
            emailext body: '''
                ${SCRIPT, template="groovy-html.template"}
            ''',
            subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Failed",
            mimeType: 'text/html',
            to: 'ajokecloud@gmail.com'
        }
        success {
            // Send an email notification in case of success
            emailext body: '''
                ${SCRIPT, template="groovy-html.template"}
            ''',
            subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Successful",
            mimeType: 'text/html',
            to: 'ajokecloud@gmail.com'
        }
    }
}
