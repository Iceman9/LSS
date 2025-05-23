import os.path, platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('CGNS_ROOT_DIR', prereq_dir)
    env.set('CGNS_INCLUDE_DIR',os.path.join(prereq_dir,'include'))
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    if platform.system() == "Windows" :
        env.set('CGNS_LIBRARY',os.path.join(prereq_dir,'lib','libcgnsdll.lib'))
    else:
        env.set('CGNS_LIBRARY',os.path.join(prereq_dir,'lib','libcgns.so'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('CGNS_ROOT_DIR', '/usr')
