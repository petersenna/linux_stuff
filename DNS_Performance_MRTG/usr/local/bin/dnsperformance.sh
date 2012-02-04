#!/bin/bash
# Peter Senna Tschudin - peter.senna AT gmail.com
# Script to generate dns response time to be used by MRTG
# Lightly based on http://klikics.de/paste/1260011460.html

if [ ! $1 ] || [ ! $2 ]; then
	echo need to inform 2 dns servers...
	exit 1
fi

DOMAINS="tour-o-swiss.ch jnto.go.jp ipaustralia.gov.au europa.eu india.gov.in alojargentina.com.ar guardian.co.uk china-tour.cn heise.de golem.de spiegel.de stern.de bild.de auto.de preisroboter.de faz.de cia.gov google.com whitehouse.gov institut-francais.fr alza.cz"

DNS_MASTER=$1
DNS_SLAVE=$2

RUNS=5

MASTER_TMP=0
SLAVE_TMP=0

MASTER_AVG=0
SLAVE_AVG=0

RUN_COUNT=0


for DOMAIN in $DOMAINS
	do
	for RUN in {1..$RUNS}
	do
		MASTER_TMP=$(dig +time=1 @$DNS_MASTER $DOMAIN| grep "Query time:" | awk {'print $4'})

		if [ $MASTER_TMP -gt 0 2> /dev/null ]; then
			MASTER_AVG=$(( $MASTER_AVG + $MASTER_TMP ))
		else
			echo ERROR! $DOMAIN at $DNS_MASTER >&2
		fi

		SLAVE_TMP=$(dig +time=1 @$DNS_SLAVE $DOMAIN| grep "Query time:" | awk {'print $4'})
		if [ $SLAVE_TMP -gt 0 2> /dev/null ]; then
			SLAVE_AVG=$(( $SLAVE_AVG + $SLAVE_TMP ))
		else
			echo ERROR! $DOMAIN at $DNS_SLAVE >&2
		fi

		RUN_COUNT=$(( $RUN_COUNT + 1 ))
    	done
done



MASTER_AVG=$(( $MASTER_AVG / $RUN_COUNT ))
SLAVE_AVG=$(( $SLAVE_AVG / $RUN_COUNT ))

echo $MASTER_AVG
echo $SLAVE_AVG
exit 0
