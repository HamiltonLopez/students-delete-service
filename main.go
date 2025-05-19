package main

import (
    "fmt"
    "log"
    "net/http"

    "github.com/gorilla/mux"
    "github.com/joho/godotenv"
    "example.com/students-delete-service/controllers"
    "example.com/students-delete-service/services"
    "example.com/students-delete-service/repositories"
)

func init() {
    godotenv.Load()
}

func main() {
    repo := repositories.NewStudentRepository()
    service := services.NewStudentService(repo)
    controller := controllers.NewStudentController(service)
    
    r := mux.NewRouter()

    r.HandleFunc("/students/{id}", controller.DeleteStudent).Methods("DELETE")

    fmt.Println("Servicio DELETE Students escuchando en el puerto 8080...")
    log.Fatal(http.ListenAndServe(":8080", r))
}

