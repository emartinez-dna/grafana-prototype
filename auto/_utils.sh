get-projectpath() {
    projectName=$1

    if [ -z $projectName ]
    then
        echo "Please provide a projectName and try again."
        return 1
    else
        echo "${CONTAINER_WORKSPACE_FOLDER}/projects/${projectName}"
        return 0
    fi
}
generate-action() {
    action=$1
    projectName=$2
    cat << EOF
    projectPath="`get-projectpath $projectName`"
    projectPathExitCode=$?
    
    if [ \$projectPathExitCode -gt 0 ]
    then
        echo "Failed to $action project: \$projectPath"
        exit 1
    else
        scriptPath="\${projectPath}/auto/$action.sh"
        if [ -f \$scriptPath ]
        then
            bash \$scriptPath ${@:3}
        else
            echo "- \$scriptPath not found.  Skipping."
        fi
    fi
EOF
}
get-projects() {
    ls "${CONTAINER_WORKSPACE_FOLDER}/projects"
}
build-project() {
    bash -c "`generate-action build $1`"
}
release-project() {
    bash -c "`generate-action release $1`"
}