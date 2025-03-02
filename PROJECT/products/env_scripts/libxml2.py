import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('LIBXML_DIR', prereq_dir)
    env.set('LIBXML2_ROOT_DIR', prereq_dir)

    env.set('LIBXML2_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    env.prepend('PKG_CONFIG_PATH', os.path.join(prereq_dir, 'lib', 'pkgconfig'))
    if not platform.system() == "Windows" :
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env: 'Environ') -> None:
    pass
