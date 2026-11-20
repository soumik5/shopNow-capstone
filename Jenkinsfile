pipeline {

    agent any

    environment {
    AWS_REGION = 'us-east-1'
    AWS_DEFAULT_REGION = 'us-east-1'

    TF_DIR = 'terraform'

    PATH = "C:\\terraform;${env.PATH}"

  
    AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
}
    stages {

        // STAGE 1: CHECKOUT
        stage('Checkout') {
            steps {
                echo 'Checking out ShopNow source code...'

                checkout scm
            }
        }

        // STAGE 2: TERRAFORM VERSION
        stage('Terraform Version') {
            steps {
                echo 'Checking Terraform installation...'

                dir("${TF_DIR}") {
                    bat 'terraform --version'
                }
            }
        }

        // STAGE 3: AWS AUTHENTICATION
        stage('AWS Authentication') {
            steps {
                echo 'Verifying AWS credentials...'

                bat 'aws --version'

                bat 'aws sts get-caller-identity'
            }
        }

        // STAGE 4: TERRAFORM INIT
        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'

                dir("${TF_DIR}") {
                    bat 'terraform init'
                }
            }
        }

        // STAGE 5: TERRAFORM VALIDATE
        stage('Terraform Validate') {
            steps {
                echo 'Validating Terraform configuration...'

                dir("${TF_DIR}") {
                    bat 'terraform validate'
                }
            }
        }

        // STAGE 6: TERRAFORM PLAN
        stage('Terraform Plan') {
            steps {
                echo 'Creating Terraform execution plan...'

                dir("${TF_DIR}") {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }

        // STAGE 7: MANUAL APPROVAL
        stage('Approval') {
            steps {
                input message: 'Do you approve AWS infrastructure provisioning?',
                      ok: 'Approve'
            }
        }

        // STAGE 8: TERRAFORM APPLY
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
            echo 'SUCCESS: ShopNow infrastructure deployed successfully!'
        }

        failure {
            echo 'FAILURE: Pipeline execution failed. Check Console Output.'
        }

        always {
            echo 'ShopNow Terraform CI/CD pipeline execution completed.'
        }
    }
}