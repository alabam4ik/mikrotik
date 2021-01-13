# vars
: local MAIL_FROM "from@mail.ex";
: local MAIL_TO "to@mail.ex";
/log info "///----> Backuping"
:global backupfile ([/system identity get name]. ".backup")
:if ([/file find name=$backupfile] != "") do={/file rem $backupfile}

:delay 2s

/log info "///----> Prepareing logs"

:global logMessages;
:set logMessages ""
:foreach i in=[/log find ] do={
:set logMessages ($logMessages. [/log get $i time ]. " ");
:set logMessages ($logMessages. [/log get $i message ]);
:set logMessages ($logMessages. "\n")
}

/log info "///----> Prepareing backup"
/system backup save name=$backupfile
/export file="fullConfigScript"
/log info "///----> Waiting 5 sec"

:delay 5s

/log info "///----> Sending e-mail"

/tool e-mail send from="$MAIL_FROM" to=$MAIL_TO subject="Mikrotik BACKUP file"  file=$backupfile body="Backup Mikrotik"
/tool e-mail send from="$MAIL_FROM" to=$MAIL_TO subject="Mikrotik FullConfig file"  file="fullConfigScript.rsc"  body= [/system clock get time]
/log info "///----> OK"
