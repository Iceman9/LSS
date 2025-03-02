import os.path, platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('HDF5HOME', prereq_dir)
    env.set('HDF5_DIR', prereq_dir)
    env.set('HDF5_ROOT', prereq_dir)
    env.set('HDF5_ROOT_DIR', prereq_dir)

    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

    env.set('HDF5_LIBRARIES', os.path.join(prereq_dir, 'lib'))
    env.set('HDF5_INCLUDE_DIRS', os.path.join(prereq_dir, 'include'))
    # For NETCDF...
    env.set('HDF5_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))
    env.set('HDF5_VERSION', version)

    if not platform.system() == "Windows" :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('HDF5HOME', '/usr')
    env.set('HDF5_ROOT', '/usr')
    env.set('HDF5_ROOT_DIR', '/usr')    # update for cmake
