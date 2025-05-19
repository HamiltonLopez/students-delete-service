package repositories

import (
    "context"
    "go.mongodb.org/mongo-driver/bson"
    "go.mongodb.org/mongo-driver/bson/primitive"
    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
    "log"
    "os"  
)

type StudentRepository struct {
    collection *mongo.Collection
}

func NewStudentRepository() *StudentRepository {
    mongoURI := os.Getenv("MONGO_URI")
    if mongoURI == "" {
        log.Fatal("MONGO_URI not set in environment")
    }

    clientOptions := options.Client().ApplyURI(mongoURI)
    client, err := mongo.Connect(context.TODO(), clientOptions)
    if err != nil {
        log.Fatal(err)
    }

    collection := client.Database("school").Collection("students")
    return &StudentRepository{collection}
}

func (r *StudentRepository) RemoveStudentByID(id string) (bool, error) {
    objID, err := primitive.ObjectIDFromHex(id)
    if err != nil {
        return false, err
    }

    result, err := r.collection.DeleteOne(context.TODO(), bson.M{"_id": objID})
    if err != nil {
        return false, err
    }

    return result.DeletedCount > 0, nil
}

