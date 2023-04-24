### Issue
two ways to do "make test" using spack

1. use $spack test run flecsi@version

          ==> Spack test hga6byeudfpqnqfwpbkls34cwhxqt6by
          ==> Testing package flecsi-develop-ibb2ray
          =====1 no-tests, 0 passed of 1 specs ==========

2. use $ctest

          *********************************
          No test configuration file found!
          *********************************
          Usage

           ctest [options]
           
 ### resolved 
 
 1. spack did not add unit tests after flecsi installation.
 
 2. resolved: rebuild flecsi from source (cd FleCSI_DIR)
      
     -- spack install flecsi and dependencies 
     
     -- before rebuild:    spack env activate -p ${BASE_DIR}  
     
     -- rebuild flecsi @FleCSI_DIR
     
           
