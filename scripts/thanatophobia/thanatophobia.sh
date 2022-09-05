#!/usr/bin/env bash

# SETTINGS {{{

BIRTH_DATE="2004-11-22" # Birth date
SEX="MLE" # MLE for Male, FMLE for Female, BTSX for both sexes
# ISO 3166-1 alpha-3 country code
# https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
COUNTRY="POL"

# }}}

if [ ! -f "/tmp/tmp_thanatophobia" ] || [ "$(head -1 /tmp/tmp_thanatophobia)" != "$BIRTH_DATE $SEX $COUNTRY" ]; then 
    if [ "$COUNTRY" == "GLOBAL" ]; then
        EXPECTANCY=$(curl -s "https://apps.who.int/gho/athena/api/GHO/WHOSIS_000001?filter=REGION:GLOBAL;SEX:$SEX" | grep -oP '(?<=Numeric=\").*?(?=\")' | tail -1)
    else
        EXPECTANCY=$(curl -s "https://apps.who.int/gho/athena/api/GHO/WHOSIS_000001?filter=COUNTRY:$COUNTRY;SEX:$SEX" | grep -oP '(?<=Numeric=\").*?(?=\")' | tail -1)
    fi
    echo $BIRTH_DATE $SEX $COUNTRY > /tmp/tmp_thanatophobia
    echo $EXPECTANCY >> /tmp/tmp_thanatophobia
else
    EXPECTANCY=$(tail -1 /tmp/tmp_thanatophobia)
fi
NOW=$(date -u +%s)
BIRTH=$(date --date="$BIRTH_DATE" -u +%s)
SECONDS=$(printf '%.0f' $(echo "$EXPECTANCY * 31557600" | bc -l))
DEATH=$(($BIRTH + $SECONDS))
LEFT=$(echo "$(($DEATH - $NOW)) / 31557600" | bc -l)

printf %.5f $LEFT
