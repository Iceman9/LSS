import os.path, platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
  env.set('RKCOMMON_ROOT_DIR', prereq_dir)
  env.set('rkcommon_DIR', os.path.join(prereq_dir, 'lib','cmake',
                                       f'rkcommon-{version}'))
  if platform.system() == "Windows" :
      env.prepend('PATH', os.path.join(prereq_dir,'bin'))
  else:
      env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir,'lib'))

def set_nativ_env(env: 'Environ') -> None:
    pass

