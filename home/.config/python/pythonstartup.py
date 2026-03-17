# Python REPL startup configuration
# Lazy-loaded jedi autocomplete
try:
    from jedi.utils import setup_readline
    setup_readline()
except ImportError:
    pass

# Optional: Add other REPL enhancements here
# import sys
# import os
