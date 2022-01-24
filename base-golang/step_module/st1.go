package step_module


import (
	quote "rsc.io/quote/v3"
)

func Hello() string {
	
	return "您好!"
}

func Proverb() string {
	return quote.Concurrency()
}
