Experimental implementation of CSV parser which support several dialects of it 

## Specification

* https://tools.ietf.org/html/rfc4180
* http://specs.frictionlessdata.io/csv-dialect/

## How to build

```bash
$ make install
$ make
$ ./scv_dialect.native path/to/my.csv
```

## Results of execution

```
fixture/*.csv -> fixture/*.json
```

## ABNF(RFC4180)

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

## ABNF(Dialect01)

```
file = [header CRLF] record *(CRLF record) [CRLF]
header = name *(COMMA name)
record = field *(COMMA field)
name = field
field = *(TEXTDATA/DQUOTE) ^CR
COMMA = %x2C
CR = %x0D ;as per section 6.1 of RFC 2234 [2]
```
