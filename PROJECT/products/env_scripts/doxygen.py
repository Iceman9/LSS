import os.path

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('DOXYGENDIR', prereq_dir)
    env.set('DOXYGEN_ROOT_DIR', prereq_dir)
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('DOXYGENDIR', '/usr')
    env.set('DOXYGEN_ROOT_DIR', '/usr')
