import os.path

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('CATALYST_ROOT_DIR', prereq_dir)
    env.set('catalyst_DIR', os.path.join(prereq_dir, 'lib', 'cmake', 
                                         f'catalyst-{version}'))  
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib', 'catalyst'))  
  

    major_minor = ".".join(version.split(".")[:-1])
    env.prepend('CMAKE_PREFIX_PATH', os.path.join(prereq_dir, 'lib', 'cmake', 
                                                  f'catalyst-{major_minor}'))

def set_nativ_env(env: 'Environ') -> None:
    pass
