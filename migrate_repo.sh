# The script requires the GitHub command line client to be installed, see
# https://github.com/cli/cli

if [[ -z $EXTENSION ]]; then
    EXTENSION=.git
fi

if [[ -z $REPO_NAME ]]; then
    REPO_NAME=$(basename $(pwd) ${EXTENSION})
fi

if [[ -z $ORG_NAME ]]; then
    remote_repo=${REPO_NAME}
else
    remote_repo=${ORG_NAME}/${REPO_NAME}
fi

gh repo create --private --confirm ${remote_repo}
git push --all origin
git push --tags origin

# If there are multiple branches, the previous repo creation will make the
# first one default, the following ensures we don't leave the repo in that state

if [[ -z $DEFAULT_BRANCH_NAME ]];then
    for branch in main master; do
        if [[ -z $(git branch --list $branch) ]]; then
            continue
        else
            DEFAULT_BRANCH_NAME=${branch}
            break
        fi
    done
fi

gh api -XPATCH repos/:owner/:repo -f default_branch=${DEFAULT_BRANCH_NAME} > /dev/null
