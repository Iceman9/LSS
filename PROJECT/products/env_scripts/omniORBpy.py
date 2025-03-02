def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    omniorb_root_dir = env.get('OMNIORB_ROOT_DIR')
    env.set('OMNIORBPY_ROOT_DIR', omniorb_root_dir)

def set_nativ_env(env: 'Environ') -> None:
    env.set('OMNIORBPY_ROOT_DIR',"/usr")
