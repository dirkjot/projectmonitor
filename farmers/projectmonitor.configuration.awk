
function printblockmaybe(reading, lines) {
  if (reading > 0 && lines ~ /  - farm/ ) {
    print lines
  }
  lines = ""
}

BEGIN {
  reading=0
  lines = ""
}

$0 ~ /^[^ -]/ {
   printblockmaybe(reading, lines)
   reading=0
   print
}

$0 ~ /^- guid: / {
  printblockmaybe(reading, lines)
  reading=1
  lines = $0
}


/^ / {
  lines = lines  "\n"  $0
}

END {
  printblockmaybe(reading, lines)
}
