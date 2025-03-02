# LSS

## Introduction

LSS is a project for creating a SALOME application variant where only the basic
modules: ``SHAPER, GEOM, SMESH, ParaVis and FIELDS`` are packaged. Or in other
words, only the CAD, mesh and visualization modules are contained.

The application is configured to be built, ``at least`` on the latest
Linux/Debian OS (at the time this is written). Apart from that the packages
Python, SciPy, NumPy, (and matplotlib and ...) are updated to the newest
version in order to "reap" (or not) the benefits of the releases.

Statistical (openturns) or geospatial packages are **not** included due to
lack of use (from my perspective) or interest and subsequently there is a lack
of interest in trying to maintain those packages.

## Installation

### Supported platforms

 - Linux / Debian 12

### Initializing SAT tools

Git clone the https://github.com/Iceman9/sat repository which adds some
features to the standard SAT tools (such as downloading source code directly
from the release pages of the repository sites).

```bash
git clone https://github.com/Iceman9/sat
```

Then openning a terminal in navigating to the directory of LSS run the
following commands to initiate the SAT tools::`


```bash
# Create the symbolic link file to the SAT tools
ln -s /path/to/salomeTools/sat sat
# Set the project file
./sat init --add-project ${PWD}/PROJECT/project.pyconf
# Set the location of LOG files
./sat init -l ${PWD}/LOGS
# Set the location of archives
./sat init -a ${PWD}/ARCHIVES # Location of archive files
```

### Preparing source

To prepare the sources (which are fetched either from web links
or FTPs) run

```bash
./sat prepare lss
```

The packages openmpi and system_packages will normaly tell you which packages
you require in order to build the software


### Building the software


```bash
./sat compile lss
```

### Creating the launcher

```bash
./sat launcher lss
ln -s INSTALL/SALOME/salom lss # Or whatever name instead of 'lss'
```

### Launching the software

```bash
./lss # or whatever name you used to create the launcher
```