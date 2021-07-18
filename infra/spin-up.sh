#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd $SCRIPT_DIR/vpc
terragrunt apply -auto-approve -var enable_nat=true
cd $SCRIPT_DIR

cd $SCRIPT_DIR/bastion
terragrunt apply -auto-approve -var instance_count=2
cd $SCRIPT_DIR

cd $SCRIPT_DIR/ecs/cluster
terragrunt apply -auto-approve -var instance_count=2
cd $SCRIPT_DIR
