# -----------------------------------------------------------------------------
# ProjectTreeController
#
# Provides endpoints to display project trees and to load child nodes
# recursively, restricted to projects the currently logged-in user
# is allowed to access.
#
# Actions:
# - index:    returns all top-level projects (root nodes) visible to the user
# - children: returns authorized direct child projects (JSON)
#
# Requirements:
# - User must be logged in (before_action :require_login)
# - Only projects with status = 1 are included
# - Access filtering uses User.current, as required by Redmine
# -----------------------------------------------------------------------------

class ProjectTreeController < ApplicationController
  before_action :require_login
  layout 'base'

  # GET /project_tree
  #
  # Returns all top-level projects (parent_id = nil) with status = 1
  # that are visible to the current user.
  #
  # In Redmine, project visibility is enforced using:
  #   Project.visible(user)
  def index
    @top_projects =
      Project
        .visible(User.current)
        .where(parent_id: nil, status: 1)
        .order(:name)
  end

  # GET /project_tree/:id/children
  #
  # Returns the direct children of a project as JSON, filtered by:
  # - project must be visible to User.current
  # - child projects must also be visible
  # - only children with status = 1 are included
  def children
    # Ensure the parent project is visible to the current user
    project = Project.visible(User.current).find(params[:id])

    children =
      project
        .children
        .visible(User.current)
        .where(status: 1)
        .order(:name)

    render json: {
      children: children.map { |c|
        {
          id: c.id,
          name: c.name,
          identifier: c.identifier,
          has_children: c.children.visible(User.current).exists?
        }
      }
    }
  end
end
