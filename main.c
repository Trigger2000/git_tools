#include "commit.h"

int main(int argc, char** argv)
{
    if (argc < 3)
    {
        printf("Usage: <commit hash> <new comment>\n");
        exit(EXIT_FAILURE);
    }

    int comment_length = strlen(argv[2]);
    char* new_comment = (char*)calloc(comment_length, sizeof(char));
    new_comment = argv[2];
    
    general(argv[1], new_comment);

    return 0;
}