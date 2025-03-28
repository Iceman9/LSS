import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    pyver = 'python' + env.get('PYTHON_VERSION')
    env.set('SIPDIR', prereq_dir)
    env.set('SIP_ROOT_DIR', prereq_dir)
    if not platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib', pyver,
                                                    'site-packages'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver,
                                               'site-packages'))
        env.prepend('CPLUS_INCLUDE_PATH', os.path.join(prereq_dir, 'include',
                                                       pyver))
    else:
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'Lib',
                                               'site-packages'))
        env.prepend('PATH', os.path.join(prereq_dir, 'Scripts'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('SIPDIR', '/usr')
    env.set('SIP_ROOT_DIR','/usr')
