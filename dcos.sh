export DCOS_ACS_TOKEN=`dcos config show core.dcos_acs_token`
export DCOS_SSL_VERIFY=false


# get logs
# d=$(date -u +%Y%m%d-%H%M%S) && mkdir /tmp/journal-logs-${d} && for unit in $(systemctl list-units --no-legend --no-pager --plain 'dcos-*' | awk '{print $1}'); do echo "Saving logs for ${unit}"; journalctl -au ${unit} > /tmp/journal-logs-${d}/${unit}.log; done && tar -czvf $(hostname -f)-journal-logs-${d}.tgz -C /tmp/journal-logs-${d}/ .
