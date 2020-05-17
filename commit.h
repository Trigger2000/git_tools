#include "libgit2/include/git2.h"
#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/types.h>
#include <dirent.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>

#define HASH_SIZE 40

void check_error(int err_code, const char* message);
void general(char* hash, char* commit);
git_oid get_oid_from_hash(char* hash);
git_oid scan_directory(char* hash);
git_oid change_message(git_commit* commit, git_repository* repo, char* message);