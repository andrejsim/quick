package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"gopkg.in/ini.v1"
)

func handler(w http.ResponseWriter, r *http.Request) {
	cfg, err := ini.Load("/Users/andrejm/.aws/credentials")
	if err != nil {
		fmt.Printf("Fail to read file: %v", err)
		os.Exit(1)
	}

	key := cfg.Section("default").Key("aws_access_key_id").String()
	secret := cfg.Section("default").Key("aws_secret_access_key").String()
	token := cfg.Section("default").Key("aws_session_token").String()
	res := struct {
		Key    string
		Secret string
		Token  string
	}{key, secret, token}
	resp, err := json.Marshal(res)

	w.Header().Set("Content-Type", "application/json")
	w.Write(resp)
}

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe("localhost:8184", nil))
}
