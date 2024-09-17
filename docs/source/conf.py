# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'Decentralized Communication Framework'
"""The name of the project or documentation. Ensure this is a clear and descriptive name
for the documentation set, reflecting the scope and objectives of the project."""

copyright = '2024, SunAir Institute'
"""The copyright statement for the documentation. This typically includes the year and
the name of the organization or individual holding the copyright."""

author = 'Pouya.N'
"""The primary author or contributor of the documentation. This field should be filled
with the name of the person or team responsible for creating the content."""

release = 'v1.0'
"""The release version of the documentation. This should correspond to the version of
the software or project being documented, and it is useful for versioning and tracking
changes over time."""

version = '1.0'
"""The version of the project or software. This should match the major version of the
release and helps users identify the documentation's relevance to specific versions of
the project."""

# Optional metadata that can be used for further project identification and management
html_title = 'Decentralized Communication Framework Documentation'
"""The title displayed in the HTML output of the documentation. It's often used in
browser titles and other navigational elements."""

html_short_title = 'Decentralized Communication'
"""A shorter version of the title, used for breadcrumb trails and other space-limited
areas in the documentation."""

html_last_updated_fmt = '%b %d, %Y'
"""Format for displaying the last updated date in the documentation, ensuring users are
aware of the currency of the content."""

project_url = 'https://github.com/SunAirInstitute/DecentralizedCommunication'
"""The URL to the project's repository or main website. This provides users with a direct
link to access the project source code or further information."""

# Example of a complete project metadata setup
project_metadata = {
    'name': project,
    'version': version,
    'release': release,
    'copyright': copyright,
    'author': author,
    'title': html_title,
    'short_title': html_short_title,
    'last_updated': html_last_updated_fmt,
    'project_url': project_url,
}
"""A dictionary containing key metadata about the project, which can be used throughout
the documentation for consistency and reference."""


# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.viewcode',
    'sphinx.ext.intersphinx',
    'sphinx.ext.todo',
    'sphinx.ext.mathjax',
    'sphinx.ext.ifconfig',
    'sphinx.ext.githubpages',
    # 'sphinx.ext.i18n',
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

# -- Internationalization (i18n) configuration ---------------------------------
# Add multi-language support

# Set the default language of the documentation
language = 'en'  # The default language, 'en' for English

# Directory where translation files will be stored
locale_dirs = ['locale/']  # This is where Sphinx will look for translations

# Whether to build .mo files with gettext compact option
gettext_compact = False

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

# html_theme = 'alabaster'
html_theme = 'sphinx_rtd_theme'  # Switch to Read the Docs theme
html_static_path = ['_static']

html_css_files = [
    'custom.css',
]
html_theme_options = {
    'language_switcher': True,  # If the theme supports it
    'languages': [
        ('en', 'English'),
        ('fa', 'فارسی'),
    ],
}