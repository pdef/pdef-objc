# encoding: utf-8
import os.path
try:
    from setuptools import setup
except ImportError:
    import ez_setup
    ez_setup.use_setuptools()
    from setuptools import setup


setup(
    name='pdef-objc',
    version='1.0',
    license='Apache License 2.0',
    description='Pdef Objective-C generator',
    url='',

    author='Ivan Korobkov',
    author_email='ivan.korobkov@gmail.com',

    packages=['pdef_objc'],
    package_data={
        '': ['*.jinja2']
    },

    install_requires=[
        'pdefc>=1.0'
    ],
    entry_points={
        'pdefc.generators': [
            'objc = pdef_objc:ObjectiveCGenerator',
        ]
    },

    classifiers=[
        'Development Status :: 4 - Alpha',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: Apache Software License',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 2.7',
        'Topic :: Software Development :: Code Generators',
        'Topic :: Software Development :: Compilers'
    ]
)