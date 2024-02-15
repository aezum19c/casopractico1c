pipeline {
    agent any
    options {
        // This is required if you want to clean before build
        skipDefaultCheckout(true)
    }
    stages {
        stage('Get Code') {
            agent {
                label 'agente-ubuntu-01'
            }
            steps {
                // Clean before build
                cleanWs()
                // Obtener código del repo de la rama develop
                git branch: 'production', url: 'https://github.com/aezum19c/casopractico1c.git'
                sh '''
                    wget https://raw.githubusercontent.com/aezum19c/casopractico1c-aws-config/production/samconfig.toml
                    wget https://raw.githubusercontent.com/aezum19c/casopractico1c-aws-config/production/template.yaml
                '''
                stash name: 'code', includes: '**'
            }
        }
        stage('Deploy') {
            agent {
                label 'agente-ubuntu-03'
            }
            steps {
                unstash name: 'code'
                sh '''
                    sam build
                    sam deploy --config-env production --no-fail-on-empty-changeset
                '''
            }
        }
        stage('Rest') {
            agent { 
                label 'agente-ubuntu-03'
            }
            environment {
                BASE_URL = """${sh(
                        returnStdout: true,
                        script: 'sam list endpoints --stack-name todo-list-aws-production --region us-east-1 --output json | jq -r \'.[] | select(.LogicalResourceId=="ServerlessRestApi").CloudEndpoint | .[0]\' | tr -d \'\n\t\''
                    )}""" 
            }
            steps {
                unstash name: 'code'
                sh '''
                    echo $BASE_URL
                    chmod +x scripts/testRest.sh
                    ./scripts/testRest.sh
                '''
            }
        }
    }
    post {
        // Clean after build
        always {
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true,
                    patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                               [pattern: '.propsfile', type: 'EXCLUDE']])
        }
    }
}
