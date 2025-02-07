// usage: enter "http://www.localhost:8081/github/<username>"
package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strings"
)

const githubAPI = "https://api.github.com/users/"

// structure
type GitHubUser struct {
	Login      string `json:"login"`
	Name       string `json:"name"`
	Followers  int    `json:"followers"`
	Following  int    `json:"following"`
	PublicRepos int   `json:"public_repos"`
}

// retrieves user info from Github
func getGitHubUser(username string) (*GitHubUser, error) {
	url := fmt.Sprintf("%s%s", githubAPI, username)
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var user GitHubUser
	if err := json.NewDecoder(resp.Body).Decode(&user); err != nil {
		return nil, err
	}

	return &user, nil
}

// home
func homeHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Learning some Go!")
}

// about page
func aboutHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Nothing about this site.")
}

// handles user request
func githubHandler(w http.ResponseWriter, r *http.Request) {
	// Extract the username from the URL path
	parts := strings.Split(r.URL.Path, "/")
	if len(parts) < 3 {
		http.Error(w, "GitHub username is required", http.StatusBadRequest)
		return
	}

	username := parts[2]

	// Fetch GitHub user data
	user, err := getGitHubUser(username)
	if err != nil {
		http.Error(w, "Error fetching user information: "+err.Error(), http.StatusInternalServerError)
		return
	}

	// Return the GitHub user data in JSON format
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

func main() {
	// Routes and their handlers
	http.HandleFunc("/", homeHandler)       
	http.HandleFunc("/about", aboutHandler) 
	http.HandleFunc("/github/", githubHandler) 

	fmt.Println("Starting server on port 8081...")
	log.Fatal(http.ListenAndServe(":8081", nil))
}
