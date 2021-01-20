#!/bin/sh
echo "Leaving the VSAN Cluster..."
esxcli vsan cluster leave
echo "Done"

echo "Disabling Auto Mode..."
esxcli vsan storage automode set --enabled false
echo "Done"

for i in `esxcli vsan storage list | grep "VSAN Disk Group Name:" | awk '{print $5}' | sort | uniq`
do
  echo "Removing Disk Group..."
  esxcli vsan storage remove -s $i
  echo "Done"
done