f18_user        = node[:F18][:user]
install_harbour = node[:F18_3rd][:install_harbour]

USER = f18_user
HOME = "/home/" + f18_user
GIT_ROOT = HOME + "/github"
REPOS = "F18_ubuntu_3rd_party_install"

group USER 
user USER do
   comment "knowhowERP user"
   gid   USER
   home  HOME
   shell "/bin/bash"
   password "$1$ueVC4w6g$4uREUclhxAclbcHXcBnLz/"
   supports( :manage_home => true, :non_unique => false )
end

bash "update user: " + USER + " dialout, adm, sudo" do
    user  "root"
    group "root"

code <<-EOH
usermod -a -G dialout,adm,sudo #{USER}
EOH

   #not_if do ! File.exists?("/etc/xxxxxxxxxxxxxxx") end
   #only_if
end

directory GIT_ROOT do
  owner USER 
  group USER
  mode  "0755"
end

git GIT_ROOT + "/" + REPOS do
      user USER
      group USER
      repository "git://github.com/knowhow/" + REPOS
      reference "master"
      action :sync
end


switch = ''

# ako ne buildas, onda instaliraj harbour sa gcode

if install_harbour
  switch = '--hbout'
end

bash "install F18 3rd party" do
      user "root"
      group "root"
      cwd GIT_ROOT
      code <<-EOH

export HOME=#{HOME}

REPOS=F18_ubuntu_3rd_party_install

cd $REPOS

./F18_3rd_party_ubuntu_install.sh #{switch}

EOH
end

