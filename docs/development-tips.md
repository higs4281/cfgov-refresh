## Development tips

### TIP: Developing on nested satellite apps
Some projects can sit inside cfgov-refresh, but manage their own asset
dependencies. These projects have their own package.json and base templates.

The structure looks like this:

#### npm modules
- App's own dependency list is in
  `cfgov/unprocessed/apps/[project namespace]/package.json`
- App's `node_modules` path is listed in the Travis config
  https://github.com/cfpb/cfgov-refresh/blob/master/.travis.yml#L10
  so that their dependencies will be available when Travis runs.

#### Webpack
- Apps may include their own webpack-config.js configuration that adjusts how
  their app-specific assets should be built. This configuration appears in
  `cfgov/unprocessed/apps/[project namespace]/webpack-config.js`

#### Browserlist
- Apps may include a
  [browserlist config](https://github.com/browserslist/browserslist#config-file)
  file, which is automatically picked up by `@babel/preset-env` inside the
  webpack config, if no `browsers` option is supplied.

#### Adding Images
- Images should be compressed and optimized before being committed to the repo
- In order to keep builds fast and reduce dependencies, the front-end build does not contain an image optimization step
- A suggested workflow for those with Adobe Creative Suite is as follows:
  - Export a full-quality PNG from Adobe Illustrator
  - Reexport that PNG from Adobe Fireworks as an 8-bit PNG
  - Run the 8-bit PNG through [ImageOptim](https://imageoptim.com)

#### Templates
- Apps use a jinja template that extends the `base.html`
  template used by the rest of the site.
  This template would reside in `cfgov/jinja2/v1/[project namespace]/index.html`
  or similar (for example, [owning-a-home](https://github.com/cfpb/cfgov-refresh/blob/master/cfgov/jinja2/v1/owning-a-home/explore-rates/index.html)).

!!! note
    A template may support a non-standard browser, like an older IE version,
    by including the required dependencies, polyfills, etc. in its
    template's `{% block css %}` or `{% block javascript scoped %}` blocks.


### TIP: Loading satellite apps
Some projects fit within the cfgov-refresh architecture,
but are not fully incorporated into the project.
These are known as "satellite apps."

Satellite apps are listed in the
[optional-public.txt](https://github.com/cfpb/cfgov-refresh/blob/master/requirements/optional-public.txt)
requirements file.

In addition to the aforementioned list,
[HMDA Explorer](https://github.com/cfpb/hmda-explorer) and
[Rural or Underserved](https://github.com/cfpb/rural-or-underserved-test),
have their own installation requirements.

If using Docker, follow
[these guidelines](https://github.com/cfpb/cfgov-refresh/blob/master/docs/usage.md#develop-satellite-apps).

Otherwise, if not using Docker, follow these guidelines:

1. Build the third-party projects per their directions
1. Stop the web server and return to `cfgov-refresh`
1. Run `pip install -e ../<sibling>` to load the projects' dependencies

!!! note
    Do not install the projects directly into the `cfgov-refresh` directory.
    Clone and install the projects as siblings to `cfgov-refresh`,
    so that they share the same parent directory (`~/Projects` or similar).

### TIP: Working with the templates

#### Front-End Template/Asset Locations

**Templates** that are served by the Django server: `cfgov\jinja2\v1`

**Static assets** prior to processing (minifying etc.): `cfgov\unprocessed`.

!!! note
    After running `gulp build` the site's assets are copied over to `cfgov\static_built`,
    ready to be served by Django.

### TIP: Debugging site performance

When running locally it is possible to enable the
[Django Debug Toolbar](https://django-debug-toolbar.readthedocs.io/en/stable/)
by defining the `ENABLE_DEBUG_TOOLBAR` environment variable:

```sh
$ ENABLE_DEBUG_TOOLBAR=1 ./runserver.sh
```

This tool exposes various useful pieces of information about things like HTTP headers,
Django settings, SQL queries, and template variables. Note that running with the toolbar on
may have an impact on local server performance.

To log database queries to the console when running locally,
define the `ENABLE_SQL_LOGGING` environment variable:

```sh
$ ENABLE_SQL_LOGGING=1 cfgov/manage.py shell
>>> from django.contrib.auth import get_user_model
>>> User = get_user_model()
>>> User.objects.count()
(0.004) SELECT COUNT(*) AS "__count" FROM "auth_user"; args=()
97
```

This will log any database queries (and time taken to execute them)
to the console, and works with any Django code invoked from the shell,
including the server and management commands:

```sh
$ ENABLE_SQL_LOGGING=1 ./runserver.sh
$ ENABLE_SQL_LOGGING=1 cfgov/manage.py some_management_command
```
