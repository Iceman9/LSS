import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('ZLIB_ROOT_DIR', prereq_dir)
    if platform.system() == "Windows" :
        env.set('ZLIB_DIR', prereq_dir)
        env.set('ZLIB_BIN', os.path.join(prereq_dir, 'bin'))
        env.set('ZLIB_LIBRARY', os.path.join(prereq_dir, 'bin'))
        env.set('ZLIB_LIBRARIES', os.path.join(prereq_dir, 'bin'))
        env.set('ZLIB_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))
        env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
        env.prepend('LIB', os.path.join(prereq_dir, 'bin'))
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    else:
        pass

def set_nativ_env(env: 'Environ') -> None:
    pass
