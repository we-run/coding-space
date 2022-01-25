package main

import "fmt"

func printSlice(arr []int) {
	fmt.Printf("content: %v, len:%d, cap:%d\n", arr, len(arr), cap(arr))
}

func print2Slice(arr []int)  {
	for k, v := range arr {
		fmt.Printf("index:%d, v: %d", k , v)
	}
	fmt.Printf("\n")
}


//func main() {
//
//	//1. 定义和声明slice
//	//fmt.Printf("1.声明和定义slice\n")
//	arr := []int{0, 1, 2, 3, 4, 5, 6, 7}
//	//printSlice(arr)
//	//
//	//arr1 := make([]int, 8, 16)
//	//printSlice(arr1)
//	//var arr11 []int
//	//printSlice(arr11)
//	//
//	//fmt.Printf("2.slice取值\n")
//	//printSlice(arr[2:6])
//	//printSlice(arr[2:])
//	//printSlice(arr[:6])
//	//printSlice(arr[:])
//
//	fmt.Println("1.1 Reslice")
//	s1 := arr[2:6]
//	fmt.Println(s1)
//	s1 = s1[2:5]
//	fmt.Println(s1)
//	//s1 = s1[2:5] // 报错
//	//fmt.Println(s1)
//	//				      0  1
//	// 		        0  1  2
//	// 		  0  1  2  3
//	// [0, 1, 2, 3, 4, 5, 6, 7]
//
//	s2 := arr[3:5]
//	printSlice(s2)
//	//2. slice操作
//	// 添加元素超过容量 会自动分配新的数组（系统自动）
//	s2 = append(s2, 10)
//	printSlice(s2)
//	s2 = append(s2, 11)
//	s2 = append(s2, 12)
//	s2 = append(s2, 13) // 超过cap 系统自动分配新的数组 原有的数组交给垃圾回收
//	printSlice(s2)
//
//
//
//}
