#!/usr/bin/env bash

# SETTINGS {{{

BIRTH_DATE="1970-01-01" # Birth date
SEX="BTSX" # MLE for Male, FMLE for Female, BTSX for both sexes
# ISO 3166-1 alpha-3 country code
# https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
COUNTRY="GLOBAL"
CONFIG_FILE="/tmp/thanatophobia"

# }}}

if [ ! -f "$CONFIG_FILE" ] || [ "$(head -1 "$CONFIG_FILE")" != "$BIRTH_DATE $SEX $COUNTRY" ]; then 
    if [ "$COUNTRY" == "GLOBAL" ]; then
        EXPECTANCY=$(curl -s "https://apps.who.int/gho/athena/api/GHO/WHOSIS_000001?filter=REGION:GLOBAL;SEX:$SEX" | grep -oP '(?<=Numeric=\").*?(?=\")' | tail -1)
    else
        EXPECTANCY=$(curl -s "https://apps.who.int/gho/athena/api/GHO/WHOSIS_000001?filter=COUNTRY:$COUNTRY;SEX:$SEX" | grep -oP '(?<=Numeric=\").*?(?=\")' | tail -1)
    fi
    echo $BIRTH_DATE $SEX $COUNTRY > "$CONFIG_FILE"
    echo $EXPECTANCY >> "$CONFIG_FILE"
else
    EXPECTANCY=$(tail -1 "$CONFIG_FILE")
fi
NOW=$(date -u +%s)
BIRTH=$(date --date="$BIRTH_DATE" -u +%s)
SECONDS=$(printf '%.0f' $(echo "$EXPECTANCY * 31557600" | bc -l))
DEATH=$(($BIRTH + $SECONDS))
LEFT=$(echo "$(($DEATH - $NOW)) / 31557600" | bc -l)

printf %.5f $LEFT
