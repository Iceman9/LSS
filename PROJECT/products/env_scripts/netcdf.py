import os.path

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('NETCDF_ROOT_DIR', prereq_dir)
    env.set('NETCDF_INSTALL_DIR', prereq_dir)
    env.set('NETCDF_VERSION',version)
    env.prepend('PATH', os.path.join(prereq_dir,'bin'))
    env.prepend('LD_LIBRARY_PATH',os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env: 'Environ') -> None:
    pass
