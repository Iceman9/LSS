import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    # keep only the first two version numbers
    ver = '.'.join(version.replace('-', '.').split('.')[:2])

    env.set('PVHOME', prereq_dir)
    env.set('VTKHOME', prereq_dir)
    env.set('PVVERSION', ver)

    env.set('PARAVIEW_ROOT_DIR', prereq_dir)
    env.set('PARAVIEW_VERSION', ver)

    set_paraview_env(env, ver)
    set_vtk_env(env, ver)

def set_nativ_env(env: 'Environ') -> None:
    if os.getenv("PVHOME") is None:
        raise Exception("PVHOME is not set")

    if os.getenv("PVVERSION") is None:
        raise Exception("PVVERSION is not set")

    version = env.get("PVVERSION")
    set_paraview_env(env, version)

def set_paraview_env(env: 'Environ', version: str) -> None:
    root = env.get('PVHOME')
    lib_dir = 'lib'
    env.set('ParaView_DIR', os.path.join(root, lib_dir, 'paraview-%s' % version))
    env.prepend('PATH', os.path.join(root, 'bin'))

    if platform.system() == "Windows" :
        parabin = os.path.join(root, 'bin', 'paraview-' + version)
        env.prepend('PATH', parabin)
        env.prepend('PV_PLUGIN_PATH', parabin)
        env.prepend('PYTHONPATH', os.path.join(root,'bin', 'Lib',
                                               'site-packages', 'paraview'))
        env.prepend('PYTHONPATH', os.path.join(root,'bin', 'Lib',
                                               'site-packages', 'vtk'))
        env.prepend('PYTHONPATH', os.path.join(root,'bin', 'Lib',
                                               'site-packages'))
    else:
        paralib = os.path.join(root, lib_dir, 'paraview-' + version)
        env.prepend('PV_PLUGIN_PATH', paralib)
        # bos #26828
        env.prepend('PV_PLUGIN_PATH', os.path.join(paralib, 'plugins'))
        env.prepend('PYTHONPATH', os.path.join(paralib, 'site-packages'))
        env.prepend('PYTHONPATH', os.path.join(paralib, 'site-packages',
                                               'vtk'))
        env.prepend('PATH', os.path.join(root, 'include',
                                         'paraview-' + version))
        env.prepend('LD_LIBRARY_PATH', os.path.join(root, lib_dir,
                                                    'paraview-' + version))
        env.prepend('PYTHONPATH', paralib)

def set_vtk_env(env: 'Environ', version: str) -> None:
    root = env.get('VTKHOME')
    pyver = 'python' + env.get('PYTHON_VERSION')
    lib_dir = 'lib'

    env.set('VTK_ROOT_DIR', root)
    env.set('VTK_DIR', os.path.join(root, lib_dir, 'cmake',
                                    'paraview-' + version))

    if not platform.system() == "Windows" :
        env.prepend('LD_LIBRARY_PATH', os.path.join(root, lib_dir))
        env.prepend('PYTHONPATH', os.path.join(root, lib_dir, pyver,
                                               'site-packages'))


