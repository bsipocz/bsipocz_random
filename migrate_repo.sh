repo_name=$(basename $(pwd))

if [[ -z $ORG_NAME ]]; then
    remote_repo=${repo_name}
else
    remote_repo=${ORG_NAME}/${repo_name}
fi

gh repo create --private --confirm ${remote_repo}
git push --all origin
git push --tags origin
