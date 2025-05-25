# Students Delete Service

Este servicio es parte del sistema de gestión de estudiantes y se encarga de eliminar registros de estudiantes existentes.

## Estructura del Servicio

```
students-delete-service/
├── controllers/     # Controladores REST
├── models/         # Modelos de datos
├── repositories/   # Capa de acceso a datos
├── services/      # Lógica de negocio
├── k8s/           # Configuraciones de Kubernetes
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── test/          # Scripts de prueba
    └── test-delete.sh
```

## Endpoints

### DELETE /delete/{id}
Elimina un estudiante existente del sistema.

**Parámetros de URL:**
- `id`: ID del estudiante (ObjectId)

**Response (200 OK):**
```json
{
    "message": "Student deleted successfully"
}
```

**Response (404 Not Found):**
```json
{
    "error": "Student not found"
}
```

## Configuración Kubernetes

### Deployment
El servicio se despliega con las siguientes especificaciones:
- Replicas: 1
- Puerto: 8080
- Imagen: students-delete-service:latest

### Service
- Tipo: NodePort
- Puerto: 8080
- NodePort: 30085

### Ingress
- Path: /delete
- Servicio: students-delete-service
- Puerto: 8080

## Despliegue en Kubernetes

### 1. Aplicar configuraciones
```bash
# Crear el deployment
kubectl apply -f k8s/deployment.yaml

# Crear el service
kubectl apply -f k8s/service.yaml

# Crear el ingress
kubectl apply -f k8s/ingress.yaml
```

### 2. Verificar el despliegue
```bash
# Verificar el deployment
kubectl get deployment students-delete-deployment
kubectl describe deployment students-delete-deployment

# Verificar los pods
kubectl get pods -l app=students-delete
kubectl describe pod -l app=students-delete

# Verificar el service
kubectl get svc students-delete-service
kubectl describe svc students-delete-service

# Verificar el ingress
kubectl get ingress students-delete-ingress
kubectl describe ingress students-delete-ingress
```

### 3. Verificar logs
```bash
# Ver logs de los pods
kubectl logs -l app=students-delete
```

### 4. Escalar el servicio
```bash
# Escalar a más réplicas si es necesario
kubectl scale deployment students-delete-deployment --replicas=3
```

### 5. Actualizar el servicio
```bash
# Actualizar la imagen del servicio
kubectl set image deployment/students-delete-deployment students-delete=students-delete-service:nueva-version
```

### 6. Eliminar recursos
```bash
# Si necesitas eliminar los recursos
kubectl delete -f k8s/ingress.yaml
kubectl delete -f k8s/service.yaml
kubectl delete -f k8s/deployment.yaml
```

## Pruebas

El servicio incluye un script de pruebas automatizadas (`test/test-delete.sh`) que verifica:

1. Eliminación exitosa de un estudiante
2. Manejo de ID inexistente
3. Manejo de ID inválido
4. Verificación de idempotencia

Para ejecutar las pruebas:
```bash
./test/test-delete.sh
```

También se puede ejecutar como parte de la suite completa de pruebas:
```bash
./test-all-services.sh
```

### Casos de Prueba

1. **Test 1:** Eliminar estudiante existente
   - Crea un estudiante de prueba
   - Elimina el estudiante
   - Verifica que fue eliminado correctamente

2. **Test 2:** Intentar eliminar estudiante inexistente
   - Usa un ID válido pero inexistente
   - Verifica el mensaje de error apropiado

3. **Test 3:** Probar con ID inválido
   - Usa un formato de ID incorrecto
   - Verifica el manejo de error

4. **Test 4:** Verificar idempotencia
   - Intenta eliminar un estudiante ya eliminado
   - Verifica que la operación es idempotente

## Variables de Entorno

- `MONGODB_URI`: URI de conexión a MongoDB (default: "mongodb://mongo-service:27017")
- `DATABASE_NAME`: Nombre de la base de datos (default: "studentsdb")
- `COLLECTION_NAME`: Nombre de la colección (default: "students")

## Dependencias

- Go 1.19+
- MongoDB
- Kubernetes 1.19+
- Ingress NGINX Controller

## Consideraciones de Seguridad

1. Validación de formato de ID
2. Verificación de permisos
3. Manejo seguro de errores
4. Registro de operaciones de eliminación
5. Confirmación de eliminación

## Monitoreo y Logs

- Endpoint de health check: `/health`
- Logs en formato JSON
- Métricas de rendimiento:
  - Tiempo de respuesta
  - Tasa de éxito/error en eliminaciones
  - Número de eliminaciones por período

## Solución de Problemas

1. Verificar la conexión con MongoDB
2. Comprobar los logs del pod
3. Validar la configuración del Ingress
4. Verificar el estado del servicio en Kubernetes
5. Revisar el formato de los IDs en las peticiones 