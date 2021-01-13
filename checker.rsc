#vars
: local ISP_NAME_1 "ISP_NAME_1";
: local ISP_NAME_2 "ISP_NAME_2";
: local ping1 "8.8.8.8";
: local ping2 "ukr.net";
: local ping3 "1.1.1.1";
: local countNumber "5";
: local BOT_KEY "567xxxxxx:AAEgNHvsxxxxxxxxxxxxxxxxxxxxxxxxxxx";
: local CHAT_ID "-308xxxxxx";
: local MSG_TEXT "some text";

: local status1 "connected";
: local status2 "connected";

while (true) do= {
: delay 60;
#Check First Provider
: local pingStatus (([/ping $ping1 interface=ether1 count=$countNumber routing-table=mark_prov1]+[/ping $ping2 interface=ether1 count=$countNumber routing-table=mark_prov1]+[/ping $ping3 interface=ether1 count=$countNumber routing-table=mark_prov1]) * 100 / 15 );
: local loss (lossed (100-$pingStatus));
: if ( $pingStatus < 85 and status1 = "connected" ) do= {
: tool fetch url="https://api.telegram.org/bot$BOT_KEY/sendmessage\?chat_id=$CHAT_ID&text=packet-loss=$loss% on $ISP_NAME_1";
}

: if ( $pingStatus < 70 and status1 = "connected") do= {
: set $status1 "disconnected";
: tool fetch url="https://api.telegram.org/bot$BOT_KEY/sendmessage\?chat_id=$CHAT_ID&text=packet-loss=$loss% on $ISP_NAME_1, default ISP changed to $ISP_NAME_2";
/ip route set distance=3 [find comment="prov1"]
: delay 900;
}
: if ( $pingStatus > 95 and status1 = "disconnected") do= {
: set $status1 "connected";
: tool fetch url="https://api.telegram.org/bot$BOT_KEY/sendmessage\?chat_id=$CHAT_ID&text=packet-loss=$loss% on $ISP_NAME_1, default ISP changed to $ISP_NAME_2";
/ip route set distance=1 [find comment="prov1"]
}

#Check Second Provider
: local pingStatus2  (([/ping $ping1 interface=ether2 count=$countNumber routing-table=mark_prov2]+[/ping $ping2 interface=ether2 count=$countNumber routing-table=mark_prov2]+[/ping $ping3 interface=ether2 count=$countNumber routing-table=mark_prov2]) * 100 / 15 );
: local loss2 (lossed (100-$pingStatus2));
:if ( $pingStatus2 < 75 and status2 = "connected" ) do= {
:set $status2 "disconnected";
: tool fetch url="https://api.telegram.org/bot$BOT_KEY/sendmessage\?chat_id=$CHAT_ID&text=packet-loss=$loss2% on $ISP_NAME_2";
}

:if ( $pingStatus2  > 95 and status2 = "disconnected" ) do= {
: set $status2 "connected";
: tool fetch url="https://api.telegram.org/bot$BOT_KEY/sendmessage\?chat_id=$CHAT_ID&text=packet-loss=$loss2% on $ISP_NAME_2";
}
}
