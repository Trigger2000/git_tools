#include "commit.h"

void check_error(int err_code, const char* message)
{
    const git_error* error = git_error_last();
    if (!err_code)
    {
        return;
    }

    printf("Error %d %s - %s\n", err_code, message, (error && error->message) ? error->message: "???");
    
    exit(EXIT_FAILURE);
}

void general(char* hash, char* new_comment)
{
    git_libgit2_init();


    git_repository* repo;
    char* repo_path = ".git";
    int error = git_repository_open(&repo, repo_path);
    check_error(error, "opening repository");


    git_oid oid = get_oid_from_hash(hash);
    git_commit* commit;
    error = git_commit_lookup(&commit, repo, &oid);
    check_error(error, "lookup commit");


    git_oid new_commit = change_message(commit, repo, new_comment);



    git_commit_free(commit);
    git_repository_free(repo);
    git_libgit2_shutdown();
}

git_oid get_oid_from_hash(char* hash)
{
    git_oid result;
    int hash_size = strlen(hash);
    if (hash_size == HASH_SIZE)
    {
        int error = git_oid_fromstr(&result, hash);
        check_error(error, "transfrom oid from hex");
        
        return result;
    }

    return scan_directory(hash);
}

git_oid scan_directory(char* hash)
{
    char* path = (char*)calloc(20, 1);
    strcat(path, ".git/objects");

    errno = 0;
    DIR* objects = opendir(path);
    check_error(errno, "opening directory");
    rewinddir(objects);

    char* dir_name = (char*)calloc(2, 1);
    char* hash_name = (char*)calloc(4, 1);
    strncpy(dir_name, hash, 2);
    hash += 2*sizeof(char);
    strncpy(hash_name, hash, 4);

    struct dirent* current = readdir(objects);
    while (current != NULL && strcmp(current->d_name, dir_name) != 0)
    {
        current = readdir(objects);
    }

    if (current == NULL)
    {
        printf("No commit for this hash found\n");
        exit(EXIT_FAILURE);
    }

    errno = 0;
    strcat(path, "/");
    strcat(path, current->d_name);
    DIR* hashes = opendir(path);
    check_error(errno, "opening directory");
    rewinddir(hashes);

    char* name = (char*)calloc(HASH_SIZE, 1);
    current = readdir(hashes);
    strncpy(name, current->d_name, 4);
    while (current != NULL && strcmp(hash_name, name) != 0)
    {
        current = readdir(hashes);
        strncpy(name, current->d_name, 4*sizeof(char));
    }

    if (current == NULL)
    {
        printf("No commit for this hash found\n");
        exit(EXIT_FAILURE);
    }

    char* hash_found = (char*)calloc(HASH_SIZE + 1, 1);
    strcat(hash_found, dir_name);
    strcat(hash_found, current->d_name);

    git_oid result;
    int error = git_oid_fromstr(&result, hash_found);
    check_error(error, "transfrom oid from hex");

    free(path);
    free(dir_name);
    free(hash_name);
    free(name);
    free(hash_found);

    return result;
}

git_oid change_message(git_commit* commit, git_repository* repo, char* message)
{
    git_oid result, tree_oid;
    git_signature* author = git_commit_author(commit);
    git_signature* committer = git_commit_committer(commit);
    git_tree* tree;
    git_commit_tree(&tree, commit);

    git_object* parent;
    //git_commit_parent(&parent, commit, 0);
    git_reference* ref = NULL;
    int error = git_revparse_ext(&parent, &ref, repo, "HEAD");
    check_error(error, "revparse");

    error = git_commit_create_v 
    (
        &result,
        repo,
        "HEAD",
        author,
        committer,
        NULL,
        message,
        tree,
        parent ? 1 : 0,
        parent
    );
    check_error(error, "create new commit");

    git_tree_free(tree);
    git_signature_free(author);
    git_signature_free(committer);
    return result;
}