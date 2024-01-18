#! /bin/bash


set -e -o xtrace

function run_git_commands(){
  if [[ -n "$CREATE_BRANCH_NAME" ]]; then
      create_branch
  fi

  if [[ -n "$DELETE_BRANCH_NAME" ]]; then
      delete_branch
  fi

  if [[ -n "$SHOW_BRANCH_NAME" ]]; then
      show_branch
  fi

}

function show_branch(){
  echo "Showing Branch Details for ${SHOW_BRANCH_NAME}"

  # TODO: Test with upstream
  git branch -r | grep ${SHOW_BRANCH_NAME} && echo "Branch exists" || echo "Branch does not exists"
}

function delete_branch(){
  echo "Deleting Branch ${DELETE_BRANCH_NAME}"

  git checkout develop
  # Force Deletes the local branch
  git branch -D ${DELETE_BRANCH_NAME}
  # TODO: Test with upstream
  git push origin --delete ${DELETE_BRANCH_NAME} && echo "Branch Deleted" || echo "Branch not deleted"
}

function create_branch(){
  echo "Creating Branch ${CREATE_BRANCH_NAME}"

  git stash
  git checkout develop
  git fetch upstream
  git rebase upstream/develop
  git checkout -b ${CREATE_BRANCH_NAME}
  # TODO: Test with upstream
  git push -u origin ${CREATE_BRANCH_NAME}:${CREATE_BRANCH_NAME}  && echo "Branch created" || echo "Branch not created"

}

_error_exit() {
   echo "$1"
   exit 1
}

_help() {
    local -- _cmd=$(basename "$0")

    cat <<EOF

  Usage: ${_cmd} [OPTION]...

    This script is to create, delete and show github branches.

  -c, --create-branch <branch-name>  The branch name you want to create REQUIRED
  -d, --delete-branch <branch-name>  The branch name you want to delete REQUIRED
  -s, --show-branch <branch-name>  The branch name you want to show/list REQUIRED
  -h, --help                   Print this help message

  Example:

    ${_cmd} --create-branch release-3.8
    ${_cmd} --delete-branch release-3.8
    ${_cmd} --show-branch release-3.8


EOF
}

function parse_options () {

  	while [ $# -gt 0 ] ; do
  	    case "$1" in
  	        -c|--create-branch)  CREATE_BRANCH_NAME="$2"; shift;;
  	        -d|--delete-branch)  DELETE_BRANCH_NAME="$2"; shift;;
            -s|--show-branch)    SHOW_BRANCH_NAME="$2"; shift;;
  	        -h|--help|help)            _help; exit 0;;
  	        *)                         _help; _error_exit "[error] Unrecognized flag '$1'";;
  	    esac
  	    shift
  	done

}

function main() {
  parse_options "$@"
  run_git_commands
}

main "$@"
