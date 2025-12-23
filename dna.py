import csv
import sys


def main():

    # ✅ Check for correct command-line usage
    if len(sys.argv) != 3:
        print("Usage: python dna.py database.csv sequence.txt")
        sys.exit(1)

    database_file = sys.argv[1]
    sequence_file = sys.argv[2]

    # ✅ Read DNA sequence file into a variable
    with open(sequence_file, "r") as file:
        sequence = file.read().strip()

    # ✅ Read database file into a variable
    with open(database_file, "r") as file:
        reader = csv.DictReader(file)
        people = list(reader)
        strs = reader.fieldnames[1:]  # skip "name"

    # ✅ Find longest match of each STR in DNA sequence
    dna_counts = {}
    for str_seq in strs:
        dna_counts[str_seq] = longest_match(sequence, str_seq)

    # ✅ Check database for matching profiles
    for person in people:
        match = True
        for str_seq in strs:
            if int(person[str_seq]) != dna_counts[str_seq]:
                match = False
                break

        if match:
            print(person["name"])
            return

    print("No match")


def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    for i in range(sequence_length):
        count = 0

        while True:
            start = i + count * subsequence_length
            end = start + subsequence_length

            if sequence[start:end] == subsequence:
                count += 1
            else:
                break

        longest_run = max(longest_run, count)

    return longest_run


main()
