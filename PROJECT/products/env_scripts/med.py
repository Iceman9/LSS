import os.path, platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('MED3HOME', prereq_dir)
    env.set('MED2HOME', prereq_dir)
    env.set('MEDFILE_ROOT_DIR', prereq_dir)    # update for cmake

    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

    if platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'lib'))
    else :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 
                                               'site-packages'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('MEDFILE_ROOT_DIR', '/usr')    # update for cmake
    env.set('MED3HOME', '/usr')
    env.set('MED2HOME', '/usr')
