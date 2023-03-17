#!/bin/sh

_startswith() {
  echo $((9300+$1))
_startswith1() {
  _str="$1"
  _sub="$2"
  echo "$_str" | grep -- "^$_sub" >/dev/null 2>&1
  echo $_str 
  echo $_sub
 
}
 # _startswith1 "-$1"
}
for i in {2..10}
do
_startswith $i
	if [[ $1 == node1 ]]; then
	
		echo 'equal!'
 	fi
done

