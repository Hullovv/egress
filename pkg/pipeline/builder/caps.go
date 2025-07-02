package builder

import (
	"github.com/go-gst/go-gst/gst"
)

type FilterRaw struct {
	raw       string
	format    string
	framerate bool
	profile   bool
	width     uint
	height    uint
	gpu bool
}

func (f *FilterRaw) BuildFilter(gpu bool) (*gst.Ellement, error) {

}