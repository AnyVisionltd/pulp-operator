#!/bin/bash
set -ex

BASE_ADDR="http://localhost:24817"

## CREATE REPO
CREATE_REPO_RES=$(http --check-status --ignore-stdin --timeout=2.5 POST ${BASE_ADDR}/pulp/api/v3/repositories/deb/apt/ name="bionic-security-main")
REPO_HREF=$(echo ${CREATE_REPO_RES} | jq -r '.pulp_href')

## CREATE REMOTE
CREATE_REMOTE_RES=$(http --check-status --ignore-stdin --timeout=2.5 POST ${BASE_ADDR}/pulp/api/v3/remotes/deb/apt/ name="bionic-security-main" url="http://us.archive.ubuntu.com/ubuntu/" distributions="bionic-security" components="main" architectures="amd64")
REMOTE_HREF=$(echo ${CREATE_REMOTE_RES} | jq -r '.pulp_href')

## SYNC REPO WITH REMOTE
SYNC_RES=$(http --check-status --ignore-stdin --timeout=2.5 POST ${BASE_ADDR}${REPO_HREF}sync/ remote=${BASE_ADDR}${REMOTE_HREF})
SYNC_TASK_HREF=$(echo ${SYNC_RES} | jq -r '.task')

## PRINT TASK STATUS
http --check-status --ignore-stdin --timeout=2.5 GET ${BASE_ADDR}${SYNC_TASK_HREF}
