import os
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.set('PYQT_SIPS_DIR', prereq_dir)

    env.set('SIP_INCLUDE_DIR', os.path.join(prereq_dir, 'include'))
    if platform.system() == "Windows" :
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'Lib', 'site-packages'))
    else:
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 'site-packages'))
    env.prepend('CPLUS_INCLUDE_PATH', os.path.join(prereq_dir, 'include'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('SIPDIR', '/usr')
    env.set('SIP_ROOT_DIR','/usr')
