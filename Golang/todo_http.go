package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"sync"
)

var tasks []string
var mutex = &sync.Mutex{}

func getTasksHandler(w http.ResponseWriter, r *http.Request) {
	mutex.Lock()
	defer mutex.Unlock()

	// Return the list of tasks as JSON
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(tasks)
}

func addTaskHandler(w http.ResponseWriter, r *http.Request) {
	mutex.Lock()
	defer mutex.Unlock()

	// Get task from URL query parameter and add to tasks
	task := r.URL.Query().Get("task")
	if task == "" {
		http.Error(w, "Task is required", http.StatusBadRequest)
		return
	}
	tasks = append(tasks, task)

	// Send response
	w.WriteHeader(http.StatusCreated)
	fmt.Fprintf(w, "Task '%s' added!", task)
}

func main() {
	http.HandleFunc("/tasks", getTasksHandler) 
	http.HandleFunc("/add-task", addTaskHandler) 

	// Start the HTTP server on port 8081
	fmt.Println("Starting To-Do List API on http://localhost:8081")
	log.Fatal(http.ListenAndServe(":8081", nil))
}
