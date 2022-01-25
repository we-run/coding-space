package main

import (
	"fmt"
	"math"
	"math/cmplx"
)

// TODO: 一、变量
// 1. 变量定义

// 2. 变量类型
// int int16 int32 uintptr(指针)
// float32 float64
// complex64 complex128
// byte , rune
// 复数 验证欧拉公式
func cmplextest()  {
	c := 3 + 4i
	fmt.Println(cmplx.Abs(c)) // 5
	// e^iπ + 1 = 0
	fmt.Println(cmplx.Pow(math.E, 1i * math.Pi) + 1)
}

// 3. 强制类型转换
func triangle()  {
	var a, b = 3, 4
	var c int
	c = int(math.Sqrt(float64(a * a + b * b))) // 转换 float
	fmt.Println(c)
}


// TODO: 二、常量

// 定义常量
func consts() {
	const filename = "abc.txt"
	const a, b = 3, 4 // 没有声明类型 则不用强转
	var c int
	c = int(math.Sqrt(a * a + b * b))
	fmt.Println(c)
}

// 枚举类型定义
const (
	Java = iota
	Golang
	JavaScript
	Python
	_
	Swift
)

const (
	b = 1 << (iota * 10)
	kb
	mb
	pb
	tb
)

func enums() {
	fmt.Println(Java, Golang, JavaScript, Python, Swift)
	fmt.Println(b, kb, mb, pb, tb)
}



func main() {
	cmplextest()
	triangle()

	consts()
	enums()
}