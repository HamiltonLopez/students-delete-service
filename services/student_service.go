package services

import (
    "fmt"
    "example.com/students-delete-service/repositories"
)

type StudentServiceInterface interface {
    DeleteStudentByID(id string) error
}

type StudentService struct {
    repo *repositories.StudentRepository
}

func NewStudentService(repo *repositories.StudentRepository) *StudentService {
    return &StudentService{repo}
}

func (s *StudentService) DeleteStudentByID(id string) error {
    deleted, err := s.repo.RemoveStudentByID(id)
    if err != nil {
        return err
    }
    if !deleted {
        return fmt.Errorf("estudiante no encontrado")
    }
    return nil
}

