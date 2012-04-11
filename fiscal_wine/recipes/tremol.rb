tremol_user = node[:F18][:user]
tremol_ver  = node[:fiscal_wine][:version]

knowhowERP_root = "/opt/knowhowERP"

USER=tremol_user
HOME= "/home/" + tremol_user

GCODE_URL_FMK="http://knowhow-erp-fmk.googlecode.com/files"

log "----- fiscal runtime packages ----"
[ "p7zip-full", "wine", "winetricks"].each do |item|
   package item do
      action :install
   end
end


if tremol_ver == "225"

    remote_file HOME + "/wine_tremol.7z" do
        source GCODE_URL_FMK + "/wine_tremol_225.7z"
        mode "0644"
        #sha256
        checksum "97f3af2a3f0bbc230f15c9c79df0f2b7c4039bca818a05167496310051db7cce"
    end

end

if tremol_ver == "224"

    remote_file HOME + "/wine_tremol.7z" do
        source GCODE_URL_FMK + "/wine_tremol_224.7z"
        mode "0644"
        #sha256
        checksum "884cb5cee790bdd84b04d926dba9a3af0f1b2afed141d0cd80f01acedade7156" 
    end
end

bash "install wine_tremol.7z" do
    user  USER
    group USER
    cwd HOME
    
code <<-EOH

    export USER=#{USER}
    
    if [[ ! -d .wine_tremol ]]; then
        7z x -y wine_tremol.7z
    fi

EOH
end


["fp_server.sh", "oposmgr.sh", "comtool.sh", "fix_ole_error.sh"].each do |file|

    cookbook_file knowhowERP_root + "/util/" + file    do
        owner USER
        group USER
        mode 0755
        source "tremol/" + file
    end

end


bash "ln-s fiscal tremol - tops"   do
      user "root"
      cwd HOME
      code <<-EOH

   export HOME=#{HOME}

   DIR=$HOME/.wine_tremol/drive_c/fiscal
   DIR_DEST=$HOME/.dosemu/drive_c/fiscal

   if [ -d $DIR ] && [ ! -e $DIR_DEST ]; then
      ln -s $DIR $DIR_DEST
   fi

EOH
end

cookbook_file "/tmp/crontab" do
    owner USER
    group USER
    mode 0755
    source "tremol/crontab"
end

bash "setup crontab"   do
      user USER
      cwd HOME

      code <<-EOH
   crontab /tmp/crontab
EOH

end


directory HOME + "/.config/autostart" do
	  owner USER 
	  group USER
	  mode  "0755"
end


cookbook_file  HOME + "/.config/autostart/fp_server.desktop" do
	owner USER
	group USER
	mode 0755
	source "fp_server.desktop"
	#notifies :run, "execute[logout]"
end

#execute "logout" do
#	  user  "vagrant"
#	  command "export DISPLAY=:0 ; lxsession-logout"
#	  action :nothing
#end

