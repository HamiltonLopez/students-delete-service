package controllers

import (
    "net/http"
    "github.com/gorilla/mux"
    "example.com/students-delete-service/services"
)

type StudentController struct {
    Service *services.StudentService
}

func NewStudentController(service *services.StudentService) *StudentController {
    return &StudentController{
        Service: service,
    }
}

func (c *StudentController) DeleteStudent(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    id := vars["id"]
    if id == "" {
        http.Error(w, "ID no proporcionado", http.StatusBadRequest)
        return
    }

    err := c.Service.DeleteStudentByID(id)
    if err != nil {
        http.Error(w, "Error al eliminar estudiante", http.StatusInternalServerError)
        return
    }

    w.WriteHeader(http.StatusNoContent)
}

