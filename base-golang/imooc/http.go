package main

import (
	"net/http"
	"fmt"
	"io/ioutil"
)

func main() {

	resp, err := http.Get("http://api.dev.xzlcorp.com/doctor_doc")

	if err != nil {
		panic(err)
	}

	defer resp.Body.Close()

	if resp.StatusCode !=  http.StatusOK {
		fmt.Println("Error: status code", resp.StatusCode)
	}

	all, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		panic(err)
	}

	fmt.Printf("%s \n", all)
}