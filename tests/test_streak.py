from streak import longest_positive_streak

def test_empty():
    assert longest_positive_streak([]) == 0

def test_multiple_streaks():
    assert longest_positive_streak([1, 2, -1, 3, 4, 5, 0, 2]) == 3

def test_zeros_and_negatives():
    assert longest_positive_streak([0, -1, 2, 3, -2, 4, 5]) == 2
