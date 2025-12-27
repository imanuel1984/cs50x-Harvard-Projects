// Implements a dictionary's functionality

#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
} node;

// Number of buckets in hash table
// You can tweak this; bigger = less collisions, more memory.
const unsigned int N = 5000;

// Hash table
node *table[N];

// Keep track of number of words loaded
unsigned int word_count = 0;

// Hashes word to a number
unsigned int hash(const char *word)
{
    // Simple polynomial rolling hash, case-insensitive
    unsigned long hash_value = 0;

    for (int i = 0; word[i] != '\0'; i++)
    {
        char c = tolower((unsigned char) word[i]);
        // Only letters and apostrophe appear in dictionary, but
        // we'll just include apostrophe as-is.
        hash_value = (hash_value * 31) + c;
    }

    return hash_value % N;
}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
    // Open dictionary file
    FILE *file = fopen(dictionary, "r");
    if (file == NULL)
    {
        return false;
    }

    // Buffer for a word from dictionary
    char buffer[LENGTH + 1];

    // Read each word one at a time
    while (fscanf(file, "%45s", buffer) == 1)
    {
        // Allocate a new node
        node *n = malloc(sizeof(node));
        if (n == NULL)
        {
            fclose(file);
            return false;
        }

        // Copy word into node
        strcpy(n->word, buffer);

        // Hash word to obtain index
        unsigned int index = hash(buffer);

        // Insert node into hash table (at head of linked list)
        n->next = table[index];
        table[index] = n;

        // Increase word counter
        word_count++;
    }

    fclose(file);
    return true;
}

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    // Make a lowercase copy of the word (dictionary is lowercase)
    char lower[LENGTH + 1];
    int i = 0;

    while (word[i] != '\0' && i < LENGTH)
    {
        lower[i] = tolower((unsigned char) word[i]);
        i++;
    }
    lower[i] = '\0';

    // Hash the lowercase word
    unsigned int index = hash(lower);

    // Traverse linked list at this bucket
    node *cursor = table[index];
    while (cursor != NULL)
    {
        if (strcmp(cursor->word, lower) == 0)
        {
            return true;
        }
        cursor = cursor->next;
    }

    // Not found
    return false;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    return word_count;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    // For each bucket
    for (unsigned int i = 0; i < N; i++)
    {
        node *cursor = table[i];

        // Free linked list
        while (cursor != NULL)
        {
            node *tmp = cursor;
            cursor = cursor->next;
            free(tmp);
        }

        table[i] = NULL;
    }

    return true;
}
