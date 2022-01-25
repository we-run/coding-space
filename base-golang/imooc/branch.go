package main

import (
	"io/ioutil"
	"fmt"
)

// TODO: 三、 控制语句
const filename = "abc.txt"
// 1. if
func if_control() {
	content, err := ioutil.ReadFile(filename)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("%s \n", content)
	}

	// if 的另外写法  作用域问题
	if content, err = ioutil.ReadFile(filename); err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("%s, \n", content)
	}
}


// 2.switch
// TODO: 四、Sprintf 、 Printf 。。。
func grade(score int) string {
	g := ""
	switch  {
	case score < 0 || score > 100:
		panic(fmt.Sprintf("Wrong score： %d", score))
	case score < 60:
		g = "F"
	case score < 80:
		g = "C"
	case score <  90:
		g = "B"
	case score <= 100:
		g = "A"
	}
	return g
}

func main() {
	if_control()

	fmt.Println(grade(40))
	fmt.Println(grade(99))
	fmt.Println(grade(100))
	//fmt.Println(grade(-1))
	//fmt.Println(grade(101))
}