#!/bin/bash

set -e

CDIR=$(cd `dirname "$0"` && pwd)
cd "$CDIR"

. $CDIR/functions.sh

if ( ! getopts ":e:" option); then
	print_red "Usage: `basename $0` -e dev|prod"
	exit $E_OPTERROR;
fi

while getopts ":e:" opt; do
  case $opt in
    e)
      ENVIRONMENT=$OPTARG
      ;;
    \?)
      print_red "Invalid option: -$OPTARG" >&2
      print_red "Usage: `basename $0` -e dev|prod"
      exit 1
      ;;
    :)
      print_red "Option -$OPTARG requires an argument dev|prod." >&2
      exit 1
      ;;
  esac
done

if [[ ! -f $CDIR/../configs/$ENVIRONMENT-custom-settings.yaml ]]; then
  settings_file=$CDIR/../configs/$ENVIRONMENT-default-settings.yaml
else
  settings_file=$CDIR/../configs/$ENVIRONMENT-custom-settings.yaml
fi

print_green "$ENVIRONMENT: Loading config variables from:\n\t$settings_file file ...\n"
eval $(parse_yaml $settings_file "config_")

print_red "$ENVIRONMENT: Switching into Kubernetes $ENVIRONMENT context ..."
kubectl config use-context $config_kube_context

print_green "$ENVIRONMENT: Deploying manifests ..."
for manifest in $CDIR/../manifests/dev/*.yaml; do
  eval "kubectl apply -f \"${manifest}\""
done
