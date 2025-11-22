# -----------------------------------------------------------------------------
# Copyright 2018-2025 Matthias Petermann, Uwe Heber
#
# ProjectTreeController
#
# Provides endpoints to display project trees and to load child nodes
# recursively, but restricted to projects the currently logged-in user
# is authorized to access.
#
# Actions:
# - index:    returns all top-level projects (root nodes) for which the
#             user has access rights
# - children: returns the direct children of a project (JSON), also filtered
#             by user permissions
#
# Requirements:
# - User must be logged in (before_action :require_login)
# - Only projects with status = 1 are included
# - Access is restricted using current_user.projects (must be a valid relation)
# -----------------------------------------------------------------------------

class ProjectTreeController < ApplicationController
  before_action :require_login
  layout 'base'

  # GET /project_tree
  #
  # Returns all top-level projects (projects without a parent)
  # that fulfill both:
  # - status = 1
  # - belong to the set of projects the current user is allowed to access
  #
  # The result is typically used to render the root nodes of a project tree.
  def index
    @top_projects =
      current_user
        .projects
        .where(parent_id: nil, status: 1)
        .order(:name)
  end

  # GET /project_tree/:id/children
  #
  # Returns the direct children of the specified project as JSON.
  #
  # Permission model:
  # - The parent project must be accessible by the current user
  # - Only child projects that are accessible by the user and have status = 1
  #   are included
  #
  # Each returned child entry contains:
  # - id
  # - name
  # - identifier
  # - has_children (boolean)
  #
  # Example response:
  # {
  #   "children": [
  #     { "id": 42, "name": "Subproject A", "identifier": "SP-A", "has_children": true }
  #   ]
  # }
  def children
    # Ensure the requested parent is accessible by the current user
    project = current_user.projects.find(params[:id])

    children =
      project.children
             .where(status: 1)
             .merge(current_user.projects)  # permission filter
             .order(:name)

    render json: {
      children: children.map { |c|
        {
          id: c.id,
          name: c.name,
          identifier: c.identifier,
          has_children: c.children.merge(current_user.projects).exists?
        }
      }
    }
  end
end
