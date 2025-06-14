pipeline {
    agent any

    environment {
        FLASK_APP = 'application.py'
        FLASK_ENV = 'development'
        PATH = "/opt/homebrew/bin:$PATH"
    }

    stages {
        stage('Checkout do repositório') {
            steps {
                checkout scm
            }
        }
        stage('Instalar dependências da aplicação') {
            steps {
                sh '''
                    python3 -m pip install --upgrade pip
                    pip3 install -r requirements.txt
                '''
            }
        }
        stage('Análise com SonarCloud') {
            environment {
                SONAR_TOKEN = credentials('SONAR_TOKEN')
            }
            steps {
                sh '''
                    npm install -g sonarqube-scanner
                    pip3 install coverage
                    sonar-scanner \
                        -Dsonar.login=$SONAR_TOKEN \
                        -Dsonar.c.file.suffixes=- \
                        -Dsonar.cpp.file.suffixes=- \
                        -Dsonar.objc.file.suffixes=-
                '''
            }
        }
        stage('Subir aplicação Flask') {
            steps {
                sh '''
                    nohup python3 application.py &
                    sleep 5
                '''
            }
        }
        stage('Executar testes Robot em container Docker') {
            steps {
                sh """
                    export PATH=/usr/local/bin:\$PATH
                    docker run --rm \
                        --platform linux/amd64 \
                        --entrypoint sh \
                        -v "\$WORKSPACE/tests:/tests" \
                        --workdir /tests \
                        --network host \
                        websteredgar/robot-tests:latest \
                        -c "robot tests.robot"
                """
            }
        }
    }
}
