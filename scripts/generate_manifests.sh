#!/bin/bash
set -e

CDIR=$(cd `dirname "$0"` && pwd)

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

cd $CDIR/../templates

if [[ ! -f $CDIR/../configs/$ENVIRONMENT-custom-settings.yaml ]]; then
  settings_file=$CDIR/../configs/$ENVIRONMENT-default-settings.yaml
else
  settings_file=$CDIR/../configs/$ENVIRONMENT-custom-settings.yaml
fi

mkdir -p $CDIR/../manifests/$ENVIRONMENT
print_green "\nGenerating manifests for $ENVIRONMENT from templates using:\n\t $settings_file ...\n"

for template in *.yaml; do
  word="job"
  # job manifest, in produzione non va generato, quindi lo escludo.
  if [[ $ENVIRONMENT == prod ]] && [[ "${template/$word}" == "$template" ]]; then
    print_green manifests/$ENVIRONMENT/$template
    j2 $template $settings_file > $CDIR/../manifests/$ENVIRONMENT/$template
  elif [[ $ENVIRONMENT == dev ]]; then
    print_green manifests/$ENVIRONMENT/$template
    j2 $template $settings_file > $CDIR/../manifests/$ENVIRONMENT/$template
  fi
done
