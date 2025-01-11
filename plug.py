#!/usr/bin/python
# coding: utf-8
# @Author: Adrián Leguizamón

"""
Instalación de complementos de Godot.
"""


import subprocess
import sys

args = sys.argv[1:]
subprocess.run(["godot", "--headless", "-s", "plug.gd"] + args)
