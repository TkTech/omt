#!/usr/bin/env python
# -*- coding: utf-8 -*-
USAGE = """omt-py

Usage:
    omt-py json <argv>... [options]
    omt-py html [options] -- <argv>...
    omt-py iterm-to-css <source>

Options:
    --width=<columns>       The number of columns for the pseudo-terminal.
                            [default: 80]
    --height=<lines>        The number of lines for the pseudo-terminal.
                            [default: 24]
    --standalone            When generating HTML, generate a standalone page
                            instead of a generic snippet.
    --theme=<source>        When genrating standalone HTML, use this iTerm2
                            theme for the CSS.
"""
import sys
import json
import docopt

from jinja2 import Environment, PackageLoader

from omt.core import process_to_screen
from omt.util import iterm_to_css


def from_cli():
    args = docopt.docopt(USAGE)

    if args['json']:
        screen = process_to_screen(
            args['<argv>'],
            stdin=sys.stdin,
            width=int(args['--width']),
            height=int(args['--height'])
        )

        sys.stdout.write(json.dumps(screen))
    elif args['html']:
        screen = process_to_screen(
            args['<argv>'],
            stdin=sys.stdin,
            width=int(args['--width']),
            height=int(args['--height'])
        )

        env = Environment(loader=PackageLoader('omt', 'templates'))
        if not args['--standalone']:
            # We're just making a generic snippet which can be inserted
            # into other pages.
            template = env.get_template('screen.jinja')
            sys.stdout.write(template.render(screen=screen))
            return 0

        # We're making a standalone page, so we need an iTerm2 theme
        # for the CSS.
        with open(args['--theme'], 'rb') as fin:
            style = iterm_to_css(fin.read())

        template = env.get_template('standalone.jinja')
        sys.stdout.write(template.render(screen=screen, style=style))
    elif args['iterm-to-css']:
        with open(args['<source>'], 'rb') as fin:
            sys.stdout.write('\n'.join(iterm_to_css(fin.read())))

    return 0


if __name__ == '__main__':
    sys.exit(from_cli())
