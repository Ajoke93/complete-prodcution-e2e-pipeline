pipeline {
    agent {
        label 'Agent-1'
    }
    tools {
        maven 'maven3'
    }
    environment {
        // ... your environment variables ...
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout from SCM') {
            steps {
                git branch: 'dev', credentialsId: 'Teckvisuals-Git-Cred', url: GITHUB_URL
            }
        }

        stage('Build Application') {
            steps {
                try {
                    sh 'mvn clean package'
                } catch (Exception e) {
                    currentBuild.result = 'FAILURE'
                    error("Build failed: ${e.message}")
                }
            }
        }

        stage('Test Application') {
            steps {
                try {
                    sh 'mvn test'
                } catch (Exception e) {
                    currentBuild.result = 'FAILURE'
                    error("Tests failed: ${e.message}")
                }
            }
        }

        // Add similar error handling to other stages...

        stage('Trigger CD Pipeline') {
            steps {
                try {
                    script {
                        sh "curl -v -k --user ajoke:\${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=\${IMAGE_TAG}' '${JENKINS_SERVER_URL}/job/teckvisuals-CD-job/buildWithParameters?token=gitops-token'"
                    }
                } catch (Exception e) {
                    currentBuild.result = 'FAILURE'
                    error("CD Pipeline trigger failed: ${e.message}")
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
