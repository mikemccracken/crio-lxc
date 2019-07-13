package main

import (
	"fmt"
	"os"

	"github.com/apex/log"
	"github.com/urfave/cli"
)

var (
	version = ""
	debug   = false
)

func main() {

	app := cli.NewApp()
	app.Name = "crio-lxc"
	app.Usage = "crio-lxc is a CRI compliant runtime wrapper for lxc"
	app.Version = version
	app.Commands = []cli.Command{
		stateCmd,
		createCmd,
		startCmd,
		killCmd,
		deleteCmd,
	}

	app.Flags = []cli.Flag{
		cli.BoolFlag{
			Name:  "debug",
			Usage: "enable debug mode",
		},
		cli.StringFlag{
			Name:  "log-level",
			Usage: "set log level for LXC",
		},
		cli.StringFlag{
			Name:  "log-file, log",
			Usage: "log file for LXC",
		},
		cli.StringFlag{
			Name:  "lxc-path, root",
			Usage: "set the lxc path to use",
			Value: "/var/lib/lxc",
		},
		// Currently ignored args, for runc compat:
		cli.BoolFlag{
			Name:   "systemd-cgroup",
			Usage:  "unused, here for runc compat",
			Hidden: true,
		},
		cli.StringFlag{
			Name:   "criu",
			Usage:  "unused, here for runc compat. path to criu binary",
			Hidden: true,
		},
		cli.BoolFlag{
			Name:   "rootless",
			Usage:  "unused, here for runc compat.",
			Hidden: true,
		},
	}

	app.Before = func(ctx *cli.Context) error {
		LXC_PATH = ctx.String("lxc-path")

		debug = ctx.Bool("debug")
		return nil
	}

	log.SetLevel(log.InfoLevel)

	if err := app.Run(os.Args); err != nil {
		format := "error: %v\n"
		if debug {
			format = "error: %+v (args: %+v)\n"
		}

		fmt.Fprintf(os.Stderr, format, err, os.Args)
		os.Exit(1)
	}
}
