#/bin/sh

#while [ "x$ipadresse" = x ] ; do ipadresse=`/usr/local/bin/speedport.sh`; done

unset SOLL;
while [ "x$SOLL" = x -o "x$SOLL" = "x0.0.0.0" ] ; do SOLL=`/usr/local/bin/wie-ist-meine-ip.sh`; sleep 20; done

subject="host=`hostname` ip=$SOLL date=`date +%Y-%m-%d-%X`";

MESSAGE="Mit php von zoe.xeo an michalmolako@wp.pl gesendet. \
 � 1631 Kinder haben ein Recht auf gewaltfreie Erziehung.\
  K�rperliche Bestrafungen, seelische Verletzungen und andere entw�rdigende Ma�nahmen sind unzul�ssig.\
 � 1619 Das Kind ist, solange es dem elterlichen Hausstand angeh�rt und von den Eltern erzogen oder unterhalten wird,\
  verpflichtet, in einer seinen Kr�ften und seiner Lebensstellung entsprechenden Weise\
  den Eltern in ihrem Hauswesen und Gesch�ft Dienste zu leisten. "

echo    "Subject " $subject
echo    "Programm" $0
echo -n "hostname" ""
hostname
echo    "MESSAGE " $MESSAGE

php -r '$to = "michalmolako@wp.pl";$subject = "'"$subject"'"; $message = "'"$MESSAGE "'\n\n'"$0"'\n\n'"$subject"'"; $headers = "From: wurzel@zoe.xeo"; $mail_sent = @mail( $to, $subject, $message, $headers );'

exit 0


echo $mail_sent ? "Mail sent\n" : "Mail failed\n";

MESSAGE=" Mit php von zoe.xeo an michalmolako@wp.pl gesendet. \
 &sect; 1631 Kinder haben ein Recht auf gewaltfreie Erziehung.\
  K&ouml;rperliche Bestrafungen, seelische Verletzungen und andere entw&uuml;rdigende Ma&szlig;nahmen sind unzul&auml;ssig.\
 &sect; 1619 Das Kind ist, solange es dem elterlichen Hausstand angeh&ouml;rt und von den Eltern erzogen oder unterhalten wird,\
  verpflichtet, in einer seinen Kr&auml;ften und seiner Lebensstellung entsprechenden Weise\
  den Eltern in ihrem Hauswesen und Gesch&auml;ft Dienste zu leisten.\
"

