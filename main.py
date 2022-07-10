import sys


def main(argv=None) -> int:  # type: ignore
    """Drive the app."""
    argv = [] if argv is None else argv
    return len(argv)


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
