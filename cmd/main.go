package main

import (
	"net/http"
	"runtime"

	"github.com/gin-gonic/gin"
	"github.com/kofj/multi-arch/cmd/info"
)

var (
	r = gin.Default()
)

func main() {
	r.GET("/", indexHandler)

	r.Run(":9090")
}

func indexHandler(c *gin.Context) {
	var osinfo = map[string]string{
		"GoVersion":  runtime.Version(),
		"BuildArch":  info.BuildArch,
		"BuildOS":    info.BuildOS,
		"RuningArch": runtime.GOARCH,
		"RuningOS":   runtime.GOOS,
	}
	c.JSON(http.StatusOK, osinfo)
}
