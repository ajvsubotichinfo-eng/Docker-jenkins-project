pipeline {
    // `any` significa que Jenkins puede usar cualquier agente disponible
    agent any

    // Variables reutilizables en todo el pipeline
    environment {
        IMAGE_NAME = `enlaweb-tech`          // nombre de la imagen Docker
        CONTAINER_NAME = `enlaweb-container` // nombre del contenedor en ejecución
        PORT = `8081`                        // puerto donde corre la web
        WORKSPACE_PATH = `${WORKSPACE}`      // ruta del workspace de Jenkins
    }

    stages {

        // ─────────────────────────────────────
        // STAGE 1: Checkout
        // Jenkins descarga el código fuente.
        // Por ahora usamos el código que ya está
        // en el workspace de Jenkins.
        // ─────────────────────────────────────
        stage(`Checkout`) {
            steps {
                echo `Obteniendo el código fuente...`
                checkout scm
            }
        }

        // ─────────────────────────────────────
        // STAGE 2: Build
        // Construye la imagen Docker usando
        // el Dockerfile del proyecto.
        // ─────────────────────────────────────
        stage(`Build`) {
            steps {
                echo `Construyendo la imagen Docker...`
                sh `docker build -t ${IMAGE_NAME}:latest .`
            }
        }

        // ─────────────────────────────────────
        // STAGE 3: Deploy
        // Para el contenedor anterior si existe,
        // y levanta uno nuevo con la imagen recién
        // construida.
        // ─────────────────────────────────────
        stage(`Deploy`) {
            steps {
                echo `Desplegando el contenedor...`

                // Detiene el contenedor anterior — el `|| true`
                // evita que el pipeline falle si no existe todavía
                sh `docker stop ${CONTAINER_NAME} || true`
                sh `docker rm ${CONTAINER_NAME} || true`

                // Levanta el nuevo contenedor
                sh `docker run -d --name ${CONTAINER_NAME} -p ${PORT}:80 ${IMAGE_NAME}:latest`
            }
        }
    }

    // ─────────────────────────────────────
    // POST: Acciones después del pipeline
    // Se ejecutan sin importar si hubo error o no
    // ─────────────────────────────────────
    post {
        success {
            echo `✅ Pipeline exitoso — web corriendo en localhost:${PORT}`
        }
        failure {
            echo `❌ Pipeline fallido — revisá los logs de cada stage`
        }
    }
}