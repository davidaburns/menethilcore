package logger

import (
	"fmt"
	"os"
	"time"

	"github.com/rs/zerolog"
)

func NewLogger(level zerolog.Level) *zerolog.Logger {
	zerolog.SetGlobalLevel(level)

	output := zerolog.ConsoleWriter{Out: os.Stdout, TimeFormat: time.RFC3339, NoColor: false}
	output.FormatLevel = func(i any) string {
		colorize := func(s string, c int) string {
			return fmt.Sprintf("| \x1b[%dm%-6s\x1b[0m|", c, s)
		}

		var lvl string
		if ll, ok := i.(string); ok {
			switch ll {
			case "warn":
				lvl = colorize(ll, 33)
			case "error", "fatal", "panic":
				lvl = colorize(ll, 31)
			default:
				lvl = colorize(ll, 37)
			}
		} else {
			lvl = colorize("???", 37)
		}

		return lvl
	}

	output.FormatMessage = func(i any) string {
		return fmt.Sprintf("%s", i)
	}

	output.FormatFieldName = func(i any) string {
		return fmt.Sprintf("%s:", i)
	}

	output.FormatFieldValue = func(i any) string {
		return fmt.Sprintf("%s", i)
	}

	logger := zerolog.New(output).With().Caller().Timestamp().Logger()
	return &logger
}
