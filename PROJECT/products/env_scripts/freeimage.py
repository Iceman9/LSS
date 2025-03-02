import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('FREEIMAGEDIR', prereq_dir)
    env.set('FREEIMAGE_ROOT_DIR', prereq_dir)
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    if platform.system() == "Windows" :
        env.prepend('LIBS', os.path.join(prereq_dir, 'lib'))
    else:
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env: 'Environ') -> None:
    pass
