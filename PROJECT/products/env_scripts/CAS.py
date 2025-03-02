import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('CASROOT', prereq_dir)

    env.set('CAS_ROOT_DIR', prereq_dir)
    env.set('OPENCASCADE_ROOT_DIR', prereq_dir)
    env.prepend('PATH', prereq_dir)

    share_dir = os.path.join(prereq_dir, 'share', 'opencascade',
                                   'resources')

    if platform.system()=="Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'win64', 'vc14' ,'bin'))
    else :
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

        env.set('CSF_ShadersDirectory', os.path.join(share_dir, 'Shaders'))
        env.set('CSF_UnitsLexicon', os.path.join(share_dir, 'UnitsAPI',
                                                 'Lexi_Expr.dat'))
        env.set('CSF_UnitsDefinition', os.path.join(share_dir, 'UnitsAPI',
                                                    'Units.dat'))
        env.set('CSF_SHMessage', os.path.join(share_dir, 'SHMessage'))
        env.set('CSF_XSMessage', os.path.join(share_dir, 'XSMessage'))
        env.set('CSF_MDTVTexturesDirectory', os.path.join(share_dir,
                                                          'Textures'))
        env.set('MMGT_REENTRANT', '1')
        env.set('CFS_StandardDefaults', os.path.join(share_dir, 'StdResource'))
        env.set('CSF_PluginDefaults', os.path.join(share_dir, 'StdResource'))

def set_nativ_env(env: 'Environ') -> None:
    pass

