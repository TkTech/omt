# -*- coding: utf-8 -*-
from setuptools import setup

setup(
    name='omt',
    version='0.1.0',
    author='Tyler Kennedy',
    author_email='tk@tkte.ch',
    packages=[
        'omt'
    ],
    url='http://github.com/tktech/omt',
    entry_points={
        'console_scripts': [
            'omt-py = omt.cli:from_cli',
        ]
    },
    install_requires=[
        'docopt',
        'pyte',
        'jinja2'
    ]
)
