package main

import (
	"github.com/davidaburns/menethilcore/build"
	"github.com/davidaburns/menethilcore/internal/logger"
	"github.com/rs/zerolog"
)

func main() {
	buildInfo := build.NewBuildInfo()
	logger := logger.NewLogger(zerolog.DebugLevel)

	logger.Info().Msg(buildInfo.String())
}
