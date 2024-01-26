#!/bin/bash

set -e

if [[ -z "${SONAR_TOKEN}" ]]; then
  echo "Set the SONAR_TOKEN env variable."
  exit 1
fi

if [[ -f "${INPUT_PROJECTBASEDIR%/}/pom.xml" ]]; then
  echo "Maven project detected. You should run the goal 'org.sonarsource.scanner.maven:sonar' during build rather than using this GitHub Action."
  exit 1
fi

if [[ -f "${INPUT_PROJECTBASEDIR%/}/build.gradle" ]]; then
  echo "Gradle project detected. You should use the SonarQube plugin for Gradle during build rather than using this GitHub Action."
  exit 1
fi

if [[ -z "${SONARCLOUD_URL}" ]]; then
  SONARCLOUD_URL="https://sonarcloud.io"
fi

GITHUB_REPOSITORY_NAME=`echo ${GITHUB_REPOSITORY} | cut -d/ -f2`
PROJECT_KEY=`echo ${GITHUB_REPOSITORY} | sed 's|/|_|g'`

if [[ -n "${GITHUB_BASE_REF}" ]]; then
  PR_NUMBER=`echo ${GITHUB_REF} | cut -d/ -f3`
fi

unset JAVA_HOME

sonar-scanner \
  -Dsonar.host.url=${SONARCLOUD_URL} \
  -Dsonar.organization=interfolio \
  -Dsonar.projectKey=${PROJECT_KEY} \
  -Dsonar.projectBaseDir=${INPUT_PROJECTBASEDIR} \
  -Dsonar.branch.name=${GITHUB_REF_NAME} \
  -Dsonar.scm.revision=${GITHUB_SHA} \
  -Dsonar.scm.disabled=true \
  -Dsonar.pullrequest.base=${GITHUB_BASE_REF} \
  -Dsonar.pullrequest.branch=${GITHUB_HEAD_REF} \
  -Dsonar.pullrequest.key=${PR_NUMBER} \
  -Dsonar.pullrequest.provider=GitHub \
  -Dsonar.pullrequest.github.repository=${GITHUB_REPOSITORY} \
  -Dsonar.sourceEncoding=UTF-8 \
  ${INPUT_ARGS}