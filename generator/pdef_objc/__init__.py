# encoding: utf-8
import io
import logging
import os
from pdefc.lang import TypeEnum
from pdefc.generators import Generator, Templates, mkdir_p


ENCODING = 'utf8'
HEADER_TEMPLATE = 'header.jinja2'
IMPL_TEMPLATE = 'impl.jinja2'


class ObjectiveCGenerator(Generator):
    '''Objective-C generator, does not support namespaces, ignores package/module names.'''
    def __init__(self, out, namespace=None, **kwargs):
        '''Create a new generator.

        @param out          Destination directory
        '''
        super(ObjectiveCGenerator, self).__init__(out, **kwargs)

        self.filters = ObjectiveCFilters()
        self.templates = Templates(__file__, filters=self.filters)

    def generate(self, package):
        '''Generate a package source code.'''
        for module in package.modules:
            self._generate_header(module)

    def _generate_header(self, module):
        '''Generate a module header file.'''
        code = self.templates.render(HEADER_TEMPLATE, module=module)
        filename = self._module_filename(module)
        self._write_file(filename, code)

    def _module_directory(self, module):
        '''Return a module directory name from a module.name.'''
        name = self.namespace.map(module.name)
        return name.replace('.', '/')

    def _module_filename(self, module):
        '''Return a module filename.'''
        dirname = self._module_directory(module)
        return '%s.h' % dirname

    def _write_file(self, filename, code):
        # Join the filename with the destination directory.
        filepath = os.path.join(self.out, filename)

        # Create a directory with its children for a file.
        dirpath = os.path.dirname(filepath)
        mkdir_p(dirpath)

        # Write the file contents.
        with io.open(filepath, 'wt', encoding=ENCODING) as f:
            f.write(code)
        logging.info('Created %s', filename)


class ObjectiveCFilters(object):
    '''Objective-C jinja filters.'''
    def objc_base(self, message):
        return self.objc_type(message.base) if message.base else 'NSObject'

    def objc_type(self, type0):
        t = type0.type
        if t in NATIVE_TYPES:
            return NATIVE_TYPES[t]
        elif t == TypeEnum.ENUM_VALUE:
            return '%s_%s' % (self.objc_type(type0.enum), type0.name)
        elif t == TypeEnum.ENUM:
            return type0.name
        elif t == TypeEnum.INTERFACE:
            return 'id<%s>' % type0.name
        elif t == TypeEnum.MESSAGE:
            return '%s *' % type0.name
        raise ValueError('Unsupported type %r' % type0)

    def _enum_value(self, enum_value):
        return '%s_%s' % (self.objc_type(enum_value.enum), enum_value.name)

    def _interface(self):
        pass

    def _definition(self, definition):
        return definition.name + ' *'


NATIVE_TYPES = {
    TypeEnum.BOOL: 'NSNumber *',
    TypeEnum.INT16: 'NSNumber *',
    TypeEnum.INT32: 'NSNumber *',
    TypeEnum.INT64: 'NSNumber *',
    TypeEnum.FLOAT: 'NSNumber *',
    TypeEnum.DOUBLE: 'NSNumber *',

    TypeEnum.STRING: 'NSString *',
    TypeEnum.DATETIME: 'NSDate *',

    TypeEnum.VOID: 'id',

    TypeEnum.LIST: 'NSArray *',
    TypeEnum.SET: 'NSSet *',
    TypeEnum.MAP: 'NSMap *'
}
