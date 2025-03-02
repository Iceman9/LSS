import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('GMSHHOME', prereq_dir)
    env.set('GMSH_ROOT_DIR', prereq_dir)
    if platform.system() == "Windows" :
      env.append('PATH',os.path.join(prereq_dir,'bin'))
      env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'bin'))
    else:
      env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
      env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib'))


def set_nativ_env(env: 'Environ') -> None:
    env.set('GMSH_ROOT_DIR', '/usr')
