<<<<<<< HEAD
# conf.py
=======
import os
import sys
sys.path.insert(0, os.path.abspath('.'))
>>>>>>> parent of d1604ff (change htm;_theme)

# Import the Sphinx RTD theme
import sphinx_rtd_theme

<<<<<<< HEAD
=======
# General configuration
extensions = [
    'sphinx.ext.autosectionlabel',  # Optional: for automatic section labels
]
>>>>>>> parent of d1604ff (change htm;_theme)

# Add the theme to the list of extensions
extensions = [
    # other extensions
]

<<<<<<< HEAD
# Set the theme
html_theme = 'sphinx_rtd_theme'
html_theme_path = [sphinx_rtd_theme.get_html_theme_path()]
=======
# HTML output
html_theme = 'sphinx_rtd_theme'  # Or your preferred theme
html_static_path = ['_static']
>>>>>>> parent of d1604ff (change htm;_theme)
