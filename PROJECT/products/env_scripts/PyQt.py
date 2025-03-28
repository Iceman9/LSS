import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('PYQTDIR', prereq_dir)
    version_table = version.split('.')
    if version_table[0] == '5':
        env.set('PYQT5_ROOT_DIR', prereq_dir)
    else:
        env.set('PYQT4_ROOT_DIR', prereq_dir)
    env.prepend('PYTHONPATH', prereq_dir)
    pyver = 'python' + env.get('PYTHON_VERSION')
    if not platform.system() == "Windows" :
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver,
                                               'site-packages'))
        env.set('PYUIC5',os.path.join(prereq_dir, 'bin','pyuic5'))
        env.prepend('LD_LIBRARY_PATH', prereq_dir)
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    else:
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'Lib'))
        env.prepend('PATH', os.path.join(prereq_dir, 'Scripts'))
        env.set('PYUIC5',os.path.join(prereq_dir, 'Scripts','pyuic5.bat'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('PYQT5_ROOT_DIR', '/usr')
