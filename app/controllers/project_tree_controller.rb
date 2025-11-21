# -----------------------------------------------------------------------------
# Copyright 2018-2025 Matthias Petermann, Uwe Heber
#
# ProjectTreeController
#
# Provides endpoints to display project trees and to load child nodes
# recursively. These actions are typically used by a tree-view component
# or an asynchronous UI (e.g., a project navigator).
#
# Actions:
# - index:    returns all top-level projects (root nodes)
# - children: returns the direct children of a project as JSON
#
# Requirements:
# - User must be logged in (before_action :require_login)
# - Only projects with status = 1 are included
# -----------------------------------------------------------------------------

class ProjectTreeController < ApplicationController
  before_action :require_login
  layout 'base'

  # GET /project_tree
  #
  # Returns all projects without a parent (top-level projects) with status = 1.
  # This data is typically used to build the root nodes of the project tree.
  def index
    @top_projects = Project.where(parent_id: nil, status: 1).order(:name)
  end

  # GET /project_tree/:id/children
  #
  # Returns the direct child projects for the given project as JSON.
  # Each child entry contains:
  # - id
  # - name
  # - identifier
  # - has_children (boolean), used for lazy-loading in the UI
  #
  # Example response:
  # {
  #   "children": [
  #     { "id": 42, "name": "Subproject A", "identifier": "SP-A", "has_children": true }
  #   ]
  # }
  def children
    project = Project.find(params[:id])

    render json: {
      children: project.children
                      .where(status: 1)
                      .order(:name)
                      .map { |c|
                        {
                          id: c.id,
                          name: c.name,
                          identifier: c.identifier,
                          has_children: c.children.any?
                        }
                      }
    }
  end
end
