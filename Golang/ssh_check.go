package main

import (
	"fmt"
	"log"
	"net/smtp"
	"os"
	"os/exec"
	"strings"
	"time"
)

const (
	CheckInterval = 10 * time.Second // checks for new ssh logins every 10 sec.
	Recipient     = "***"
)

// getEnv retrieves environment variables 
func getEnv(key, defaultValue string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return defaultValue
}

// sends a mail report, when a login is detected
func sendEmail(message string) {
	SMTPServer := getEnv("SMTP_SERVER", "smtp.protonmail.ch")
	SMTPPort := getEnv("SMTP_PORT", "587")
	SMTPUser := getEnv("SMTP_USER", "")
	SMTPPass := getEnv("SMTP_PASS", "")

	if SMTPUser == "" || SMTPPass == "" {
		log.Println("SMTP credentials are missing! Set SMTP_USER and SMTP_PASS as environment variables.")
		return
	}

	auth := smtp.PlainAuth("", SMTPUser, SMTPPass, SMTPServer)

	// mail message format
	subject := "Subject: SSH Login Alert\n"
	body := "Alert: A new SSH login was detected!\n\nDetails:\n" + message
	msg := []byte(subject + "From: " + SMTPUser + "\
