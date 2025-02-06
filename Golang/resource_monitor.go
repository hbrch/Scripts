package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os/exec"
	"strconv"
	"strings"
)

type SystemStats struct {
	CPUUsage   int `json:"cpu_usage"`
	MemoryUsage int `json:"memory_usage"`
	DiskUsage  int `json:"disk_usage"`
}

func getUsage(command string) int {
	out, _ := exec.Command("sh", "-c", command).Output()
	val, _ := strconv.Atoi(strings.TrimSpace(string(out)))
	return val
}

func systemStatsHandler(w http.ResponseWriter, r *http.Request) {
	stats := SystemStats{
		CPUUsage:   getUsage("top -bn1 | grep 'Cpu(s)' | awk '{print 100-$8}'"),
		MemoryUsage: getUsage("free | grep Mem | awk '{print $3/$2 * 100}'"),
		DiskUsage:  getUsage("df / | grep / | awk '{print $5}' | sed 's/%//'"),
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(stats)
}

func main() {
	http.HandleFunc("/system_stats", systemStatsHandler)
	fmt.Println("Starting API on :8081")
	log.Fatal(http.ListenAndServe(":8081", nil))
}
