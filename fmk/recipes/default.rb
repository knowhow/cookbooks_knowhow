build_fmk = node[:fmk][:build_fmk]
fmk_role  = node[:fmk][:role]
sql_site  = node[:fmk][:sql_site]

USER      = node[:fmk][:user]

GCODE_URL_FMK = "http://knowhow-erp-fmk.googlecode.com/files"

HOME = "/home/" + USER
GIT_ROOT = HOME + "/github"


apt_repo "main_ubuntu" do
      url node[:fmk][:ubuntu_archive_url]
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


package "sqlite3" do
    action :install
end

log "---- ukloni nepotrebne pakete ---"
["bluez", "apport", "update-notifier", "oneconf", "telepathy-indicator",  "xscreensaver" ].each do |item|
    package item do
       action :purge
    end
end

log "----- FMK runtime packages ----"
[ "p7zip-full", "smbclient", "dosemu", "xfonts-terminus-dos",  "cups-pdf", "wine", "winetricks", "vim-gtk"].each do |item|
   package item do
      action :install
   end
end

service "cups" do
   action :stop
end

directory HOME + "/github" do
  owner USER
  group USER
  mode  "0755"
end


cookbook_file  HOME + "/.dosemurc"  do
	owner USER
	group USER
	mode 0755
	source ".dosemurc"
end

cookbook_file  "/etc/profile.d/90_dosemu.conf"  do
	owner "root"
	group "root"
	mode 0644
	source "90_dosemu.conf"
end

cookbook_file  "/etc/dosemu/dosemu.conf"  do
	owner "root"
	group "root"
	mode 0644
	source "dosemu.conf"
end

log "dosemu direktoriji"
directory HOME + "/.dosemu" do
  owner USER
  group USER
  mode  "0755"
end

directory HOME + "/.dosemu/drive_c" do
  owner USER 
  group USER
  mode  "0755"
end

remote_file HOME + "/.dosemu/drive_c/fmk_drive_c.7z" do
       source GCODE_URL_FMK + "/fmk_drive_c.7z"
       mode "0644"
       checksum "5054e8c49bb72e12cfb4ef3ac2aa6078822ad236"
end


bash "extract fmk_drive_c.7z"   do
	      user USER
	      user USER
	      cwd HOME + "/.dosemu/drive_c"
	      code <<-EOH

	   export HOME=#{HOME}
	   if [[ ! -f tops/TOPS.exe ]]; then
	       7z x -y fmk_drive_c.7z
	   fi

	EOH
end

if (fmk_role == "tops") or (fmk_role == "tops_knjig")

	log "wine direktoriji - root owner"

	directory HOME + "/.wine" do
	  owner "root" 
	  group "root"
	  mode  "0755"
	end

	directory HOME + "/.wine/drive_c" do
	  owner "root" 
	  group "root"
	  mode  "0755"
	end


    ["tops", "tops/kum1", "tops/kum1/sql", "sigma", "sigma/in", "sigma/out" ].each do |item|
       directory HOME + "/" + item do
	  owner USER 
	  group USER
	  mode  "0755"
	end
end

remote_file HOME + "/c_tops.7z" do
       source GCODE_URL_FMK + "/c_tops_with_oid.7z"
       mode "0644"
       checksum "3d52b9c43ac4953ad3ce0fbf3f85d6e8bb672bb2ecab05210def3cb3756835d3"
end

bash "extract c_tops.7z"   do
      user USER
      user USER
      cwd HOME
      code <<-EOH

   export HOME=#{HOME}

   if [[ ! -f tops/TOPS.exe ]]; then
       7z x -y c_tops.7z
   fi

EOH

end


end


if (fmk_role == "tops_knjig")

directory HOME + "/kase"  do
  owner USER
  group USER
  mode  "0755"
end

cookbook_file  HOME + "/tops/fmk.ini"  do
	owner USER
	group USER
	mode 0644
	source "tops_knjig/exe_path/fmk.ini"
end


cookbook_file  "/usr/local/bin/run_kase.sh"  do
	owner USER
	group USER
	mode 0744
	source "tops_knjig/run_kase.sh"
end


end


if (fmk_role == "tops")

    log "fmk.ini exepath - tops i gateway parametri"
	cookbook_file  HOME + "/tops/fmk.ini"  do
		owner USER
		group USER
		mode 0644
		source "tops/exe_path/fmk.ini"
	end


	log "fmk.ini - SQLLog=D kumpath, sqlpar.dbf - parametri OID-a za prodajno mjesto"
	cookbook_file  HOME + "/tops/kum1/fmk.ini"  do
		owner USER
		group USER
		mode 0644
		source "tops/kum_path/fmk_sql.ini"
	end

	cookbook_file  HOME + "/tops/kum1/sql/sqlpar.template"  do
		owner USER
		group USER
		mode 0644
		source "tops/kum_path/sqlpar.template"
	end


    bash "set sqlpar.dbf" + sql_site do
        user USER
        cwd HOME + "/tops/kum1/sql"
        code <<-EOH
            cat sqlpar.template | sed -e 's/12345678900112345678900212345678900399/#{sql_site}0000000000#{sql_site}9999999999#{sql_site}0000000015#{sql_site}/'  > sqlpar.dbf
