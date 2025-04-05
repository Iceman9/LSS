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

#### Linux - Debian 12

Dependencies are covered when system_packages.pyconf gets checked. If any
packages are missing you will receive a list of packages to install.

#### Windows 10
 - [Visual studio 17 2022 build tools (C/C++/CMake)](https://visualstudio.microsoft.com/downloads)
 - [Ninja](https://ninja-build.org)
 - [Cygwin](https://www.cygwin.com)
 - [Intel OneAPI Fortran standalone](https://www.intel.com)
 - [Git for windows](https://git-scm.com)

You will compile LSS using Intel OneAPI developer command prompt, which has the
Visual Studio 2022 environment setup and the Intel Fortran compiler setup.
Ensure that during installation of Intel OneAPI Fortran standalone compiler you
click to have compatiblity with visual studio 2022.

Use ``chocolatey`` to install packages like Ninja, etc...

When installing Cygwin check if the CYGWIN_ROOT_DIR is specified correctly to
the cygwin installation dir inside ``PROJECT/applications/lss.pyconf``. Cygwin
is only needed to build OmniORB as that requires the GNU Make and if trying to
use Make.exe installed via chocolatey, you will see many Make syntax error that
are not easy to fix, or at all.

### Initializing SAT tools

Git clone the https://github.com/Iceman9/sat repository which adds some
features to the standard SAT tools.

```bash
git clone https://github.com/Iceman9/sat
```

Then openning a terminal in navigating to the directory of LSS run the
following commands to initiate the SAT tools:

```bash
# Create the symbolic link file to the SAT tools
ln -s /path/to/salomeTools/sat sat
# Set the project file
./sat init --add-project ${PWD}/PROJECT/project.pyconf
# Set the location of LOG files
./sat init -l ${PWD}/LOGS
# Set the location of archives
./sat init -a ${PWD}/ARCHIVES # Location of archive files
# Set the workdir to LSS directory
./sat init -w ${PWD}
```

On Windows system call sat as:

```cmd
python C:\path\to\sat ...
```

and use **%CD%** instead of **${PWD}**.

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

Wait a few hours.

### Creating the launcher

```bash
./sat launcher lss
```

### Launching the software

```bash
./lss # or whatever name you used to create the launcher
```

and on Windows:

```cmd
python lss
```