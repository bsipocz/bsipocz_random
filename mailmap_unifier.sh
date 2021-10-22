# Collect duplicated names
git shortlog -n -s -e |sort -k 2,2|gawk 'BEGIN{a=$2; b=$3;line=$0;num=$1}{if ($2==a && $3==b) {if (num>$1) print line, $0; else print $0,line}; a=$2; b=$3;line=$0;num=$1}'|gawk -F "<|>" '{if ($2==$4) print  $1"<"$2">"; else print $1"<"$2"> <"$4">"}' | cut -c 8- >> .mailmap

git shortlog -n -s -e |sort -k 2,2|cut -c 8-|gawk -F "<|>" 'BEGIN{name=$1;email=$2}{if ($1==name) {print name"<"email"> <"$2">"};name=$1;email=$2}' >> .mailmap

# Collect duplicated emails
git shortlog -n -s -e|sort -t \< -k 2| gawk -F "<|>" 'BEGIN{email=$2;line=$0}{if ($2==email) {print line"\n"$0}; line=$0;email=$2}'|gawk 'BEGIN{num=$1;line=$0;email=$NF}{if ($NF==email){if (num>$1) print line; else print $0};num=$1;line=$0;email=$NF}' | cut -c 8- >> .mailmap

# don't have noreply.github emails as first field, if possible
gawk -F "<|>" '{where=match($2, "noreply.github"); if (NF>3 && where !=0) print $1"<"$4"> <"$2">";else print $0}' .mailmap |sort|uniq > mailmap_temp

# filter duplicates
gawk -F "<|>" 'BEGIN{email1=$2;email2=$4}{if (NF>3 && $4==email1) {if ($2!=email2) print $1"<"$4"> <"$2">"} else print $0;email1=$2;email2=$4}' mailmap_temp | sort |uniq > .mailmap
