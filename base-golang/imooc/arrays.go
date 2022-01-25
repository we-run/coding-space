package main

import (
	"fmt"
)


// []int 和 [4]int 并不是一个东西
// 前者是Slice， 后者是数组
func printArray(arr [5]int) {

	// 方法里设置成100 并不会影响外面
	arr[0] = 100

	for i, v := range arr {
		fmt.Println(i, v)
	}

}

func printArray1(arr1 *[5]int) {

	// 方法里设置成100 并不会影响外面
	// 数组直接使用 无需使用 *arr1 进行使用
	arr1[0] = 100

	for i, v := range arr1 {
		fmt.Println(i, v)
	}

}

func main()  {

	fmt.Println("1, 数组语法-定义数组")
	var arr1 [5]int
	arr2 := [3]int{1, 2, 4}
	arr3 := [...]int{3, 4, 5, 4, 6} // 必须写点语法 表示是数组而不是slice

	var grid [4][5]int

	fmt.Println(arr1, arr2, arr3, grid)

	fmt.Println("2-1 数组语法-遍历数组")
	for i := 0; i < len(arr3); i++  {
		fmt.Println(arr3[i])
	}
	fmt.Println("2-2 数组语法-range遍历数组")
	// range 关键字遍历
	maxi := -1
	maxNumber := -1
	for i, v := range arr3 {
		fmt.Println(i, v)
		if maxNumber < v {
			maxi, maxNumber = i, v
		}
	}
	println(maxi, maxNumber)

	for _, v := range arr3 {// _ 省略变量
		fmt.Println(v)
	}

	// 为什么要用range
	// 1.意义明确，美观，意图明显？
	// 2. 其他语言有类似代码实现 (python 三方库支持)
	fmt.Println("3 数组内部实现")

	// 数组是值类型
	fmt.Println("4.数组是值类型")
	// [5]int 不是 [3]int 所以只能传入arr1 和 arr3
	// [10]int 和 [20]int 不是一个类型
	// 数组是拷贝传递
	// 可以通过指针进行引用传递
	printArray1(&arr1)
	//printArray(arr2)
	fmt.Println("<-------<")
	printArray1(&arr3)

	fmt.Println("-------")
	fmt.Println(arr1, arr2, arr3)



}
