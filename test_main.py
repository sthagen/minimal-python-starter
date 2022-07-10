from main import main


def test_main():  # type: ignore
    assert main([1, 2, 3]) == 3
