import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('TK_ROOT_DIR', env.get('TCL_ROOT_DIR'))
    env.set('TKHOME', env.get('TCL_ROOT_DIR'))
    root = env.get('TKHOME')

    env.prepend('PATH', os.path.join(root, 'bin'))

    l = []
    l.append(os.path.join(root, 'lib'))
    l.append(os.path.join(root, 'lib', 'tk' + env.get('TCL_SHORT_VERSION')))
    env.prepend('TKLIBPATH', l, sep=" ")
    env.set('TK_LIBRARY',os.path.join(root, 'lib',
                                      'tk' + env.get('TCL_SHORT_VERSION')))

    if not platform.system() == "Windows" :
        env.prepend('LD_LIBRARY_PATH', os.path.join(root, 'lib'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('TK_ROOT_DIR', '/usr')   # update for cmake
    env.set('TKHOME', '/usr')
