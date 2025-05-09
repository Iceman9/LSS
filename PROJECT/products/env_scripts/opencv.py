import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('OPENCV_ROOT_DIR', prereq_dir)
    env.set('OPENCV_HOME', prereq_dir)
    env.set('OPENCV_DIR', prereq_dir)
    env.set('OpenCV_DIR', prereq_dir)
    env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
    if not platform.system() == "Windows" :
        env.prepend('LD_LIBRARY_PATH', os.path.join(prereq_dir, 'lib'))
        pyver = 'python' + env.get('PYTHON_VERSION')
        env.prepend('PYTHONPATH', os.path.join(prereq_dir, 'lib', pyver, 
                                               'site-packages'))
    else:
        env.prepend('PATH', os.path.join(prereq_dir, 'bin'))
        env.prepend('PATH', os.path.join(prereq_dir, 'lib'))
        env.set('OpenCV_INCLUDE_DIRS', os.path.join(prereq_dir, 'include') + 
                                       ';' + 
                                       os.path.join(prereq_dir, 'include',
                                                    'opencv') + ';' + 
                                       os.path.join(prereq_dir, 'include',
                                                    'opencv2'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('OPENCV_ROOT_DIR', '/usr')
    env.set('OPENCV_HOME', '/usr')
