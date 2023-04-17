#### build hpx backend flecsi using spack

headsup:

    -- task_local branch

    -- modify https://github.com/STEllAR-GROUP/flecsi2/blob/502ca8ced4d0712b4f482dd055efa0ca23e940d5/spack-repo/packages/flecsi/package.py
    
    -- make sure using same version of Boost while compiling HPX and FleCSI or the poisson application

#### modify: 
https://github.com/STEllAR-GROUP/flecsi2/blob/502ca8ced4d0712b4f482dd055efa0ca23e940d5/spack-repo/packages/flecsi/package.py
     
 ---original: 

    git      = 'https://github.com/flecsi/flecsi.git'

    version('2.2', branch='2', submodules=False, preferred=False)

---modified: 

    git      = 'https://github.com/STEllAR-GROUP/flecsi2.git'

    version('hpxv', branch='task_local', submodules=False, preferred=False)
