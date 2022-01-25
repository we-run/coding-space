package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

// TODO:五、循环
func convertToBin(n int) string {
	// n % 2
	result := ""
	for ; n > 0; n /= 2 {
		lsb := n % 2
		result = strconv.Itoa(lsb) + result
	}
	return result
}

// TODO: 五-1 ， 按照行 读文件
func printFile(filename string) {
	file, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		fmt.Println(scanner.Text())
	}
}

func deadfor()  {
	for {
		println("bc")
	}
}

func main() {

	fmt.Println(
		convertToBin(10),
		convertToBin(2),
		convertToBin(0),
		)

	printFile("abc.txt")
	//printFile("/Volumes/SpaceV/X-Work/2-Tech/1-App/ios-patient-oc/XinZhiLi/XinZhiLi.xcodeproj/project.pbxproj")

	//deadfor()
}




