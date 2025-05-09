import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('METISDIR', prereq_dir)
    env.set('METIS_ROOT_DIR', prereq_dir)  # update for cmake

    env.set('METIS_BIN', os.path.join(prereq_dir, 'bin'))
    env.set('METIS_LIBRARY', os.path.join(prereq_dir, 'lib'))
    env.set('METIS_LIBRARIES', os.path.join(prereq_dir, 'lib'))
    env.set('METIS_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))

    if platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('METISDIR', '/usr')
    env.set('METIS_ROOT_DIR', '/usr')  # update for cmake
