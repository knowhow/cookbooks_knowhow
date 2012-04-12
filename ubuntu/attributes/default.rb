default["ubuntu"]["admin"] = "admin"
default["ubuntu"]["user"]  = "bringout"
default["ubuntu"]["sudo"]["groups"] = [ "adm" ]
default["ubuntu"]["sudo"]["users"]  = [ "admin"]


#echo "nekipwd" | makepasswd --clearfrom=- --crypt-md5 |awk '{ print $2 }'

default["ubuntu"]["admin_pwd"] = "$1$XM7VMHxB$4x5tyf6jnQHciNmeirpA/." 
default["ubuntu"]["user_pwd"]  = "$1$Zof3StXy$SW2etD.dubrBWQ13fyWvJ0"
