def call(Map configMap) {
    pipeline {
        agent {
            node {
                label "AGENT-1"
            }
        }
    environment {
        GIT_URL = "${configMap.GIT_URL}"
        BRANCH = "${configMap.BRANCH}"
        COMPONENT = "${configMap.COMPONENT}"
        REGION = "us-east-1"
    }
    options {
        timeout(time:15, unit: 'MINUTES')
        disableConcurrentBuilds()
    }
    stages {
        stage('checkout scm') {
            steps {
                git url: "${GIT_URL}", branch: "${BRANCH}"
            }
        }
        stage('deploy') {
            steps {
                dir("${COMPONENT}") {
                    script {
                        withAWS(region:"${REGION}",credentials:'aws-creds') {
                            sh """
                            aws eks update-kubeconfig \
                            --region ${REGION} \
                            --name roboshop-cluster
                            helm upgrade --install ${COMPONENT}-1.0 .
                            """
                        }
                   }
                }
            }
        }
        stage('wait for deployment') {
            steps {
                sleep time:60, unit: 'SECONDS'
            }
        }
        stage('status') {
            steps {
                script {
                    sh "helm status ${COMPONENT}-1.0"
                }
            }
        }
    }
    }
}