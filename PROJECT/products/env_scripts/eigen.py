import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('EIGEN_ROOT_DIR', prereq_dir)
    env.set('Eigen3_DIR', prereq_dir)
    root = env.get('EIGEN_ROOT_DIR')
    if platform.system() != "Windows" :
        pass
    else:
        env.prepend('PATH', os.path.join(root, 'include', 'eigen3'))

def set_nativ_env(env: 'Environ') -> None:
    env.set('EIGEN_ROOT_DIR', '/usr')
