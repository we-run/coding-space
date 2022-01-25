package main

import (
	"fmt"
	"reflect"
	"runtime"
	"math"
)

// TODO： 六、函数定义和使用

func eval(a, b int, op string) (int, error) {
	switch op {
	case "+":
		return a + b, nil
	case "/":
		q, _ := div(a, b)
		return q, nil
	default:
		//panic("unsupported operations:" + op)
		return 0, fmt.Errorf("unsupproted operations: %s", op)
	}
}

// 为多个返回值 取默认名称
func div(a, b int) (q, r int) {
	return  a / b, a % b
}
// 多个返回值
func div1(a, b int) (int, int) {
	q := a / b
	r := a % b
	return q, r
}

// TODO： 七、反射和运行时 操作
func apply(op func(int, int) int, a, b int) int {
	p := reflect.ValueOf(op).Pointer()
	opName := runtime.FuncForPC(p).Name() // 反射拿出方法名称

	fmt.Printf("Calling function %s with args" + "(%d, %d)\n", opName, a, b)
	return op(a, b)
}

func pow(a, b int) int {
	return int(math.Pow(float64(a), float64(b)))
}

// 可变参数列表 相当于数组   没有默认参数，可选参数，方法重载等等
func sum(numbers ...int) int {
	s := 0
	for i := range numbers {
		fmt.Println(i)
		s += i
	}
	return s
}


func func_wap(a, b *int) {
	*b, *a = *a, *b
}

func func_swap1(a, b int) (int, int) {
	return b, a
}


func main() {

	fmt.Println("1,返回多个值（元组）")
	fmt.Println(eval(2, 3, "*"))
	q, r := div(3, 4)
	println(q, r)

	fmt.Println("2,异常抛出")
	if result, err := eval(5, 3, "x"); err != nil {
		fmt.Println("Error:", err)
	} else {
		fmt.Println(result)
	}

	fmt.Println("3,高阶函数")
	fmt.Println(apply(pow, 3, 4))

	fmt.Println("4,匿名函数")
	fmt.Println(apply(func(a int, b int) int {
		return int(math.Pow(float64(a), float64(b)))
	}, 3, 4))

	fmt.Println("5.函数参数多个值")
	fmt.Println(sum(1, 2, 3, 4 ,5))

	fmt.Println("6.参数传递")
	a, b := 3, 4
	func_wap(&a, &b)
	fmt.Println(a, b)
	fmt.Println(func_swap1(2,3))

}

