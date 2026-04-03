pipeline {
    agent any

    environment {
        IMAGE_NAME     = 'enlaweb-tech'
        CONTAINER_NAME = 'enlaweb-container'
        PORT           = '8081'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Obteniendo el código fuente...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Construyendo la imagen Docker...'
                sh 'docker build -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Desplegando el contenedor...'
                sh 'docker stop ${CONTAINER_NAME} || true'
                sh 'docker rm ${CONTAINER_NAME} || true'
                sh 'docker run -d --name ${CONTAINER_NAME} -p ${PORT}:80 ${IMAGE_NAME}:latest'
            }
        }
    }

    post {
        success {
            echo "Pipeline exitoso — web corriendo en localhost:${PORT}"
        }
        failure {
            echo "Pipeline fallido — revisa los logs de cada stage"
        }
    }
}