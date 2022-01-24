package step_module

import (
	"fmt"
	"strings"
	"testing"
)

func TestHello(t *testing.T) {

	want := "你好，世界。" // Windows
	if got := Hello(); got != want {
		t.Errorf("Hello() = %q, want %q", got, want)
	}

	fmt.Println(strings.Index("gaoxue (conflicted copy 2019-10-23 222130)", "conflicted copy"))
}
