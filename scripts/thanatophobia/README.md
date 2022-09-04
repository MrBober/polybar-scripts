# thanatophobia
A shell script that shows you how much time you have left based on life expectancy for your country and sex

## Configuration
Change variables in thanatophobia.sh
```sh
BIRTH_DATE="2004-11-22" # Birth date
SEX="MLE" # MLE for Male, FMLE for Female, BTSX for both sexes
# ISO 3166-1 alpha-3 country code
# https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
COUNTRY="POL"
```

## Module
```ini
[module/thanatophobia]
type = custom/script
exec = /path/to/script.sh
format = You have <label> years left
label = %output%
interval=600
```
