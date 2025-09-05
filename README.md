# Personas App - Infraestructura AWS

Infraestructura como código (IaC) para desplegar una aplicación de gestión de personas en AWS utilizando Terraform.

## 🚀 Características

- **API RESTful** con API Gateway HTTP API
- **Backend serverless** con AWS Lambda (Python)
- **Base de datos relacional** con Amazon RDS (MySQL)
- **Frontend** desplegado en AWS ECS con Fargate
- **CI/CD** automatizado con GitHub Actions
- **Gestión de secretos** con AWS Secrets Manager
- **Monitoreo** con Amazon CloudWatch

## 🏗️ Arquitectura

```
+------------------+     +------------------+     +------------------+
|                  |     |                  |     |                  |
|   Frontend       |     |   API Gateway    |     |    Lambda        |
|   (ECS Fargate)  |<--->|   (HTTP API)     |<--->|    (Python)      |
|                  |     |                  |     |                  |
+------------------+     +------------------+     +--------+---------+
                                                          |
                                                          v
                                                   +------+--------+
                                                   |   RDS MySQL  |
                                                   |   (Amazon)   |
                                                   +--------------+
```

## 📋 Prerrequisitos

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado con credenciales válidas
- [Docker](https://www.docker.com/) (para construir la imagen del frontend)
- Cuenta de AWS con los permisos necesarios

## 🛠️ Configuración

1. **Clonar el repositorio**
   ```bash
   git clone <repo-url>
   cd personas-v2
   ```

2. **Configurar variables de entorno**
   Copia el archivo de ejemplo y edítalo con tus valores:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Inicializar Terraform**
   ```bash
   cd infra/terraform
   terraform init
   ```

## 🚀 Despliegue

1. **Revisar los cambios**
   ```bash
   terraform plan
   ```

2. **Aplicar la infraestructura**
   ```bash
   terraform apply
   ```

3. **Desplegar el frontend**
   ```bash
   cd ../../frontend
   ./deploy.sh
   ```

## 🔄 CI/CD

El proyecto incluye un flujo de CI/CD con GitHub Actions que se activa con cada push a la rama `main`. El flujo incluye:

- Pruebas del código
- Construcción de la imagen Docker
- Despliegue en ECS
- Actualización de la infraestructura con Terraform

## 🔐 Seguridad

- Las credenciales de la base de datos se almacenan en AWS Secrets Manager
- Las políticas de IAM siguen el principio de privilegio mínimo
- Todas las comunicaciones utilizan HTTPS

## 📊 Monitoreo

- Logs en CloudWatch para todos los servicios
- Métricas de rendimiento
- Alertas configuradas para eventos importantes

## 🧹 Limpieza

Para eliminar todos los recursos creados:

```bash
cd infra/terraform
terraform destroy
```

