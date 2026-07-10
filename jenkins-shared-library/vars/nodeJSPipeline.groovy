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
            APPVERSION = ""
            COMPONENT = "${configMap.COMPONENT}"
            PROJECT = "roboshop"
            REGION = "us-east-1"
            ACCOUNT_ID = "257394454651"
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
            stage('read version') {
                steps {
                    dir("${COMPONENT}") {
                        script {
                            def buildfileversion = readJSON file: 'package.json'
                            APPVERSION = buildfileversion.version
                            echo "APPVERSION IS: ${APPVERSION}"
                        }
                    }
                }
            }
            stage('install dependencies') {
                steps {
                    dir("${COMPONENT}") {
                        sh "npm install"
                    }
                }
            }
            // stage('code quality analysis') {
            //     steps {
            //         dir("${COMPONENT}") {
            //             script {
            //                 def scannerHome = tool 'sonar'
            //                 withSonarQubeEnv('sonar-server') {
            //                     sh "${scannerHome}/bin/sonar-scanner"
            //                 }
            //             }
            //         }
            //     }
            // }
            // stage('quality gates') {
            //     steps {
            //         script {
            //             timeout(time: 15, unit: 'MINUTES') {
            //                 waitForQualityGate abortpipeline: true
            //             }
            //         }
            //     }
            // }
            stage('build image') {
                steps {
                    sh "docker build --no-cache -t ${PROJECT}/${COMPONENT}:${APPVERSION}-${BUILD_NUMBER} ./${COMPONENT}"
                }
            }
            stage('scan image') {
                steps {
                    sh "trivy image --severity HIGH,CRITICAL ${PROJECT}/${COMPONENT}:${APPVERSION}-${BUILD_NUMBER} > ${COMPONENT}-image-report.txt"
                }
            }
            stage('image push') {
                steps {
                    script {
                        withAWS(region:"${REGION}",credentials:'aws-creds') {
                            sh """
                            aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
                            docker tag ${PROJECT}/${COMPONENT}:${APPVERSION}-${BUILD_NUMBER} ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${PROJECT}/${COMPONENT}:${APPVERSION}-${BUILD_NUMBER}
                            docker push ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${PROJECT}/${COMPONENT}:${APPVERSION}-${BUILD_NUMBER}
                            """
                        }
                    }
                }
            }
            stage('trigger cd job') {
                steps {
                    build job: "${COMPONENT}-cd-pipeline",
                    propagate: false,
                    wait: false
                }
            }
        }
    }
}