#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

const int HEADER_SIZE = 44;

int main(int argc, char *argv[])
{
    // Check command-line arguments count
    if (argc != 4)
    {
        printf("Usage: ./volume input.wav output.wav factor\n");
        return 1;
    }

    // Open input file
    FILE *input = fopen(argv[1], "r");
    if (input == NULL)
    {
        printf("Could not open input file.\n");
        return 1;
    }

    // Open output file
    FILE *output = fopen(argv[2], "w");
    if (output == NULL)
    {
        printf("Could not open output file.\n");
        fclose(input);
        return 1;
    }

    // Get factor (how much to scale the volume)
    float factor = atof(argv[3]);

    // Buffer for the WAV header (44 bytes)
    uint8_t header[HEADER_SIZE];

    // Read header from input file
    // fread(destination, size_of_each_element, number_of_elements, file)
    if (fread(header, HEADER_SIZE, 1, input) != 1)
    {
        printf("Could not read header.\n");
        fclose(input);
        fclose(output);
        return 1;
    }

    // Write header to output file unchanged
    if (fwrite(header, HEADER_SIZE, 1, output) != 1)
    {
        printf("Could not write header.\n");
        fclose(input);
        fclose(output);
        return 1;
    }

    // Buffer for audio sample (16-bit signed)
    int16_t sample;

    // Read each 2-byte sample, scale it, and write it out
    // fread returns the number of items successfully read
    while (fread(&sample, sizeof(int16_t), 1, input) == 1)
    {
        // Scale the sample by the factor
        sample = sample * factor;

        // Write the updated sample to the output file
        fwrite(&sample, sizeof(int16_t), 1, output);
    }

    // Close both files
    fclose(input);
    fclose(output);

    return 0;
}
