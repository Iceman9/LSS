import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('MATPLOTLIB_ROOT_DIR', prereq_dir)
    if not platform.system() == "Windows" :
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 
                                              'site-packages'))
    else:
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'Lib',
                                               'site-packages'))

    #FOR THE FILE CONFIG MATPLOTLIBRC should not point to read-only directory!
    # env.set('MPLCONFIGDIR', prereq_dir)

def set_nativ_env(env: 'Environ') -> None:
    pass