EOH
    end

	cookbook_file  "/usr/local/bin/run_tops.sh"  do
		owner USER
		group USER
		mode 0744
		source "tops/run_tops.sh"
	end

    [".config/autostart", "Desktop", "Radna\ Površ"].each do |item|
        cookbook_file  HOME + "/"  + item + "/run_gateway_tops.desktop" do
          owner USER
          group USER
          mode 0755
          source "tops/run_gateway_tops.desktop"
          ignore_failure true
        end
    end

end


if (fmk_role == "tops") || (fmk_role == "tops_knjig")


cookbook_file  "/usr/local/bin/run_gateway.sh"  do
	owner USER
	group USER
	mode 0744
	source "tops/run_gateway.sh"
end


bash "ln-s dosemu, wine sa home direktrijima"   do
      user "root"
      cwd HOME
      code <<-EOH

   export HOME=#{HOME}

   # preslikaj sve dosemu direktorije u wine

   for f in tops kase sigma
   do
       DIR=$HOME/$f
       if [[ -d $DIR ]]; then
         for f2 in .wine .dosemu 
         do 
             if [[ ! -h $HOME/$f2/drive_c/$f ]] ; then 
                 ln -s $DIR $HOME/$f2/drive_c/$f
             fi
         done
       fi
   done

EOH

end


end

if (fmk_role == "tops")


bash "run"   do
      user "root"
      cwd HOME
      code <<-EOH

   export HOME=#{HOME}

   DISPLAY=:0 run_gateway.sh
   DISPLAY=:0 run_tops.sh
EOH

end


end



log "ako ne možete pristupiti samba file serveru zvijer-2.bring.out.ba, onda trebate ručno instalirati"
log "fmk_dsemu_drive_c.7z"
log "detalji na ticketu http://redmine.bring.out.ba/issues/27228"
log "ovaj 7z možete skinuti sa bring.out redmine-a: http://redmine.bring.out.ba/attachments/8182/fmk_dosemu_drive_c.7z"
log "pa ga ručno instalirati unutar sesije na lokaciju ~/.dosemu"
log " "
log "ako se nalazite u officesa bring.out onda će ovaj posao vagrant/chef uraditi za vas ..."



if build_fmk
bash "instaliraj sa zvijer-2 bringout/fmk "   do
      user USER
      cwd HOME
      code <<-EOH

   export HOME=#{HOME}

   cd $HOME/.dosemu

   echo `date` > fmk_dosemu.log
   ARCHIVE=fmk_dosemu_drive_c.7z

   if [[ ! -f $ARCHIVE ]]; then
      echo "get from samba share fmk_dosemu_drive_c.7z" >> fmk_dosemu.log
      sudo smbclient //zvijer-2.bring.out.ba/shared -D bringout/FMK -c "get fmk_dosemu_drive_c.7z"
   else
      echo "$ARCHIVE vec postoji" >> fmk_dosemu.log
   fi

   if [[ ! -d drive_c/Clipper ]]; then
      7z x -y $ARCHIVE
   else
      echo ".dosemu/drive_c/Clipper vec postoji" >> fmk_dosemu.log
   fi

EOH

end
end

if build_fmk

GIT_ROOT=HOME+"/github"
GIT_URL_ROOT="git://github.com/bringout-fmk"
    
    
[ "fmk_lib", "fmk_common", "fin", "kalk", "fakt", "pos", "os", "ld", "virm", "kam"].each do |item| 
    
git GIT_ROOT + "/" + item do
      user USER
      group USER

      repository GIT_URL_ROOT + "/" + item + ".git"
      reference "master"
      action :sync
end

end


directory HOME + "/github/fmk_lib/lib" do
  owner USER 
  group USER
  mode  "0755"
end

directory HOME + "/github/fmk_lib/exe" do
  owner USER 
  group USER
  mode  "0755"
end


log "kreiraj potrebne direktorije, ln -s itd ..."

bash "ln github => c:/git, mkdir fmk_lib/lib, exe "   do
      user USER
      cwd HOME
      code <<-EOH

   export HOME=#{HOME}
   ln -s $HOME/github $HOME/.dosemu/drive_c/git
 
   #echo problem nasih slova
   ln -s $HOME/github/fmk_common $HOME/github/fmk_c

   # fmk libs ovdje
   DIRS="$HOME/github/fmk_lib/lib $HOME/github/fmk_lib/exe"
   for dir in $DIRS
   do
      if [[ ! -d $dir ]]; then  
              mkdir $dir
      fi
   done 
EOH

end


[ "fmk_lib", "fmk_c", "fin", "kalk", "fakt", "pos", "ld" ].each do |item| 
    
	bash "build fmk: " + item   do
	      user USER
	      cwd GIT_ROOT + "/" + item
	      code <<-EOH

	   export HOME=#{HOME}
	   ./build.sh

	EOH

end

end

end


log "postavi config.sys autoexec.bat"

cookbook_file  HOME + "/.dosemu/drive_c/autoexec.bat"  do
	owner USER
	group USER
	mode 0755
	source "autoexec.bat"
end


cookbook_file  HOME + "/.dosemu/drive_c/config.sys"  do
	owner USER
	group USER
	mode 0755
	source "config.sys"
end


