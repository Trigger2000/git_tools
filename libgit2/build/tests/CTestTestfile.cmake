# CMake generated Testfile for 
# Source directory: /home/ilya/Desktop/code/git_tool/libgit2/tests
# Build directory: /home/ilya/Desktop/code/git_tool/libgit2/build/tests
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(offline "/home/ilya/Desktop/code/git_tool/libgit2/build/libgit2_clar" "-v" "-xonline")
add_test(invasive "/home/ilya/Desktop/code/git_tool/libgit2/build/libgit2_clar" "-v" "-score::ftruncate" "-sfilter::stream::bigfile" "-sodb::largefiles" "-siterator::workdir::filesystem_gunk" "-srepo::init" "-srepo::init::at_filesystem_root")
add_test(online "/home/ilya/Desktop/code/git_tool/libgit2/build/libgit2_clar" "-v" "-sonline")
add_test(gitdaemon "/home/ilya/Desktop/code/git_tool/libgit2/build/libgit2_clar" "-v" "-sonline::push")
add_test(ssh "/home/ilya/Desktop/code/git_tool/libgit2/build/libgit2_clar" "-v" "-sonline::push" "-sonline::clone::ssh_cert" "-sonline::clone::ssh_with_paths" "-sonline::clone::path_whitespace_ssh")
add_test(proxy "/home/ilya/Desktop/code/git_tool/libgit2/build/libgit2_clar" "-v" "-sonline::clone::proxy")
add_test(auth_clone "/home/ilya/Desktop/code/git_tool/libgit2/build/libgit2_clar" "-v" "-sonline::clone::cred")
add_test(auth_clone_and_push "/home/ilya/Desktop/code/git_tool/libgit2/build/libgit2_clar" "-v" "-sonline::clone::push" "-sonline::push")
