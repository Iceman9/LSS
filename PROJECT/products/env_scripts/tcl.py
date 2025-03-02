import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('TCL_ROOT_DIR', prereq_dir) # update for cmake
    env.set('TCLHOME', prereq_dir)

    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
    env.set('TCL_SHORT_VERSION', version[:version.rfind('.')])

    l = []
    l.append(os.path.join(prereq_dir, 'lib'))
    l.append(os.path.join(prereq_dir, 'lib',
                          'tcl' + version[:version.rfind('.')]))
    env.prepend('TCLLIBPATH', l, sep=" ")
    env.set('TCL_LIBRARY',os.path.join(prereq_dir, 'lib',
        'tcl' + version[:version.rfind('.')]))

    if not platform.system() == "Windows" :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('TCL_ROOT_DIR', '/usr') # update for cmake
    env.set('TCLHOME', '/usr')
