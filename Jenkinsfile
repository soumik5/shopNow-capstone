pipeline {

    agent any

    environment {
        AWS_REGION = 'us-east-1'
        TF_DIR = 'terraform'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out ShopNow source code...'

                checkout scm
            }
        }

        stage('Terraform Version') {
            steps {
                script {
                    dir("${TF_DIR}") {
                        bat 'terraform --version'
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'

                dir("${TF_DIR}") {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                echo 'Validating Terraform configuration...'

                dir("${TF_DIR}") {
                    bat 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo 'Creating Terraform execution plan...'

                dir("${TF_DIR}") {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Approval') {
            steps {
                input message: 'Do you approve AWS infrastructure provisioning?',
                      ok: 'Approve'
            }
        }

        stage('Terraform Apply') {
            steps {
                echo 'Provisioning AWS infrastructure...'

                dir("${TF_DIR}") {
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
            echo 'ShopNow infrastructure deployed successfully!'
        }

        failure {
            echo 'Pipeline failed. Please check Jenkins console output.'
        }

        always {
            echo 'ShopNow Terraform pipeline execution completed.'
        }
    }
}