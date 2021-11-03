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
