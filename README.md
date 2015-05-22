## Unitex/GramLab Build Automation Service backend [![Build Status](https://travis-ci.org/UnitexGramLab/vinber-backend.svg?branch=master)](https://travis-ci.org/UnitexGramLab/vinber-backend)

> [Unitex/GramLab][unitex] is an open source, cross-platform, multilingual, lexicon- and grammar-based corpus processing suite

Vinber is a lightweight [build automation](http://en.wikipedia.org/wiki/Build_automation) service (continuous integration + continuous delivery) used to produce the [Unitex/GramLab][unitex] project releases, including:

 - Creating documentation
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/man/" target="_blank">User's Manual</a>
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/changes/" target="_blank">Release Notes</a> (work-in-progress)
 - Compiling code
   - Core Components
   - Integrate Development Environments (Classic and GramLab)
 - Running automated tests
   - Memory leaks
   - Non-regression
 - Packaging and signing binaries
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/source/" target="_blank">Source Distribution Package</a>
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/lingua/" target="_blank">Official Linguistic Packages</a>
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/win32/" target="_blank">Windows Setup Installer</a>
   - OS X Setup Installer (work-in-progress)
 - Deploying
   - <a href="http://unitex.univ-mlv.fr/releases/" target="_blank">Releases page update</a>
   - <a href="http://unitex.univ-mlv.fr" target="_blank">Static website update</a>

### Types of interaction

Vinber support 3 kinds of interaction:

  - [Scheduled][nightly] to produce nightly releases.
  - [Triggered][commit] on every commit done to the [Unitex/GramLab repositories][repos].
  - <a href="http://unitex.univ-mlv.fr/v6/#bundle=nightly&action=rebuild" target="_blank">On-Demand Request</a> using a webform.

### Tutorial trip

A short guided tour about using the frontend is <a href="http://unitex.univ-mlv.fr/v6/#bundle=nightly&q=latest&action=help" target="_blank">available here</a>.

### Badges

The badges from [Vinber][vinber] shows the status of the [Unitex/GramLab][unitex] builds. Badges are powered by [shields.io](http://shields.io/) using an intermediate processing/caching layer.

#### Nightly Status

[![Nightly Release](http://unitex.univ-mlv.fr/v6/badge/nightly/latest.svg?subject=product.name&status=product.version.string)][nightly] [![Nightly Status](http://unitex.univ-mlv.fr/v6/badge/nightly/latest.svg?status=build.status)][nightly]

#### Last Commit Status

[![Last Commit Release](http://unitex.univ-mlv.fr/v6/badge/commit/latest.svg?subject=product.name&status=product.version.string)][commit] [![Last Commit Status](http://unitex.univ-mlv.fr/v6/badge/commit/latest.svg?status=build.status)][commit]

### Contributing

> Vinber code is ShellCheck-compliant. See http://www.shellcheck.net/about.html for information about how to run ShellCheck locally.

We welcome everyone to contribute to improve this project. Below are some of the things that you can do to contribute:

-  [Fork us](https://github.com/UnitexGramLab/vinber-backend/fork) and [request a pull](https://github.com/UnitexGramLab/vinber-backend/pulls) to the [develop branch](https://github.com/UnitexGramLab/vinber-backend/tree/develop).
-  Submit [bug reports or feature requests](https://github.com/UnitexGramLab/vinber-backend/issues)

### Licensing information
This program is licensed under the [GNU Lesser General Public License version 2.1](/LICENSE). Contact unitex-devel@univ-mlv.fr for further inquiries.

--

Copyright (C) 2014-2015 Université Paris-Est Marne-la-Vallée

[repos]:   https://github.com/unitexgramlab
[unitex]:  http://unitexgramlab.org
[vinber]:  http://unitex.univ-mlv.fr/v6
[nightly]: http://unitex.univ-mlv.fr/v6/#bundle=nightly&q=latest
[commit]:  http://unitex.univ-mlv.fr/v6/#bundle=commit&q=latest
[request]: http://unitex.univ-mlv.fr/v6/#bundle=nightly&action=rebuild
[tour]:    http://unitex.univ-mlv.fr/v6/#bundle=nightly&q=buils&action=help
