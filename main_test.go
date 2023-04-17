package main

import (
	"testing"
)

func TestMain(m *testing.M) {
	v := f()
	if v != 4 {
		m.Run()
	}
}
