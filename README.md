# Unitex/GramLab Build Automation Service backend [![Build Status](https://travis-ci.org/UnitexGramLab/vinber-backend.svg?branch=master)](https://travis-ci.org/UnitexGramLab/vinber-backend)

> [Unitex/GramLab][unitexgramlab] is an open source, cross-platform, multilingual, lexicon- and grammar-based corpus processing suite

Vinber is a lightweight [build automation](http://en.wikipedia.org/wiki/Build_automation) service (continuous integration + continuous delivery) used to produce the [Unitex/GramLab][unitexgramlab] project releases, including:

 - Creating documentation
   - <a href="https://github.com/UnitexGramLab/unitex-doc-usermanual" target="_blank">User's Manual</a>
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/changes/" target="_blank">Release Notes</a> (work-in-progress)
 - Compiling code
   - <a href="https://github.com/UnitexGramLab/unitex-core" target="_blank">Unitex Core</a>
     - Windows 32-bit
     - Windows 64-bit
     - GNU/Linux Intel
     - GNU/Linux Intel 64-bit
     - OS X (10.7+)
   - <a href="https://github.com/UnitexGramLab/gramlab-ide" target="_blank">GramLab IDE</a>
 - Running <a href="https://github.com/UnitexGramLab/unitex-core-tests" target="_blank">automated tests</a>
   - Memory leaks
   - Non-regression
 - Packaging and signing binaries
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/source/" target="_blank">Source Distribution Package</a>
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/lingua/" target="_blank">Official Linguistic Packages</a>
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/win32/" target="_blank">Windows 32-bit Setup Installer</a>
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/win64/" target="_blank">Windows 64-bit Setup Installer</a>
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/linux-i686/" target="_blank">GNU/Linux i686 Setup Installer</a>
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/linux-x86_64/" target="_blank">GNU/Linux x86_64 Setup Installer</a>
   - <a href="http://unitex.univ-mlv.fr/releases/latest-beta/osx/" target="_blank">OS X Setup Installer</a>
 - Deploying
   - Releases page update: <a href="http://www-igm.univ-mlv.fr/~unitex/index.php?page=3&html=latest-beta.html" target="_blank">Old-style page</a>, <a href="http://unitex.univ-mlv.fr/releases" target="_blank">New page</a>
   - <a href="http://unitex.univ-mlv.fr" target="_blank">Static website update</a>

## Types of interaction

Vinber support 3 kinds of interaction:

  - [Scheduled][nightly] to produce nightly releases.
  - [Triggered][commit] on every commit done to the [Unitex/GramLab repositories][repos].
  - <a href="http://unitex.univ-mlv.fr/v6/#bundle=nightly&action=rebuild" target="_blank">On-Demand Request</a> using a webform.

## Tutorial trip

A short guided tour about using the frontend is <a href="http://unitex.univ-mlv.fr/v6/#bundle=nightly&q=latest&action=help" target="_blank">available here</a>.

## Badges

The badges from [Vinber][vinber] shows the status of the [Unitex/GramLab][unitexgramlab] builds. Badges are powered by [shields.io](http://shields.io/) using an intermediate processing/caching layer.

### Latest Nightly Release

[![Latest Nightly Release](http://unitex.univ-mlv.fr/v6/badge/nightly/latest-deployed.svg?subject=product.name&status=product.version.string)][deployed] [![Latest Nightly Release](http://unitex.univ-mlv.fr/v6/badge/nightly/latest-deployed.svg?status=build.started&label=Latest%20Built&color=5CB85C)][deployed]

### Latest Nightly Build

[![Nightly Build](http://unitex.univ-mlv.fr/v6/badge/nightly/latest.svg?subject=product.name&status=product.version.string)][nightly] [![Nightly Build](http://unitex.univ-mlv.fr/v6/badge/nightly/latest.svg?status=build.status)][nightly]

## Contributing

> Vinber code is ShellCheck-compliant. See http://www.shellcheck.net/about.html for information about how to run ShellCheck locally.

We welcome everyone to contribute to improve this project. Below are some of the things that you can do to contribute:

-  [Fork us](https://github.com/UnitexGramLab/vinber-backend/fork) and [request a pull](https://github.com/UnitexGramLab/vinber-backend/pulls) to the [master branch](https://github.com/UnitexGramLab/vinber-backend/tree/master).
-  Submit [bug reports or feature requests](https://github.com/UnitexGramLab/vinber-backend/issues)

## License

<a href="/LICENSE"><img height="48" align="left" src="http://www.gnu.org/graphics/empowered-by-gnu.svg"></a>

This program is licensed under the [GNU Lesser General Public License version 2.1](/LICENSE). Contact unitex-devel@univ-mlv.fr for further inquiries.

--

Copyright (C) 2020 Université Paris-Est Marne-la-Vallée

[repos]:   https://github.com/unitexgramlab
[unitexgramlab]:  http://unitexgramlab.org
[vinber]:  http://unitex.univ-mlv.fr/v6
[nightly]: http://unitex.univ-mlv.fr/v6/#bundle=nightly&q=latest
[commit]:  http://unitex.univ-mlv.fr/v6/#bundle=commit&q=latest
[deployed]:  http://unitex.univ-mlv.fr/v6/#bundle=nightly&q=latest-deployed
[request]: http://unitex.univ-mlv.fr/v6/#bundle=nightly&action=rebuild
[tour]:    http://unitex.univ-mlv.fr/v6/#bundle=nightly&q=buils&action=help
