import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('QTDIR', prereq_dir)

    version_table = version.split('.')
    if version_table[0] == '5':
        env.set('QT5_ROOT_DIR', prereq_dir)
        env.prepend('QT_PLUGIN_PATH', os.path.join(prereq_dir, 'plugins'))
        env.prepend('QT_QPA_PLATFORM_PLUGIN_PATH', os.path.join(prereq_dir,
                                                                'plugins'))
    else:
        env.set('QT4_ROOT_DIR', prereq_dir)

    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))

    if platform.system() == "Windows" :
        env.prepend('LIB', os.path.join(prereq_dir, 'lib'))
    else :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))

def set_nativ_env(env: 'Environ') -> None:
    qt_lib_dir='/usr/lib64'
    try:
        import distro
        if any(distribution in distro.name().lower() for distribution in ["debian", "ubuntu"]) :
            qt_lib_dir='/usr/lib/x86_64-linux-gnu'
    except:
        pass
    env.set('QT5_ROOT_DIR', '/usr')
    env.set('Qt5Core_DIR', os.path.join(qt_lib_dir, 'cmake/Qt5Core'))
    env.set('Qt5Gui_DIR', os.path.join(qt_lib_dir, 'cmake/Qt5Gui'))
    env.set('Qt5Widgets_DIR', os.path.join(qt_lib_dir, 'cmake/Qt5Widgets'))
    env.set('Qt5Network_DIR', os.path.join(qt_lib_dir, 'cmake/Qt5Network'))
    env.set('Qt5Xml_DIR', os.path.join(qt_lib_dir, 'cmake/Qt5Xml'))
    env.set('Qt5OpenGL_DIR', os.path.join(qt_lib_dir, 'cmake/Qt5OpenGL'))
    env.set('Qt5PrintSupport_DIR', os.path.join(qt_lib_dir,
                                                'cmake/Qt5PrintSupport'))
    env.set('Qt5Help_DIR', os.path.join(qt_lib_dir, 'cmake/Qt5Help'))
    env.set('Qt5Test_DIR', os.path.join(qt_lib_dir, 'cmake/Qt5Test'))
    env.set('Qt5X11Extras_DIR', os.path.join(qt_lib_dir, 'cmake/Qt5X11Extras'))

    env.set('QT_QPA_PLATFORM_PLUGIN_PATH', os.path.join(qt_lib_dir,
                                                        'qt5/plugins'))
