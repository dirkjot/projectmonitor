# use this script to filter projects out of a larger configuration file
# download the configuration file from the pulse page, like so:
#   curl figpulse.cfapps.io/configuration
# then run this script to select projects with a specific tag only.


BEGIN {
  TAGNAME = "smilodon"
  
  ### do not change below this line ##
  reading=0
  lines = ""
  print "---"
}

function printblockmaybe(reading, lines) {
  if (reading > 0 && match(lines, "  - " TAGNAME )) {
    print lines
  }
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
