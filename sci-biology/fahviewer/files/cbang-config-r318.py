from SCons.Script import *
import sys
import config

deps = ['libsqlite', 'boost', 'xml', 'openssl', 'pthreads',
        'valgrind', 'osx', 'zlib', 'libbzip2']


def add_vars(vars):
   vars.Add(BoolVariable('backtrace_debugger', 'Enable backtrace debugger', 0))
   vars.Add('debug_level', 'Set log debug level', 1)


def configure_deps(conf):
    env = conf.env

    # zlib
    config.configure('zlib', conf)

    # libbzip2
    config.configure('libbzip2', conf)

    # XML
    config.configure('xml', conf)

    # OpenSSL
    config.configure('openssl', conf)

    # V8
    config.configure('v8', conf, False)

    # libsqlite
    config.configure('libsqlite', conf)

    # boost
    config.configure('boost', conf, version = '1.40',
                     hdrs = ['version', 'iostreams/stream'],
                     libs = ['iostreams', 'system', 'filesystem', 'regex'])

    # pthread
    if env['PLATFORM'] != 'win32': config.configure('pthreads', conf)

    # wsock32 & D3D9
    if env['PLATFORM'] == 'win32':
        config.require_lib(conf, 'wsock32')
        config.require_lib(conf, 'setupapi')

    # OSX frameworks
    if env['PLATFORM'] == 'darwin':
        if not (config.configure('osx', conf) and
                conf.CheckOSXFramework('ApplicationServices') and
                conf.CheckOSXFramework('IOKit') and
                conf.CheckOSXFramework('CoreFoundation')):
            raise Exception, \
                'Need ApplicationServices, IOKit & CoreFoundation frameworks'

    # Valgrind
    config.configure('valgrind', conf)

    # Debug
    if env.get('debug', 0):
        if conf.CheckCHeader('execinfo.h') and conf.CheckCHeader('bfd.h') and \
                config.check_lib(conf, 'iberty') and \
                config.check_lib(conf, 'bfd'):
            env.AppendUnique(CPPDEFINES = ['HAVE_CBANG_BACKTRACE'])

        elif env.get('backtrace_debugger', 0):
            raise Exception, \
                "execinfo.h, bfd.h and libbfd needed for backtrace_debuger"

        env.AppendUnique(CPPDEFINES =
                         ['DEBUG_LEVEL=' + str(env.get('debug_level', 1))])


def configure(conf):
    env = conf.env

    configure_deps(conf)

    # compiler.py crashes if LIBPATH is unset
    env.AppendUnique(LIBPATH = ['/usr/lib'])

    if not (config.check_lib(conf, 'cbang') and
            conf.CheckCXXHeader('cbang/Exception.h')):
        raise Exception, 'Need CBang'

    env.AppendUnique(CPPDEFINES = 'HAVE_CBANG')
