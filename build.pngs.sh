#!/bin/bash

function remove_text() {
	sed -e "\
	\
	/^starting/d; \
	/^sending/d; \
	/^recving/d; \
	\
	s,\.[0-9]\{3\}s,,g; \
	s, msg\/s,,g; \
	s,^time:\s*,,g; \
	s,sent:\s*,,g; \
	s,received:\s*,,g; \
	s,confirmed:\s*,,g; \
	s,nacked:\s*,,g; \
	s,min\/avg\/max\s*latency:\s*[0-9]*\/,,g; \
	s,\/[0-9]*\s*microseconds$,,g; \
	" ${1} > ${2}
}

#
# 4 columns
# time sent received avg_latency
#

for id in autoack ack
do

for i in 01 05 10 20 50
do
echo ${id}-${i}.log

TMPFILE=$(mktemp /tmp/make-gnuplot-script.XXXXXX)

remove_text ${id}-${i}.log ${TMPFILE}

echo ${TMPFILE}

gnuplot -persist << EOF
	set title '${id}-${i}.log'
	set xlabel 'Time'
	set ylabel 'msgs'
	set y2label 'latency'
	set y2tics
	set terminal png size 1024,768
	set output '${id}-${i}.png'
	plot '${TMPFILE}' using 1:2 with lines linecolor rgb "red" lw 5 title 'Sent', \
		'' using 1:3 with lines linecolor rgb "green" lw 5 title 'Received', \
		'' using 1:4 with lines linecolor rgb "blue" lw 1 title 'Latency' axes x1y2
EOF

rm -f ${TMPFILE}

done

done 

#
# 6 columns
# time sent confirmed nacked received avg_latency
# nacked count is always zero so there is no need to print it there
#

for id in "ack-confirm" "ack-confirm-persistent"
do

for i in 01 05 10 20 50
do
echo ${id}-${i}.log

TMPFILE=$(mktemp /tmp/make-gnuplot-script.XXXXXX)

remove_text ${id}-${i}.log ${TMPFILE}

echo ${TMPFILE}

gnuplot -persist << EOF
	set title '${id}-${i}.log'
	set xlabel 'Time'
	set ylabel 'msgs'
	set y2label 'latency'
	set y2tics
	set terminal png size 1024,768
	set output '${id}-${i}.png'
	plot '${TMPFILE}' using 1:2 with lines linecolor rgb "red" lw 5 title 'Sent', \
		'' using 1:5 with lines linecolor rgb "green" lw 5 title 'Received', \
		'' using 1:3 with impulses linecolor rgb "red" lw 1 title 'Confirmed', \
		'' using 1:6 with lines linecolor rgb "blue" lw 1 title 'Latency' axes x1y2
EOF

rm -f ${TMPFILE}

done

done 
