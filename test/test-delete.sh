#!/bin/bash

# Colores para la salida
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# URLs de los servicios
SERVICE_URL="http://${KUBE_IP}:30085"
CREATE_URL="http://${KUBE_IP}:30081"
GET_URL="http://${KUBE_IP}:30083"

echo "Probando Students Delete Service..."
echo "=================================="

# Test 1: Eliminar un estudiante existente
echo -e "\nTest 1: Eliminar un estudiante existente"

# Primero creamos un estudiante
echo "Creando estudiante de prueba..."
response=$(curl -s -X POST \
  "${CREATE_URL}/students" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Estudiante a Eliminar",
    "age": 20,
    "email": "eliminar@example.com"
  }')

if [[ $response == *"id"* ]]; then
    STUDENT_ID=$(echo $response | grep -o '"id":"[^"]*' | cut -d'"' -f4)
    echo "ID del estudiante creado: $STUDENT_ID"
    
    # Ahora intentamos eliminarlo
    response=$(curl -s -X DELETE "${SERVICE_URL}/students/${STUDENT_ID}")
    
    if [[ -z "$response" ]]; then
        # Verificamos que realmente fue eliminado intentando obtenerlo
        verify_response=$(curl -s -X GET "${GET_URL}/students/${STUDENT_ID}")
        if [[ $verify_response == *"not found"* ]]; then
            echo -e "${GREEN}✓ Test 1 exitoso: Estudiante eliminado correctamente${NC}"
        else
            echo -e "${RED}✗ Test 1 fallido: El estudiante no fue eliminado${NC}"
        fi
    else
        echo -e "${RED}✗ Test 1 fallido: Error al eliminar el estudiante${NC}"
        echo "Respuesta: $response"
    fi
else
    echo -e "${RED}No se pudo crear el estudiante de prueba${NC}"
    exit 1
fi

# Test 2: Intentar eliminar un estudiante inexistente
echo -e "\nTest 2: Intentar eliminar un estudiante inexistente"
response=$(curl -s -X DELETE "${SERVICE_URL}/students/507f1f77bcf86cd799439011")

if [[ $response == *"error"* && $response == *"not found"* ]]; then
    echo -e "${GREEN}✓ Test 2 exitoso: El servicio manejó correctamente el ID inexistente${NC}"
else
    echo -e "${RED}✗ Test 2 fallido: El servicio no manejó correctamente el ID inexistente${NC}"
fi

# Test 3: Intentar eliminar con ID inválido
echo -e "\nTest 3: Intentar eliminar con ID inválido"
response=$(curl -s -X DELETE "${SERVICE_URL}/students/invalid-id")

if [[ $response == *"error"* ]]; then
    echo -e "${GREEN}✓ Test 3 exitoso: El servicio rechazó correctamente el ID inválido${NC}"
else
    echo -e "${RED}✗ Test 3 fallido: El servicio no validó correctamente el ID inválido${NC}"
fi

# Test 4: Verificar idempotencia (eliminar un estudiante ya eliminado)
echo -e "\nTest 4: Verificar idempotencia (eliminar estudiante ya eliminado)"
response=$(curl -s -X DELETE "${SERVICE_URL}/students/${STUDENT_ID}")

if [[ $response == *"error"* && $response == *"not found"* ]]; then
    echo -e "${GREEN}✓ Test 4 exitoso: El servicio es idempotente${NC}"
else
    echo -e "${RED}✗ Test 4 fallido: El servicio no es idempotente${NC}"
fi

echo -e "\nPruebas completadas!" 