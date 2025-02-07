package main

import (
	"fmt"
	"log"
	"os/exec"
	"strconv"
	"strings"
	"time"
)

// Thresholds
const (
	CPUThreshold    = 70 // kill process, if CPU usage exceeds this percentage
	MemoryThreshold = 80 // kill process, if memory usage exceeds this percentage
	CheckInterval   = 10 // check every 10 seconds
)

// type Process represents active system processes
type Process struct {
	PID  int
	User string
	CPU  float64
	Mem  float64
	Cmd  string
}

// getProcesses retrieves a list of active processes and their resource usage
func getProcesses() ([]Process, error) {
	cmd := "ps aux --sort=-%cpu,-%mem | awk 'NR>1 {print $2, $1, $3, $4, $11}'"
	output, err := exec.Command("sh", "-c", cmd).Output()
	if err != nil {
		return nil, fmt.Errorf("failed to execute ps command: %v", err)
	}

	lines := strings.Split(strings.TrimSpace(string(output)), "\n")
	var processes []Process

	for _, line := range lines {
		fields := strings.Fields(line)
		if len(fields) < 5 {
			continue
		}

		pid, _ := strconv.Atoi(fields[0])
		cpu, _ := strconv.ParseFloat(fields[2], 64)
		mem, _ := strconv.ParseFloat(fields[3], 64)

		processes = append(processes, Process{
			PID:  pid,
			User: fields[1],
			CPU:  cpu,
			Mem:  mem,
			Cmd:  fields[4],
		})
	}

	return processes, nil
}

// monitorProcesses checks running processes and kills those exceeding thresholds
func monitorProcesses() {
	for {
		processes, err := getProcesses()
		if err != nil {
			log.Println("Error fetching processes:", err)
			continue
		}

		for _, proc := range processes {
			if proc.CPU > CPUThreshold || proc.Mem > MemoryThreshold {
				fmt.Printf("Killing process %d (%s) due to high resource usage: CPU %.2f%%, Mem %.2f%%\n",
					proc.PID, proc.Cmd, proc.CPU, proc.Mem)
				exec.Command("kill", "-9", strconv.Itoa(proc.PID)).Run()
			}
		}

		time.Sleep(CheckInterval * time.Second)
	}
}

func main() {
	fmt.Println("Starting Process Monitor...")
	monitorProcesses()
}
