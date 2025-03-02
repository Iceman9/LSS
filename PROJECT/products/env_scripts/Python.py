import os.path, platform

def set_env(env: 'Environ',prereq_dir: str,version: str) -> None:
    env.set('PYTHONHOME', prereq_dir)
    env.set('PYTHON_ROOT_DIR', prereq_dir)

    # keep only the first two version numbers without leading 'v'
    version = version.replace('v', '')
    version = '.'.join(version.replace('-', '.').split('.')[:2])
    env.set('PYTHON_VERSION', version)

    env.prepend('PATH', prereq_dir)

    if platform.system() == "Windows" :
        env.set('PYTHON_INCLUDE', os.path.join(prereq_dir, 'include'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib'))
        env.set('PYTHON_SITE_PACKAGES',os.path.join(prereq_dir, 'lib',
                                                    'site-packages'))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib',
                                              'site-packages'))
        env.set('PYTHONBIN', os.path.join(prereq_dir, 'python.exe'))
        env.prepend('PATH', os.path.join(prereq_dir, 'libs'))
        env.prepend('PATH', os.path.join(prereq_dir, 'Scripts'))
    else :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        env.set('PYTHON_INCLUDE', os.path.join(prereq_dir, 'include',
                                               'python' + version))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib',
                                               'python' + version))
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib',
                                               'python' + version,
                                               'site-packages'))
        env.set('PYTHONBIN', os.path.join(prereq_dir, 'bin','python3'))
        env.set('Python3_EXECUTABLE', os.path.join(prereq_dir, 'bin',
                                                   "python3"))

def set_nativ_env(env):
    import sys, sysconfig
    env.set('PYTHON_ROOT_DIR', '/usr')
    env.set('PYTHON_INCLUDE',  "%s" % sysconfig.get_paths()['include'])
    env.set('PYTHON_VERSION', "%s.%s" % sys.version_info[0:2])
    env.set('PYTHONBIN','/usr/bin/python3')
