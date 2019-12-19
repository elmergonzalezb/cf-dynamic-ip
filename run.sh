#! /bin/bash

BASEURL="https://api.cloudflare.com/client/v4/zones/"
APITOKEN=`egrep "^APITOKEN" secret.key| awk -F "=" '{print $2}'`
ZONEID=`egrep "^ZONEID" secret.key| awk -F "=" '{print $2}'`
CONTENT_TYPE="Content-Type:application/json"
AUTH="Authorization: Bearer "

get_zoneid(){
    #input  : base domain
    #output : zoneid 
    #example: get_zoneid "domain.com"
    curl -s "$BASEURL""?name=""$1" -H "$CONTENT_TYPE" -H "$AUTH$APITOKEN" | jq -r '.result|.[0]|.id'
}

get_recordid(){
    #input  : subdomain
    #output : recordid
    #example: get_recordid "home.domain.com"
    curl -s "$BASEURL""$ZONEID""/dns_records" -H "$CONTENT_TYPE" \
         -H "$AUTH$APITOKEN" | jq -r '.result|.[]|.id,.name' \
         | grep "$1" -B1| grep -v "$1"
}

get_arecordip(){
    #input  : recordid
    #output : ip
    #example: get_arecordip "abc123def456"
    curl -s "$BASEURL""$ZONEID""/dns_records/""$1" -H "$CONTENT_TYPE" \
         -H "$AUTH$APITOKEN" | jq -r '.result.content'
}

update_arecordip(){
    #input  : recordid, subdomain, newip, proxy(true/false)
    #output : true/false 
    #example: update_arecordip "abc123def456" "home.domain.com" "1.2.3.4" true
    curl -s -X PUT "$BASEURL""$ZONEID""/dns_records/""$1" -H "$CONTENT_TYPE" -H "$AUTH$APITOKEN" \
         -d '{"type":"A","name":"'"$2"'","content":"'"$3"'","ttl":1,"proxied":'$4'}' | jq .success
}

