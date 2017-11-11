* https://tools.ietf.org/html/rfc4180
* http://specs.frictionlessdata.io/csv-dialect/

## Results of execution

```
fixture/*.csv -> fixture/*.json
```

## ABNF

```
file = [header CRLF] record *(CRLF record) [CRLF]
header = name *(COMMA name)
record = field *(COMMA field)
name = field
field = (escaped / non-escaped)
escaped = DQUOTE *(TEXTDATA / COMMA / CR / LF / 2DQUOTE) DQUOTE
non-escaped = *TEXTDATA
COMMA = %x2C
CR = %x0D ;as per section 6.1 of RFC 2234 [2]
```
