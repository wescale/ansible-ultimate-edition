# Configuration file for the Sphinx documentation builder.
#
# Reference documentation:
#   https://www.sphinx-doc.org/en/master/usage/configuration.html
#
# -- Project information ------------------------------------------------------
#
project = 'Ansible Ultimate Edition'
copyright = '2023 WeScale.fr'
author = 'www.wescale.fr'
release = '0.0.1'
#
# -- General configuration ----------------------------------------------------
#
extensions = [
    "myst_parser",
    "sphinx.ext.intersphinx",
    "sphinx.ext.autodoc",
    "sphinx.ext.mathjax",
    "sphinx.ext.viewcode",
    "sphinx_copybutton"
]

copybutton_selector = "div:not(.no-copybutton) > div.highlight > pre"
copybutton_prompt_text = "> "

templates_path = ['_templates']
exclude_patterns = []
source_suffix = {
    '.md': 'markdown',
}
#
# -- Options for EPUB output --------------------------------------------------
#
version = release
epub_theme = "basic"
epub_title = "Ansible Ultimate Edition"
epub_language = "fr"
epub_exclude_files = [
    '_static/scripts/furo.js.LICENSE.txt', 
    '_static/scripts/furo.js.map',
    '_static/styles/furo-extensions.css.map', 
    '_static/styles/furo.css.map'
]
#
# -- Options for HTML output --------------------------------------------------
#
html_theme = "furo"
html_title = "Ansible Ultimate Edition"
html_logo = "static/ansible_logo.png"

