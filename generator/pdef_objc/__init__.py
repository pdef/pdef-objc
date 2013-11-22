# encoding: utf-8
import io
import logging
import os
from pdefc.lang import TypeEnum
from pdefc.generators import Generator, Templates, upper_first


ENCODING = 'utf8'
HEADER_TEMPLATE = 'header.jinja2'
IMPL_TEMPLATE = 'impl.jinja2'
PACKAGE_TEMPLATE = 'package.jinja2'


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
            for definition in module.definitions:
                self._generate_header(definition)
                self._generate_impl(definition)

        self._generate_package(package)

    def _generate_header(self, definition):
        '''Generate a definition header file.'''
        code = self.templates.render(HEADER_TEMPLATE, definition=definition)
        filename = '%s.h' % definition.name
        self.write_file(filename, code)

    def _generate_impl(self, definition):
        '''Generate a definition implementation file.'''
        code = self.templates.render(IMPL_TEMPLATE, definition=definition)
        filename = '%s.m' % definition.name
        self.write_file(filename, code)

    def _generate_package(self, package):
        '''Generate a package file which groups all headers.'''
        code = self.templates.render(PACKAGE_TEMPLATE, package=package)
        filename = '%s.h' % package.name
        self.write_file(filename, code)


class ObjectiveCFilters(object):
    '''Objective-C jinja filters.'''
    def objc_bool(self, expression):
        return 'YES' if expression else 'NO'

    def objc_base(self, message):
        return message.base.name if message.base else 'PDMessage'

    def objc_type(self, type0):
        t = type0.type
        if t in NATIVE_TYPES:
            return NATIVE_TYPES[t]
        elif t == TypeEnum.ENUM_VALUE:
            return '%s_%s ' % (type0.enum.name, type0.name)
        elif t == TypeEnum.ENUM:
            return '%s ' % type0.name
        elif t == TypeEnum.INTERFACE:
            return 'id<%s> ' % type0.name
        elif t == TypeEnum.MESSAGE:
            return '%s *' % type0.name
        raise ValueError('Unsupported type %r' % type0)

    def objc_descriptor(self, type0):
        t = type0.type
        if t in NATIVE_DESCRIPTORS:
            return NATIVE_DESCRIPTORS[t]
        elif t == TypeEnum.ENUM:
            return '%sDescriptor()' % type0.name
        elif t == TypeEnum.LIST:
            return '[PDDescriptors listWithElement:%s]' % self.objc_descriptor(type0.element)
        elif t == TypeEnum.SET:
            return '[PDDescriptors setWithElement:%s]' % self.objc_descriptor(type0.element)
        elif t == TypeEnum.MAP:
            return '[PDDescriptors mapWithKey:%s value:%s]' % (
                self.objc_descriptor(type0.key),
                self.objc_descriptor(type0.value))
        elif t == TypeEnum.INTERFACE:
            return '%sDescriptor()' % type0.name
        elif t == TypeEnum.MESSAGE:
            return '[%s typeDescriptor]' % type0.name
        raise ValueError('Unsupported type %r' % type0)

    def objc_result(self, type0):
        if type0.is_interface:
            return 'id<%s> ' % type0.name
        return 'NSOperation *'


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
    TypeEnum.MAP: 'NSDictionary *'
}


NATIVE_DESCRIPTORS = {
    TypeEnum.BOOL: '[PDDescriptors bool0]',
    TypeEnum.INT16: '[PDDescriptors int16]',
    TypeEnum.INT32: '[PDDescriptors int32]',
    TypeEnum.INT64: '[PDDescriptors int64]',
    TypeEnum.FLOAT: '[PDDescriptors float0]',
    TypeEnum.DOUBLE: '[PDDescriptors double0]',

    TypeEnum.STRING: '[PDDescriptors string]',
    TypeEnum.DATETIME: '[PDDescriptors datetime]',

    TypeEnum.VOID: '[PDDescriptors void0]',
}
