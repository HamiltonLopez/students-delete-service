# Students Delete Service

Servicio responsable de eliminar estudiantes del sistema.

## Funcionalidad

Este servicio expone un endpoint DELETE que permite eliminar un estudiante específico utilizando su identificador único.

## Especificaciones Técnicas

- **Puerto**: 8085 (interno), 30085 (NodePort)
- **Endpoint**: DELETE `/students/{id}`
- **Runtime**: Go
- **Base de Datos**: MongoDB

## Estructura del Servicio

```
students-delete-service/
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
├── src/
│   ├── main.go
│   ├── handlers/
│   ├── models/
│   └── config/
├── Dockerfile
└── README.md
```

## API Endpoint

### DELETE /students/{id}

Elimina un estudiante específico del sistema.

#### URL Parameters
- `id`: ID único del estudiante (requerido)

#### Response (Success - 204 No Content)
```json
{}
```

#### Error Response (404 Not Found)
```json
{
    "error": "string",
    "message": "string"
}
```

## Configuración Kubernetes

### Deployment
- **Replicas**: 3
- **Imagen**: hamiltonlg/students-delete-service:latest
- **Variables de Entorno**:
  - MONGO_URI: mongodb://mongo-service:27017

### Service
- **Tipo**: NodePort
- **Puerto**: 8085 -> 30085

## Despliegue

```bash
kubectl apply -f k8s/
```

## Verificación

1. Verificar el deployment:
```bash
kubectl get deployment students-delete-deployment
```

2. Verificar los pods:
```bash
kubectl get pods -l app=students-delete
```

3. Verificar el servicio:
```bash
kubectl get svc students-delete-service
```

## Pruebas

### Eliminar un estudiante
```bash
curl -X DELETE http://localhost:30085/students/12345
```

## Logs

Ver logs de un pod específico:
```bash
kubectl logs -f <pod-name>
```

## Monitoreo

### Métricas Importantes
- Tiempo de respuesta del endpoint
- Tasa de éxito/error en eliminaciones
- Uso de recursos (CPU/Memoria)
- Latencia de operaciones en MongoDB

## Solución de Problemas

1. **Error de Conexión a MongoDB**:
   - Verificar la variable MONGO_URI
   - Comprobar conectividad con mongo-service
   - Revisar logs de MongoDB

2. **Estudiante No Encontrado**:
   - Verificar el formato del ID
   - Comprobar existencia en la base de datos
   - Revisar logs de la aplicación

3. **Pod en CrashLoopBackOff**:
   - Verificar logs del pod
   - Comprobar recursos asignados
   - Verificar configuración del deployment

4. **Servicio no accesible**:
   - Verificar el estado del service
   - Comprobar la configuración de NodePort
   - Verificar reglas de firewall

## Optimización

1. **Validación**:
   - Implementar validación robusta de IDs
   - Verificar permisos de eliminación
   - Manejar casos especiales

2. **Transacciones**:
   - Implementar eliminación atómica
   - Manejar rollbacks en caso de error
   - Asegurar consistencia de datos

3. **Auditoría**:
   - Registrar eliminaciones realizadas
   - Mantener historial de operaciones
   - Implementar soft delete (opcional)

## Consideraciones de Seguridad

1. **Autorización**:
   - Verificar permisos antes de eliminar
   - Implementar autenticación si es necesario
   - Registrar quién realiza la eliminación

2. **Validación**:
   - Verificar formato de ID
   - Prevenir eliminaciones masivas no autorizadas
   - Implementar rate limiting

3. **Recuperación**:
   - Considerar implementar papelera de reciclaje
   - Mantener backups de datos eliminados
   - Procedimiento de recuperación de datos 