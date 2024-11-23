module main

import os
import cli
import commands as c

fn main() {
    mut app := cli.Command{
        name:        'Chest'
        description: 'Chest Password Manager'
        execute:     fn (cmd cli.Command) ! {
            c.help()
            return
        }
        commands:    [
            cli.Command{
                name:    'init'
                execute: fn (cmd cli.Command) ! {
                    if os.args.len >= 4 {
						token := os.args[2]
						password := os.args[1]
						c.init(token, password)
						return
					}
					c.help()
                    return 
                }
            },
        ]
    }
    app.setup()
    app.parse(os.args)
	println(os.args)
}