# -----------------------------------------------------------------------------
# Copyright 2018-2025 Matthias Petermann, Uwe Heber
#
# Routes for Project TreeView
#
# Provides:
# - A top-level tree view (HTML)
# - An endpoint for loading child project nodes (JSON, used by AJAX)
# -----------------------------------------------------------------------------

# TreeView overview page
get 'project_tree', to: 'project_tree#index'

# JSON: return children for a given project ID
get 'projects/:id/children', to: 'project_tree#children'
