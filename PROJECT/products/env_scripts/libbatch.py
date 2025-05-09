import os
import platform

def set_env(env: 'Environ', product_dir: str, version: str) -> None:
    env.set('LIBBATCH_ROOT_DIR', product_dir)

    pyver = 'python' + env.get('PYTHON_VERSION')

    if platform.system() == "Windows" :
        env.prepend('PATH', os.path.join(product_dir, 'lib'))
        env.prepend('PATH', os.path.join(product_dir, 'lib', pyver))
        env.prepend('PYTHONPATH', os.path.join(product_dir, 'lib', pyver))
    else:
        env.prepend('LD_LIBRARY_PATH', os.path.join(product_dir, 'lib'))
        env.prepend('LD_LIBRARY_PATH', os.path.join(product_dir, 'lib', pyver))

def set_nativ_env(env: 'Environ') -> None:
    pass
