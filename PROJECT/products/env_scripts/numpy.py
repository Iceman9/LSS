import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    if not platform.system() == "Windows" :
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.set('NUMPY_INCLUDE_DIR',os.path.join(prereq_dir, 
                                                'lib', pyver, 'site-packages'))
        env.set('NUMPY_INCLUDE_DIR2',os.path.join(prereq_dir, 
                                                  'lib', pyver, 
                                                  'site-packages','numpy',
                                                  'core','include'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 
                                               'site-packages'))
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    else:
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.set('NUMPY_INCLUDE_DIR',os.path.join(prereq_dir,
                                                'Lib', 'site-packages'))
        env.set('NUMPY_INCLUDE_DIR2',os.path.join(prereq_dir,
                                                  'Lib', 'site-packages','numpy',
                                                  '_core', 'include', 'numpy'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'Scripts'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'Lib',
                                               'site-packages'))
        env.prepend('PATH', os.path.join(prereq_dir, 'Scripts'))

def set_nativ_env(env: 'Environ') -> None:
    pass
