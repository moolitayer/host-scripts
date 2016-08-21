if [ $# -lt '1' ] ; then
  echo "usage: remote-script-execution.sh script_url  hostname [hostname..]"
  echo "example: remote-script-execution.sh https://raw.githubusercontent.com/moolitayer/host-scripts/master/osh-add-metric.sh mtayer-centos7-3.eng.lab.tlv"
  exit 1
fi

URL=$1
shift
TIMEOUT=260

echo "EXECUTION SCRIPT SELECTED: ${URL}"

RETRCODE=0
for HOST in $@; do
  echo "EXECUTING SCRIPT [HOST: ${HOST} TIMEOUT: ${TIMEOUT}]"

  ssh -l root ${HOST} wget --quiet -O script.sh  ${URL} || { echo "ERROR: could not get script" ; exit 1; }
  ssh -o ConnectTimeout=${TIMEOUT} -l root ${HOST} bash script.sh > ${HOST}.log 2>&1
  if [ $? -ne '0' ]; then
    RETRCODE=1
   fi
done

if [ ${RETRCODE} -ne '0' ]; then
  echo 'At least one script failed!'
fi
exit ${RETRCODE}

# TODO: check if one failed
