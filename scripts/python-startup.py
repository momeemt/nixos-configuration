#!/usr/bin/env python3
import os
import atexit
import readline
import pathlib

xdg_state = os.getenv("XDG_STATE_HOME", os.path.expanduser("~/.local/state"))
hist_dir = os.path.join(xdg_state, "python")
pathlib.Path(hist_dir).mkdir(parents=True, exist_ok=True)
histfile = os.path.join(hist_dir, "history")

try:
    readline.read_history_file(histfile)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)
