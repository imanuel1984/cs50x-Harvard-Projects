#include <cs50.h>
#include <ctype.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

// Function prototypes
int count_letters(string text);
int count_words(string text);
int count_sentences(string text);

int main(void)
{
    // Get input text from the user
    string text = get_string("Text: ");

    // Count letters, words, and sentences
    int letters = count_letters(text);
    int words = count_words(text);
    int sentences = count_sentences(text);

    // Calculate averages per 100 words
    float L = (float) letters / words * 100;
    float S = (float) sentences / words * 100;

    // Compute Coleman-Liau index
    float index = 0.0588 * L - 0.296 * S - 15.8;

    // Round to nearest whole number
    int grade = (int) round(index);

    // Output grade level
    if (grade < 1)
    {
        printf("Before Grade 1\n");
    }
    else if (grade >= 16)
    {
        printf("Grade 16+\n");
    }
    else
    {
        printf("Grade %i\n", grade);
    }
}

// Count alphabetical letters (A–Z or a–z)
int count_letters(string text)
{
    int letters = 0;

    for (int i = 0, n = strlen(text); i < n; i++)
    {
        if (isalpha((unsigned char) text[i]))
        {
            letters++;
        }
    }
    return letters;
}

// Count words based on spaces (words = spaces + 1)
int count_words(string text)
{
    int words = 1;  // Start at 1 because the first word has no space before it

    for (int i = 0, n = strlen(text); i < n; i++)
    {
        if (text[i] == ' ')
        {
            words++;
        }
    }
    return words;
}

// Count sentences that end with ., !, or ?
int count_sentences(string text)
{
    int sentences = 0;

    for (int i = 0, n = strlen(text); i < n; i++)
    {
        if (text[i] == '.' || text[i] == '!' || text[i] == '?')
        {
            sentences++;
        }
    }
    return sentences;
}
