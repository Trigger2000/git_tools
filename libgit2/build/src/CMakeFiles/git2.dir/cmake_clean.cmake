file(REMOVE_RECURSE
  "../libgit2.pdb"
  "../libgit2.so.1.0.0"
  "../libgit2.so"
  "../libgit2.so.1.0"
)

# Per-language clean rules from dependency scanning.
foreach(lang C)
  include(CMakeFiles/git2.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
