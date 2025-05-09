import os.path
import platform

import typing

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    if platform.system() == "Windows" :

        _min_maj = 'boost-' + '_'.join(version.split('.')[0:2])

        prereq_dir = prereq_dir.replace('/','\\')
        env.set('BOOSTDIR', prereq_dir)
        env.set('BOOST_ROOT_DIR', prereq_dir)
        env.set('BOOST_ROOT', prereq_dir)
        env.set('BOOST_INCLUDE_DIR',os.path.join(prereq_dir,'include',
                                                 _min_maj))
        env.set('Boost_INCLUDE_DIR',os.path.join(prereq_dir,'include',
                                                 _min_maj))
        env.set('BOOST_INCLUDEDIR', os.path.join(prereq_dir,'include',
                                                 _min_maj))
        env.set('BOOST_VERSION', version)
        env.set('BOOST_VERSION_MajorMinor', '.'.join(version.split('.')[0:2]))
        env.set('BOOST_LIBRARY_DIR',os.path.join(prereq_dir,'lib'))
        env.set('BOOST_LIBRARYDIR',os.path.join(prereq_dir,'lib'))
        env.prepend('PATH', os.path.join(prereq_dir, 'lib'))
    else :
        env.set('BOOSTDIR', prereq_dir)
        env.set('BOOST_ROOT_DIR', prereq_dir)
        env.prepend('PATH', os.path.join(prereq_dir, 'include'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('BOOSTDIR', '/usr')
    env.set('BOOST_ROOT_DIR', '/usr')
