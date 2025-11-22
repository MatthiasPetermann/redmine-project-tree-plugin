# -----------------------------------------------------------------------------
# Copyright 2018-2025
# Authors: Uwe Heber, Matthias Petermann
#
# Redmine Project Tree Plugin
#
# Registers the plugin with Redmine and adds a new top-level menu entry
# that links to the standalone project tree view. The plugin provides:
# - A hierarchical tree of all projects
# - Lazy-loaded child nodes (AJAX)
# - A dedicated page accessible from Redmine’s top menu
# -----------------------------------------------------------------------------

Redmine::Plugin.register :project_tree do
  name 'Project Tree plugin'
  author 'Uwe Heber, Matthias Petermann'
  description 'Adds a standalone project tree view to the Redmine top-level menu, including an expandable lazy-loaded hierarchy.'
  version '3.0.0'
  url 'https://github.com/MatthiasPetermann/redmine-project-tree-plugin'
  author_url 'https://www.petermann-digital.de'

  menu :top_menu,
       :project_tree,
       { controller: 'project_tree', action: 'index' },
       caption: :label_project_tree,
       after: :projects
end
