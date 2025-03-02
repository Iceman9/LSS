import os.path

def set_env(env: 'Envrion', prereq_dir: str, version: str) -> None:
    env.set('ISPC_ROOT_DIR', prereq_dir)    # update for cmake
    env.prepend('PATH', os.path.join(prereq_dir,'bin'))    
