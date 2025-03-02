import os

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    if os.path.exists(os.path.join(prereq_dir, 'lib', 'libptscotch.a')):
        SCOTCH_HPC = True
    else:
        SCOTCH_HPC = False

    if SCOTCH_HPC:
        env.set('SCOTCH_ROOT_DIR', prereq_dir)
        env.set('PTSCOTCH_ROOT_DIR', prereq_dir)
        env.set('PTSCOTCHDIR', prereq_dir)
        env.set('SCOTCHDIR', prereq_dir)
        env.set('PTSCOTCH_INCLUDE_DIR',os.path.join(prereq_dir,'include'))
    else:
        env.set('SCOTCHDIR', prereq_dir)
        env.set('SCOTCH_ROOT_DIR', prereq_dir)

def set_nativ_env(env: 'Environ') -> None:
    env.set('SCOTCH_ROOT_DIR', '/usr')
    env.set('SCOTCHDIR', '/usr')
