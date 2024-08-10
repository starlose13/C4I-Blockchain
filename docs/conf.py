import os
import sys
sys.path.insert(0, os.path.abspath('.'))

# Project information
project = 'Your Project Name'
copyright = '2024, Your Name'
author = 'Your Name'
release = '0.1'

# General configuration
extensions = [
    'sphinx.ext.autosectionlabel',  # Optional: for automatic section labels
]

templates_path = ['_templates']
exclude_patterns = []

# HTML output
html_theme = 'sphinx_rtd_theme'  # Or your preferred theme
html_static_path = ['_static']
