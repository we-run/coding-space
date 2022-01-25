package main

import (
	"fmt"
)



func printSlicee(arr []int) {
	fmt.Printf("content: %v, len:%d, cap:%d\n", arr, len(arr), cap(arr))
}
func main() {

	var s []int // go中一经定义 就是可用的 为空 Zero value slice is nil
	for i := 0; i < 10; i++ {
		s = append(s, i)
		printSlicee(s)
	}
	fmt.Println(s)


	s1 := []int{2, 4, 6, 8}
	printSlicee(s1)

	s2 := make([]int, 4) // 直接设置len长度
	s3 := make([]int, 4, 16) // 多开cap（空间）
	printSlicee(s2)
	printSlicee(s3)


	println("Coping Slice")
	copy(s3, s1)
	printSlicee(s3)


	println("Deleting Element from slice")
	//front := s2[0]
	//tail := s2[len(s2) - 1]
	s2 = s2[1:] // front delete
	s2 = s2[:(len(s2)-1)] // from
	s2 = append(s2[:3], s2[:5]...) // 删除中间的元素


}