// -----------------------------------------------------------------------------
// Copyright 2018-2025 Matthias Petermann, Uwe Heber
//
// Project TreeView Client Logic
//
// This script controls the interactive behaviour of the project tree:
// - Expanding and collapsing nodes
// - Loading child nodes via AJAX
// - Rendering nested project lists dynamically
//
// Dependencies:
// - jQuery
// - Global variables injected by ERB:
//     window.projectTreeIconsUrl
//     titleHideSubProjects
//     titleShowSubProjects
// -----------------------------------------------------------------------------

$(document).ready(function () {
  console.log("Project TreeView ready");

  // Attach click handlers to root toggle elements
  $("span.toggle").on("click", function () {
    showHideChildren($(this));
  });
});

/**
 * Expand or collapse a project node.
 *
 * @param {jQuery} toggle - The clicked toggle <span>.
 */
function showHideChildren(toggle) {
  if (toggle.hasClass("collapsed")) {
    toggle.addClass("expanded").removeClass("collapsed");
    updateToggleIcon(toggle, true);
    toggle.attr("title", titleHideSubProjects);
    addChildren(toggle);
  } else {
    toggle.addClass("collapsed").removeClass("expanded");
    updateToggleIcon(toggle, false);
    toggle.attr("title", titleShowSubProjects);
    removeChildren(toggle);
  }
}

/**
 * AJAX: Load child projects from the server.
 *
 * @param {jQuery} toggle - The expanded toggle.
 */
function addChildren(toggle) {
  var projectId = toggle.data("id");
  var url = "/projects/" + projectId + "/children";

  $.get(url, function (data) {
    if (data.children && data.children.length > 0) {
      var list = buildProjectList(data.children, projectId);

      // Insert the generated <ul> after the parent <li> of the toggle
      list.insertAfter(toggle.closest("li"));
    }
  });
}

/**
 * Remove the subtree belonging to this project.
 *
 * @param {jQuery} toggle - The collapsed toggle.
 */
function removeChildren(toggle) {
  var projectId = toggle.data("id");
  $('ul[data-project-parent-id="' + projectId + '"]').remove();
}

/**
 * Build a UL containing LI entries for each loaded child.
 *
 * Structure:
 *   <ul data-project-parent-id="X">
 *     <li class="project child">
 *       <span.toggle or .spacer>
 *       <a href="/projects/identifier">Name</a>
 *     </li>
 *   </ul>
 *
 * @param {Array} children   - Array of child project objects from the server
 * @param {Number} parentId  - Parent project ID
 * @returns {jQuery}         - A <ul> element
 */
function buildProjectList(children, parentId) {
  var ul = $('<ul data-project-parent-id="' + parentId + '"/>');

  $.each(children, function (_, child) {
    var li = $('<li class="project child"/>');

    if (child.has_children) {
      // A child with subprojects → add toggle
      var toggleSpan = $(
        '<span class="toggle collapsed" ' +
          'data-id="' + child.id + '" ' +
          'title="' + titleShowSubProjects + '">' +
          '  <svg class="s18 icon-svg">' +
          '    <use href="' + window.projectTreeIconsUrl + '#icon--angle-right"></use>' +
          '  </svg>' +
          '</span>'
      );

      toggleSpan.on("click", function () {
        showHideChildren($(this));
      });

      li.append(toggleSpan);

    } else {
      // No children → spacer for alignment
      li.append('<span class="spacer"></span>');
    }

    // Redmine-style project link (by identifier)
    var a = $('<a href="/projects/' + child.identifier + '"></a>');
    a.text(child.name);
    li.append(a);

    ul.append(li);
  });

  return ul;
}

/**
 * Update the SVG icon of a toggle depending on expansion state.
 *
 * @param {jQuery} span     - The toggle span
 * @param {Boolean} expanded - True if node is expanded
 */
function updateToggleIcon(span, expanded) {
  const use = span.find("use");
  const base = window.projectTreeIconsUrl;

  if (expanded) {
    use.attr("href", base + "#icon--angle-down");
  } else {
    use.attr("href", base + "#icon--angle-right");
  }
}
