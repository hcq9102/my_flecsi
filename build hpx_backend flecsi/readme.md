#### build hpx backend flecsi using spack

headsup:

    -- task_local branch

    -- modify https://github.com/STEllAR-GROUP/flecsi2/blob/502ca8ced4d0712b4f482dd055efa0ca23e940d5/spack-repo/packages/flecsi/package.py
    
    -- make sure using same version of Boost while compiling HPX and FleCSI or the poisson application

### Modify: 
https://github.com/STEllAR-GROUP/flecsi2/blob/502ca8ced4d0712b4f482dd055efa0ca23e940d5/spack-repo/packages/flecsi/package.py
     
 ---original: 

    git      = 'https://github.com/flecsi/flecsi.git'

    version('2.2', branch='2', submodules=False, preferred=False)

---modified: 

    git      = 'https://github.com/STEllAR-GROUP/flecsi2.git'

    version('hpxv', branch='task_local', submodules=False, preferred=False)
    
    
 ### NOTE: If test hpx@master
 
   https://github.com/STEllAR-GROUP/flecsi2/blob/502ca8ced4d0712b4f482dd055efa0ca23e940d5/spack-repo/packages/flecsi/package.py#L116
      
      ---change hpx@1.8.1 to hpx@master
      
      Note: if something wrong with the script, just remove '^hpx@master' in script. i.e. 
      
   https://github.com/hcq9102/my_flecsi/blob/main/build%20hpx_backend%20flecsi/build_flecsi_spack_ctest_hpx%40master.sh#L20-L21
