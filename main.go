package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"time"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Hello World"))
	})
	http.HandleFunc("/time", func(w http.ResponseWriter, r *http.Request) {
		l := r.URL.Query().Get("tz")
		location, err := time.LoadLocation(l)
		if err != nil {
			panic(err)
		}
		w.Write([]byte(
			fmt.Sprintf("Location: %s\nServer: %s",
				time.Now().In(location).Format("2006-01-02 15:04:05"),
				time.Now().Format("2006-01-02 15:04:05")),
		))
	})
	http.HandleFunc("/api", func(w http.ResponseWriter, r *http.Request) {
		resp, err := http.Get("https://example.com/")
		if err != nil {
			panic(err)
		}
		defer resp.Body.Close()

		body, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			panic(err)
		}
		w.Write(body)
	})

	http.ListenAndServe(":3000", nil)
}
