ADMIN = node[:ubuntu][:admin]
USER  = node[:ubuntu][:user]

ADMIN_PWD = node[:ubuntu][:admin_pwd]
USER_PWD = node[:ubuntu][:user_pwd]

ARCHIVE = node[:ubuntu][:ubuntu_archive_url]
ADMIN_HOME = "/home/" + ADMIN
HOME = "/home/" + USER

apt_repo "main_ubuntu" do
      url ARCHIVE
      keyserver "keyserver.ubuntu.com"
      key_package "ubuntu-keyring"
      distribution "precise"
      components ["main", "universe"]
      source_packages false
end

script "apt-get update" do
    user "root"
    interpreter "sh"
    code "apt-get update"
end

template "/etc/sudoers" do
    source "sudoers.erb"
    mode 0440
    owner "root"
    group "root"
    variables(
        :passwordless => true,
        :sudoers_groups => node[:ubuntu][:sudo][:groups],
        :sudoers_users  => node[:ubuntu][:sudo][:users]
    )
end

gem_package "ruby-shadow" do
   action :install
end

log "admin user =  " + ADMIN
user ADMIN do
   comment "bring.out admin"
   gid "adm"
   home ADMIN_HOME
   shell "/bin/bash"
   supports( :manage_home => true, :non_unique => false )
   password ADMIN_PWD
end

bash "update user " + ADMIN + "dialout, adm, sudo" do
    user  "root"
    group "root"

code <<-EOH
usermod -a -G dialout,adm,sudo #{ADMIN}
EOH

end

log "standardni user =  " + USER
user USER do
   comment "bring.out user"
   gid "users"
   home HOME
   shell "/bin/bash"
   supports( :manage_home => true, :non_unique => false )
   password USER_PWD
end

bash "update user " + USER + "dialout, sudo" do
    user  "root"
    group "root"

code <<-EOH
usermod -a -G dialout,sudo #{USER}
EOH

end

log "---- install ---"
["network-manager", "network-manager-openvpn", "git"].each do |item|
    package item do
       action :install
    end
end
