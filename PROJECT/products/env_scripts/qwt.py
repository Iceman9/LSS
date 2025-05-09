import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('QWTHOME', prereq_dir)
    env.set('QWT_ROOT_DIR', prereq_dir)

    if platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'lib'))
    else:
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('QWTHOME', '/usr')
    env.set('QWT_ROOT_DIR', '/usr')
