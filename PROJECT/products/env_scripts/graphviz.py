import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('GRAPHVIZROOT', prereq_dir)
    env.set('GRAPHVIZ_ROOT_DIR', prereq_dir)

    if platform.system() == "Windows" :
        env.prepend('INCLUDE', os.path.join(prereq_dir, 'include'))
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('LIB', os.path.join(prereq_dir, 'bin'))
        env.set('DOT_PATH',os.path.join(prereq_dir, 'bin'))
    else :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('PATH', os.path.join(prereq_dir, 'include', 'graphviz'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib',
                                                    'graphviz'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('GRAPHVIZROOT', '/usr')
    env.set('GRAPHVIZ_ROOT_DIR', '/usr')
