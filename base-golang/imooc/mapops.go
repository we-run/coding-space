package main

import "fmt"

func main() {

	fmt.Println("1. 定义和初始化") // 定义

	tMap := map[string]string {
		"name": "daqiang",
	}

	fmt.Println(tMap)

	m2 := make(map[string]int)
	fmt.Println(m2)

	fmt.Println("2. Traversing map") // 遍历
	for k, v := range tMap {
		fmt.Println(k, v)
	}

	fmt.Println("3. Gettging value from map") // 获取值
	v, ok := tMap["name"]
	if ok {
		fmt.Println(v)
	} else {
		println(ok)
	}

}