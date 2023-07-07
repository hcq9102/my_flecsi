0. $ srun -p medusa -N 1 --pty /bin/bash -l
1. ### checkout the specific commit
       $ git clone --branch BRANCH_NAME https://github.com/STEllAR-GROUP/flecsi2.git
      
       $ cd flecsi2
      
       $ git checkout COMMIT_HASH
   
2. #### Modify flecsi/package.py file,   PATH:  PROJECTNAME/flecsi2/spack-repo/packages/flecsi/package.py
   
   --replace all content of package.py with the [package.py](https://github.com/hcq9102/my_flecsi/blob/main/build%20hpxbackend%20with%20commit/package.py) file in this folder.
   
   --Modify the commit to target commit hash(same as step 3) in this syntax : version('hpxv', commit='YOUR COMMIT_HASH')
   save
6. run the script.
