package main

import "fmt"

// 参数传递问题 （值传递-> 值拷贝，引用传递）
// Go 语言只有值传递一种方式！！！ 和指针进行配合
// 1.值  2.指针地址  3.对象（对象内部是指针的执行）

// Go 的指针不能做运算，只能取地址和传递
// Go 只有值传递
// 传嵌套对象的时候
// Cache { pData } 可以封装Cache为值类型或者指针类型
//           |
//          data // 定义的时候根据需要注意 是否需要拷贝值

// 声明- *
// 取地址- &
// 使用引用- *


func swap(a, b *int) {
	*b, *a = *a, *b
	//a,b = b,a
}

func swap1(a, b int) (int, int) {
	return b, a
}

func main()  {
	a, b := 2, 1
	swap(&a, &b)
	fmt.Println(a, b)
}
