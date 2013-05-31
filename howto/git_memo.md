## This is a git memo 

## How to fork a branch from git hub

Clone the project 

    git clone git://github.com/somename/projecttofork.git

Use the following commands to add the 'upsteam' as a remote branch. 
Replace the 'upstreamname' and 'projectname' values with that actual user/project name that you're trying to track.

    git remote add --track master upstream git://github.com/upstreamname/projectname.git
    git fetch upstream
    git merge upstream/master

Create my on branch

    git branch newfeature
    git checkout newfeature

Squash these commits into a small handful of well-labeled commits

    git rebase

Push the new branch

    git push origin newfeature
