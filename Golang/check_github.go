// run with go run main.go <user>
package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
)

const githubAPI = "https://api.github.com/users/"

// structure of the response
type GitHubUser struct {
	Login     string `json:"login"`
	Name      string `json:"name"`
	Followers int    `json:"followers"`
	Following int    `json:"following"`
	PublicRepos int  `json:"public_repos"`
}

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

func main() {
	if len(os.Args) < 2 {
		log.Fatal("Please provide a GitHub username")
	}
	username := os.Args[1]

	user, err := getGitHubUser(username)
	if err != nil {
		log.Fatal("Error fetching user information:", err)
	}

	fmt.Printf("GitHub User Info for %s:\n", user.Login)
	fmt.Printf("Name: %s\n", user.Name)
	fmt.Printf("Followers: %d\n", user.Followers)
	fmt.Printf("Following: %d\n", user.Following)
	fmt.Printf("Public Repos: %d\n", user.PublicRepos)
}
