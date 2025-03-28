import platform
import os.path
import os

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('OPENBLAS_ROOT_DIR', prereq_dir)
    env.prepend('PKG_CONFIG_PATH', os.path.join(prereq_dir, 'lib',
                                                'pkgconfig'))

    if not platform.system() == "Windows" :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
    else:
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
