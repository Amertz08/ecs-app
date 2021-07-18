#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

export TF_VAR_cycle=spin-up

cd $SCRIPT_DIR/vpc
terragrunt apply -auto-approve
cd $SCRIPT_DIR

cd $SCRIPT_DIR/bastion
terragrunt apply -auto-approve
cd $SCRIPT_DIR

cd $SCRIPT_DIR/ecs/cluster
terragrunt apply -auto-approve\
cd $SCRIPT_DIR
