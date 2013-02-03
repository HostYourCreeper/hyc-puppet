#! /bin/bash
DIR='/opt/firewall';
RETVAL=0;

IP=$(ifconfig eth0 | egrep -o 'inet adr:[[:alnum:]]*.[[:alnum:]]*.[[:alnum:]]*.[[:alnum:]]*' | awk -F: '{print $2}')
if [[ -z $IP ]]
then
  IP=$(ifconfig eth0 | egrep -o 'inet addr:[[:alnum:]]*.[[:alnum:]]*.[[:alnum:]]*.[[:alnum:]]*' | awk -F: '{print $2}')
fi

start(){
  # Passive FTP over NAT #
  modprobe -s nf_nat_ftp
  modprobe -s nf_conntrack_ftp
 
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
 
  iptables -I INPUT -i lo -j ACCEPT
  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  iptables -A INPUT -d ${IP}/32 -p tcp -m tcp --dport 22 -j ACCEPT
  iptables -A INPUT -d ${IP}/32 -p tcp -m tcp --dport 8124 -j ACCEPT
  iptables -A INPUT -d ${IP}/32 -p tcp -m tcp --dport 5666 -j ACCEPT

  ## Start Nginx VM ##
  # SSH
  iptables -t nat -A PREROUTING -d ${IP}/32 -p tcp -m tcp --dport 20122 -j DNAT --to-destination 10.10.10.01:22
  # HTTP
  iptables -t nat -A PREROUTING -d ${IP}/32 -p tcp -m tcp --dport 80 -j DNAT --to-destination 10.10.10.01:80
  ## End Nginx VM ##

  for i in ${DIR}/vm/* ; do
    NUM=$(echo $i | awk -F\/ '{print $5}')
    # FTP 2XX21 -> 21
    iptables -t nat -A PREROUTING -d ${IP}/32 -p tcp -m tcp --dport 2${NUM}21 -j DNAT --to-destination 10.10.10.${NUM}:21

    # MC 255XX -> 25565
    iptables -t nat -A PREROUTING -d ${IP}/32 -p tcp -m tcp --dport 255${NUM} -j DNAT --to-destination 10.10.10.${NUM}:25565

    # Minequery 256XX -> 25566
    iptables -t nat -A PREROUTING -d ${IP}/32 -p tcp -m tcp --dport 256${NUM} -j DNAT --to-destination 10.10.10.${NUM}:25566
   
    # Rcon 275XX -> 25575
    iptables -t nat -A PREROUTING -d ${IP}/32 -p tcp -m tcp --dport 275${NUM} -j DNAT --to-destination 10.10.10.${NUM}:25575

    # HTTP 80XX -> 80
    iptables -t nat -A PREROUTING -d ${IP}/32 -p tcp -m tcp --dport 80${NUM} -j DNAT --to-destination 10.10.10.${NUM}:80
    iptables -t nat -A PREROUTING -s 91.236.239.44/32 -d ${IP}/32 -p tcp -m tcp --dport 81${NUM} -j DNAT --to-destination 10.10.10.${NUM}:81

    # Dynmap 123XX -> 8123
    #iptables -t nat -A PREROUTING -i eth0 -p tcp -m tcp --dport 123${NUM} -j DNAT --to-destination 10.10.10.${NUM}:8123
    iptables -t nat -A PREROUTING -d ${IP}/32 -p tcp -m tcp --dport 123${NUM} -j DNAT --to-destination 10.10.10.${NUM}:8123

    # Mumble 646XX -> 64738
    iptables -t nat -A PREROUTING -d ${IP}/32 -p tcp -m tcp --dport 646${NUM} -j DNAT --to-destination 10.10.10.${NUM}:64738
    iptables -t nat -A PREROUTING -d ${IP}/32 -p udp -m udp --dport 646${NUM} -j DNAT --to-destination 10.10.10.${NUM}:64738

    # SSH 2XX22 -> 22
    iptables -t nat -A PREROUTING -d ${IP}/32 -p tcp -m tcp --dport 2${NUM}22 -j DNAT --to-destination 10.10.10.${NUM}:22

    # Munin 149XX -> 4949
    iptables -t nat -A PREROUTING -d ${IP}/32 -p tcp -m tcp --dport 149${NUM} -j DNAT --to-destination 10.10.10.${NUM}:4949

    if [ -s ${i} ]
    then
      DIP=$(cat ${i})
      iptables -t nat -A PREROUTING -d ${DIP}/32 -p tcp -m tcp -j DNAT --to-destination 10.10.10.${NUM}
    fi

  done

  iptables -A INPUT -p udp -j DROP
}
stop(){
  iptables -F -t nat
  iptables -X -t nat
  iptables -F INPUT
}

show(){
  iptables -L -t nat
}

case $1 in
start)
  start;
  date;
  echo "Firewall started";
;;
stop)
  stop;
  date;
  echo "Firewall stopped";
;;
restart)
  stop;
  start;
  date;
  echo "Firewall restarted";
;;
show)
  show;
;;
*)
  echo "Usage: $0 {start|stop|restart|show}"
  RETVAL=1
esac
exit $RETVAL;

