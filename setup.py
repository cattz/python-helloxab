from setuptools import setup
import os

version_file = os.path.join('hello', 'VERSION')

setup(
    name='helloxab',
    version=open(version_file, 'r').read().strip(),
    packages=['hello'],
    url='',
    author='Xabier Davila',
    author_email='davila.xabier@gmail.com',
    description='Simple python project for demo purposes',
    long_description=open('README.md', 'r').read(),
    license='Apache License 2.0',
    entry_points={
        "console_scripts": [
            "helloxab = hello.main_entrypoint:main",
        ]
    },
)
