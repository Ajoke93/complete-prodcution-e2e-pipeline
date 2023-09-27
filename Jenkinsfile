pipeline {
    agent {
        label 'Agent-1' // Specify the label of your Jenkins agent
    }
    environment {
        APP_NAME = "complete-production-e2e-pipeline"
        RELEASE = "1.0.0"
        DOCKER_USER = 'ajoke93'
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
        GITHUB_URL = 'https://github.com/Ajoke93/complete-production-e2e-pipeline.git'
    }
    tools {
        // Define the tools you need, e.g., Maven
        maven 'Maven-3' // Make sure 'Maven-3' matches the tool name in your Jenkins configuration
    }
    stages {
        stage('Checkout from SCM') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: 'dev']], // Define your branch
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [],
                          userRemoteConfigs: [[url: GITHUB_URL, credentialsId: 'Teckvisuals-Git-Cred']]
                ])
            }
        }
        stage('Build Application') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test Application') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Trigger CD Pipeline') {
            steps {
                script {
                    def JENKINS_SERVER_URL = env.JENKINS_URL
                    sh "curl -v -k --user ajoke:\${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=\${IMAGE_TAG}' '\${JENKINS_SERVER_URL}/job/teckvisuals-CD-job/buildWithParameters?token=gitops-token'"
                }
            }
        }
    }
    post {
        failure {
            emailext body: 'Build failed',
                subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Failed",
                to: 'ajokecloud@gmail.com'
        }
        success {
            emailext body: 'Build succeeded',
                subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Successful",
                to: 'ajokecloud@gmail.com'
        }
    }
}
