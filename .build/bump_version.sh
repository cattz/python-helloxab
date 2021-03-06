#!/usr/bin/env bash

if [[ ( -z ${1+x} ) ]]; then
    cat << EOF
        usage: $(basename ${0}) repo increment

        Quick and dirty version bump script
        If a variable "BAMBOO_BUILD_VERSION" is set, returns that variable as is
        If "BAMBOO_BUILD_VERSION" is not set, returns the bumped version based on last existing tag
        (tags get sorted using 'sort -V', nothing fancy here)
        If no tags are present, the initial version will be 0.1.0
        For branches other than 'master', and appends .devN where N is the build number.

        Expects arguments:
        - repo: the relative/absolute path to the repository
        - increment: (major|minor|patch) part of the version to increase, default is patch
EOF
    exit 1
fi

set -x

repo_path=${1}
increase=${2-patch}

BUILD_VERSION=${BAMBOO_BUILD_VERSION}
CI_BUILD_NUMBER=${bamboo_buildNumber}
CI_BRANCH=${bamboo_repository_branch_name}


function autoversion(){

    if [ -n "${CI_BUILD_NUMBER+x}" ]; then
        BUILD_NUMBER="${CI_BUILD_NUMBER}"
    else
        BUILD_NUMBER="0"  # In the developer machine, this will build x.y.z.dev0
    fi

    # Only builds from master are not dev builds
    if [ "${CI_BRANCH}" == "master" ]; then
        dev_suffix=""
    else
        dev_suffix=".dev${BUILD_NUMBER}"
    fi

    cd ${repo_path}

    git fetch --tags 2>/dev/null
    last_tag=$(git tag | sort -Vr | head -1)

    # Catch existing no tags case
    if [ -z "${last_tag}" ]; then
        echo "0.1.0${dev_suffix}"
    else
        a=( ${last_tag//./ } )   # replace points, split into array
        case "${increase}" in
          patch)
            ((a[2]++))
            ;;
          minor)
            ((a[1]++))
            a[2]=0
            ;;
          major)
            ((a[0]++))
            a[1]=0
            a[2]=0
            ;;
        esac
        echo "${a[0]}.${a[1]}.${a[2]}${dev_suffix}"
    fi
}

if [ -z "${BUILD_VERSION}" ]; then
    autoversion

else
    echo "${BUILD_VERSION}"
fi
