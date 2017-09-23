/bin/sh
echo "Leaving the VSAN Cluster..."
esxcli vsan cluster leave
echo "Done"

echo "Disabling Auto Mode..."
esxcli vsan storage automode set --enabled false
echo "Done"


esxcli vsan storage list > deviceList

for i in `grep 'VSAN Disk Group Name' deviceList | sort -u | cut -d " " -f8`
do
  echo "Removing Disk Group..."
  esxcli vsan storage remove -s $i
  echo "Done"
done


for i in `grep 'Is SSD:' -n deviceList | cut -d ":" -f1`
do
  num=`expr $i - 3`
  echo "Reseting Labels for all the disks..."
  partedUtil mklabel /dev/disks/`sed "$num!d" deviceList` gpt
  echo "Done"
done

rm -rf deviceList