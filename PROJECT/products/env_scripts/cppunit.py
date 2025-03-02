import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('CPPUNITHOME', prereq_dir)
    env.set('CPPUNIT_ROOT', prereq_dir)
    env.set('CPPUNIT_ROOT_DIR', prereq_dir) # update for cmake
    env.set('CPPUNITINSTDIR', prereq_dir)

    if platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'lib'))
    else :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('CPPUNIT_ROOT_DIR', '/usr') # update for cmake
    env.set('CPPUNITHOME','/usr')
    env.set('CPPUNIT_ROOT','/usr')
