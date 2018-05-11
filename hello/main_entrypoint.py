import pkg_resources

version = pkg_resources.get_distribution("python-helloxab").version
# Name matching the one in setup.py


def main():
    print('Hello, this is Hello Xab version {}'.format(version))


if __name__ == "__main__":
    main()
