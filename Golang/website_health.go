package main

import (
	"fmt"
	"log"
	"net/http"
	"net/smtp"
	"os"
	"time"
)

// Websites to monitor
var websites = []string{
	"https://www.allsat.de",
	"https://www.glomon.de",
	"https://www.global-monitoring.de",
}

// Send email alert
func sendEmail(message string) {
  	SMTPServer := getEnv("SMTP_SERVER", "smtp.protonmail.ch")
  	SMTPPort := getEnv("SMTP_PORT", "587")
  	SMTPUser := getEnv("SMTP_USER", "")
  	SMTPPass := getEnv("SMTP_PASS", "")
    Recipient  = "***"

    if SMTPUser == "" || SMTPPass == "" {
		log.Println("SMTP credentials are missing! Set SMTP_USER and SMTP_PASS as environment variables.")
		return
	}

  	auth := smtp.PlainAuth("", SMTPUser, SMTPPass, SMTPServer)
  	subject := "Subject: Website Health Alert\n"
  	body := "Alert: " + message
  	msg := []byte(subject + "From: " + SMTPUser + "\nTo: " + Recipient + "\n\n" + body)
  
  	err := smtp.SendMail(SMTPServer+":"+SMTPPort, auth, SMTPUser, []string{Recipient}, msg)
  	if err != nil {
  		log.Println("Error sending email:", err)
  	} else {
  		log.Println("Website status alert email sent successfully.")
  	}
  }

// Check website status
func checkWebsiteStatus(url string) {
	resp, err := http.Get(url)
	if err != nil || resp.StatusCode != 200 {
		log.Printf("Website down: %s\n", url)
		message := fmt.Sprintf("Website %s is down. Error: %v", url, err)
		sendEmail(message)
	} else {
		log.Printf("Website is up: %s\n", url)
	}
}

// main
func main() {
	for {
		for _, website := range websites {
			checkWebsiteStatus(website)
		}
		time.Sleep(60 * time.Second) // Check every 60 seconds
	}
}
