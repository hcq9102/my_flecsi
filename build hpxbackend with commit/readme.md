0. $ srun -p medusa -N 1 --pty /bin/bash -l
1. $ git clone --branch BRANCH_NAME https://github.com/STEllAR-GROUP/flecsi2.git
2. $ cd flecsi2
3. $ git checkout COMMIT_HASH
4.  Modify flecsi/package.py file,  PATH:  PROJECTNAME/flecsi2/spack-repo/packages/flecsi/package.py
   replace all content with the package.py file in this folder.
   Modify the commit to target commit hash(same as step 3) in this syntax : version('hpxv', commit='YOUR COMMIT_HASH')
   save
5. run the script.
