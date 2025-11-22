# Redmine Project Tree (Standalone Plugin for Redmine 6)

A modern, standalone version of the original *Redmine Project Tree*
plugin - rebuilt for **Redmine 6.0** and designed specifically for
environments with **large, deeply nested project structures**.

## 🌳 Core Idea

Redmine installations with hundreds or even thousands of projects
quickly become hard to navigate - especially when these projects are
deeply nested.
This plugin solves that problem by providing:

-   **An interactive, lazily loaded project tree**
    → Only the parts of the tree you expand are loaded
-   **Smooth navigation even with very large hierarchies**
    → No performance issues when expanding deep structures
-   **A clear, hierarchical overview at a glance**
    → Much more usable than Redmine's built-in parent/child lists

## ✨ Features

-   Adds a **dedicated top-level navigation item** ("Project Tree")
    → leaves Redmine's standard project overview intact
-   Lazy loading of subtrees for **fast performance**
-   Clean, interactive visualization of project relations
-   Updated to work reliably with **Redmine 6.0 / Rails 7**
-   English and German localization

## 🧩 Background

This plugin is based on:

> [UweHeber/redmine-project-tree-plugin](https://github.com/UweHeber/redmine-project-tree-plugin)
> Originally developed for Redmine **3.x**

This fork:

-   modernizes the codebase
-   makes the plugin standalone
-   restores compatibility with Redmine 6
-   improves performance for very large project hierarchies

## 🚀 Installation

1.  Clone into your Redmine `plugins/` directory:

``` bash
cd redmine/plugins
git clone https://github.com/MatthiasPetermann/redmine-project-tree-plugin.git project_tree
```

2.  Restart Redmine:

``` bash
touch ../tmp/restart.txt
```

3.  A new tab **"Project Tree"** top menu item will appear.

## 🖥 Usage

Navigate to:

    Project Tree

Each level expands **on demand**, allowing fast browsing of large
hierarchies without rendering the entire tree at once.

## 🌍 Localization

-   English (`en.yml`)
-   German (`de.yml`)

## 🛠 Development

Setup helper script:

``` bash
scripts/setup-dev-environment.sh
```

Detailed notes in `DEVELOPMENT.md`.

## 📜 License

See the included `LICENSE` file.
