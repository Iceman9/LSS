import os.path
import platform

def set_env(env: 'Environ', prereq_dir: str, version: str) -> None:
    env.set('CASROOT', prereq_dir)

    env.set('CAS_ROOT_DIR', prereq_dir)
    env.set('OPENCASCADE_ROOT_DIR', prereq_dir)
    env.prepend('PATH', prereq_dir)

    env.set('MMGT_REENTRANT', '1')
    if platform.system()=="Windows" :
        env.prepend('PATH', os.path.join(prereq_dir, 'win64', 'vc14' ,'bin'))
        env.set("CSF_OCCTBinPath",           os.path.join(prereq_dir,  "win64",
                                                          "vc14", "bin"))
        env.set("CSF_OCCTLibPath",           os.path.join(prereq_dir,  "win64",
                                                          "vc14", "lib"))
        env.set("CSF_OCCTIncludePath",       os.path.join(prereq_dir,  "inc"))
        env.set("CSF_OCCTResourcePath",      os.path.join(prereq_dir,  "src"))
        env.set("CSF_OCCTDataPath",          os.path.join(prereq_dir,  "data"))
        env.set("CSF_OCCTSamplesPath",       os.path.join(prereq_dir,
                                                          "samples"))
        env.set("CSF_OCCTTestsPath",         os.path.join(prereq_dir,
                                                          "tests"))
        env.set("CSF_OCCTDocPath",           os.path.join(prereq_dir,  "doc"))
        env.set("CSF_SHMessage",             os.path.join(prereq_dir,  "src",
                                                          "SHMessage"))
        env.set("CSF_MDTVTexturesDirectory", os.path.join(prereq_dir,  "src",
                                                          "Textures"))
        env.set("CSF_ShadersDirectory",      os.path.join(prereq_dir,  "src",
                                                          "Shaders"))
        env.set("CSF_XSMessage",             os.path.join(prereq_dir,  "src",
                                                          "XSMessage"))
        env.set("CSF_TObjMessage",           os.path.join(prereq_dir,  "src",
                                                          "TObj"))
        env.set("CSF_StandardDefaults",      os.path.join(prereq_dir,  "src",
                                                          "StdResource"))
        env.set("CSF_PluginDefaults",        os.path.join(prereq_dir,  "src",
                                                          "StdResource"))
        env.set("CSF_XCAFDefaults",          os.path.join(prereq_dir,  "src",
                                                          "StdResource"))
        env.set("CSF_TObjDefaults",          os.path.join(prereq_dir,  "src",
                                                          "StdResource"))
        env.set("CSF_StandardLiteDefaults",  os.path.join(prereq_dir,  "src",
                                                          "StdResource"))
        env.set("CSF_IGESDefaults",          os.path.join(prereq_dir,  "src",
                                                          "XSTEPResource"))
        env.set("CSF_STEPDefaults",          os.path.join(prereq_dir,  "src",
                                                          "XSTEPResource"))
        env.set("CSF_XmlOcafResource",       os.path.join(prereq_dir,  "src",
                                                          "XmlOcafResource"))
        env.set("CSF_MIGRATION_TYPES",       os.path.join(prereq_dir,  "src",
                                                          "StdResource",
                                                          "MigrationSheet.txt")
                )
        env.set("CSF_UnitsDefinition",       os.path.join(prereq_dir,  "src",
                                                          "UnitsAPI",
                                                          "Units.dat"))

        env.set("MMGT_CLEAR", "1")
        env.set("CSF_LANGUAGE", "us")
    else :
        share_dir = os.path.join(prereq_dir, 'share', 'opencascade',
                                       'resources')
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
        env.set('CFS_StandardDefaults', os.path.join(share_dir, 'StdResource'))
        env.set('CSF_PluginDefaults', os.path.join(share_dir, 'StdResource'))

def set_nativ_env(env: 'Environ') -> None:
    pass

