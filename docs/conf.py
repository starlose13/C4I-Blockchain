# The above code is a configuration file for the Sphinx documentation builder in Python. It sets
# various settings and metadata for generating documentation using Sphinx. Here is a summary of what
# the code is doing:
# Configuration file for the Sphinx documentation builder.
# This file contains settings for generating documentation using Sphinx.
# For comprehensive documentation on configuration options, visit:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# This section defines basic information about your project, which is used in various
# places within the generated documentation.

project = 'Decentralized Communication Framework'
# The 'project' variable specifies the name of the project or documentation set.
# This name should be descriptive and reflect the scope of the project, helping users
# understand what the documentation pertains to. It's used in the title of the generated
# documentation and various metadata fields.


copyright = '© 2024 SunAir Institute. All rights reserved.'
# The 'copyright' variable indicates the copyright statement for the documentation.
# It typically includes the year of publication and the name of the organization or
# individual holding the copyright. This information is crucial for legal purposes and
# for acknowledging the creators of the content.

author =  'Parisa Tavakoli ,Pouya Nasehi , Parisa Sarraf'
# The 'author' variable denotes the primary author or contributor of the documentation.
# This field should include the name of the person or team responsible for the content.
# It helps in attributing authorship and can be used in the documentation's header or footer.

# Release information
release_version = '1.0'  # Major release version
release_codename = 'Genesis'  # Codename for this release
release_date = '2024-09-01'  # Release date

# Highlights and compatibility as plain text for display in the documentation
release_highlights = (
    'Comprehensive overview of the Decentralized Communication Framework. '
    'Detailed guides on smart contract structure and consensus mechanisms. '
    'In-depth tutorials and a quickstart guide for new users.'
)

release_compatibility = 'Compatible with framework version 1.0 and API level v1.'

# Additional release notes
release_notes = 'This is the first stable release, providing a full set of features for the initial launch.'

# Set the release string used by Sphinx
release = f'{release_version} "{release_codename}" ({release_date})'

# The 'release' variable specifies the release version of the documentation.
# This version should correspond to the version of the software or project being documented,
# making it easier for users to identify which version of the documentation matches their
# version of the software. This is particularly useful for tracking changes and managing
# different versions of the documentation.

version = '1.0'
# The 'version' variable represents the major version of the project or software.
# This version number is used to indicate the primary version of the project and helps
# users understand the relevance of the documentation to specific project versions.
# It's typically a major release number and may differ from the release version.

# Optional metadata for HTML output, enhancing the documentation's presentation and
# user navigation.

html_title = 'Decentralized Communication Framework Documentation'
# The 'html_title' variable defines the title that appears in the HTML output of the documentation.
# This title is used in browser title bars, tab names, and other navigational elements,
# providing users with a clear indication of the documentation's purpose.

html_short_title = 'Decentralized Communication'
# The 'html_short_title' variable is a condensed version of the documentation title,
# used in breadcrumb trails, sidebars, and other space-limited areas. This helps maintain
# a clean and navigable layout without overcrowding.

html_last_updated_fmt = '%b %d, %Y'
# The 'html_last_updated_fmt' variable specifies the format for displaying the last updated date
# in the documentation. This ensures that users are aware of when the content was last revised,
# which is important for keeping information current and relevant.

project_url = 'https://github.com/SunAirInstitute/DecentralizedCommunication'
# The 'project_url' variable provides a direct link to the project's repository or main website.
# Including this URL in the documentation allows users to access the project source code, report issues,
# or find additional information related to the project.

# Aggregating project metadata into a dictionary for centralized management and consistent
# reference throughout the documentation.

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
latex_elements = {
    'papersize': 'a4paper',
    'pointsize': '10pt',
    'preamble': '',
    'figure_align': 'htbp',
}

# The 'project_metadata' dictionary consolidates all the key metadata about the project.
# This structured format allows for easy access and consistent use of project information
# across various parts of the documentation, ensuring uniformity and clarity.

# -- General configuration ---------------------------------------------------
# This section contains general settings that affect the overall behavior of Sphinx during
# the documentation build process.

extensions = ['sphinxcontrib.pdfconverter']
# The 'extensions' variable is a list where you can specify additional Sphinx extensions
# to enhance the documentation's functionality. Extensions can provide extra features
# such as syntax highlighting, additional document formats, or custom roles. Leave this list
# empty if no additional extensions are needed.

templates_path = ['_templates']
# The 'templates_path' variable lists directories containing custom templates used for
# rendering the documentation. These templates can be used to customize the layout and
# appearance of the generated documentation. The path is relative to the configuration file.

exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']
# The 'exclude_patterns' variable specifies file patterns and directories to exclude from
# the documentation build process. This helps avoid including unnecessary files and directories
# such as build artifacts or system files, ensuring a cleaner and more efficient build.

# -- Options for HTML output -------------------------------------------------
# This section configures settings specific to the HTML output of the documentation.

html_theme = 'sphinx_rtd_theme'  # Using the Read the Docs theme for a modern, responsive design.
# The 'html_theme' variable specifies the theme used for rendering the HTML output.
# The 'sphinx_rtd_theme' is commonly used for its clean, readable design and compatibility
# with the Read the Docs hosting platform. Themes control the look and feel of the documentation.

html_static_path = ['_static']
# The 'html_static_path' variable lists directories containing static files, such as images,
# stylesheets, and scripts, that are included in the HTML output. These files are used to
# customize the appearance and functionality of the documentation.

html_css_files = [
    'custom.css',
]
# The 'html_css_files' variable specifies custom CSS files to include in the HTML output.
# Custom stylesheets can be used to override default theme styles or add additional styling
# to the documentation, providing a tailored appearance.
