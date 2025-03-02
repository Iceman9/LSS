import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
  env.set('PLANEGCS_ROOT_DIR', prereq_dir)
  root = env.get('PLANEGCS_ROOT_DIR')
  if platform.system() == "Windows" :
      env.prepend('PATH',os.path.join(root, 'lib'))
  else:
      env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))

def set_nativ_env(env: 'Environ') -> None:
    pass