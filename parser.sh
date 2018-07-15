#!/bin/bash
kaufmrd()
{
debug="input: $1"
if [ $(echo $1 | grep -c '\.') -eq 1 ]
then
drittenachkomma=$(echo $1 | cut -f 2 -d '.' | cut -c 3)
if [ $drittenachkomma -lt 5 ]
then
  echo "scale=2; $1/1" | bc
else
  echo "scale=2; $1/1+0.01" | bc
fi
else
  echo $1
fi
}

while IFS= read line; do
date=$(echo ${line} | cut -d "_" -f 5 | cut -d "T" -f 1)
year=$(echo $date | cut -d "-" -f 1)
month=$(echo $date | cut -d "-" -f 2)
day=$(echo $date | cut -d "-" -f 3)

time=$(echo ${line} | cut -d "_" -f 5 | cut -d "T" -f 2)
hours=$(echo $time | cut -d ":" -f 1)
minutes=$(echo $time | cut -d ":" -f 2)
seconds=$(echo $time | cut -d ":" -f 3)

zwap=$(echo ${line} | cut -d "_" -f 6 | sed 's#,#.#')
neuzep=$(echo ${line} | cut -d "_" -f 10 | sed 's#,#.#')
dreizep=$(echo ${line} | cut -d "_" -f 8| sed 's#,#.#')
zep=$(echo ${line} | cut -d "_" -f 7 | sed 's#,#.#')
nulp=$(echo ${line} | cut -d "_" -f 9 | sed 's#,#.#')

zwapNe=$(kaufmrd $(echo "scale=10; $zwap - $zwap * 20 / 120 " | bc))
neuzepNe=$(kaufmrd $(echo "scale=10; $neuzep - $neuzep * 19 / 119 " | bc))
dreizepNe=$(kaufmrd $(echo "scale=10; $dreizep - $dreizep * 13 / 113 " | bc))
zepNe=$(kaufmrd $(echo "scale=10; $zep - $zep * 10 / 110 " | bc))

zwapMwst=$(echo $zwap - $zwapNe | bc)
neuzepMwst=$(echo $neuzep - $neuzepNe | bc)
dreizepMwst=$(echo $dreizep - $dreizepNe | bc)
zepMwst=$(echo $zep - $zepNe | bc)

summe=$(echo  $zwap + $neuzep + $dreizep + $zep + $nulp | bc | sed 's#\.#,#')
summeMwstFloat=$(echo "scale=10; $zwapMwst + $neuzepMwst + $dreizepMwst + $zepMwst" | bc )
summeMwstDisp=$(echo "scale=2; $summeMwstFloat/1" | bc | sed 's#\.#,#')
outp="$day.$month.$year,,,,\"$summe\",\"$summeMwstDisp\""
echo $outp | xclip -selection c
paplay beep.wav
#echo ${line}
#echo $zwap
#echo "scale=10; $zwap - $zwap / 1.2 " | bc
#echo "$zwapMwst + $neuzepMwst + $dreizepMwst + $zepMwst"
echo $outp
done
