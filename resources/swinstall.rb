# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html

property :chefclientver, String
property :pkg, String
property :ver, String
property :updatestarttime, String
property :pspkg, String

# attempting to use chef client updater cookbook
# Too many difficulties
# Use something like this to call from a recipe
# winstallrecipes_swinstall 'install a diff chef client version' do
#   chefclientver '13.7.16'
#   action :clientupdate
# end

action :setuplog do
  directory 'c:/logs'

  file node['swinstall']['logfile'] do
    notifies :run, 'ruby_block[createlogfile]', :immediate
  end

  ruby_block 'createlogfile' do
    block do
      writelog 'Created Log File'
    end
    action :nothing
  end
end

# This will install Chocolatey if not already
# At this time, I see no easy way to log the original Chocolatey install event
action :instchoco do
  include_recipe 'chocolatey::default'
end

# consider the need to install 'chocolatey-core.extension' explicitly

# Install the pkg with version ver
# Notify the ruby block that calls the write log function
action :chocopkginstall do
  chocolatey_package new_resource.pkg do
    action :install
    version new_resource.ver.to_s
    notifies :run, 'ruby_block[LogInstallPkgMsg]', :immediate
  end

  # pass a customized message to the writelog function
  ruby_block 'LogInstallPkgMsg' do
    block do
      writelog "Installed #{new_resource.pkg}, Version #{new_resource.ver}"
    end
    action :nothing
  end
end

# Uninstall the pkg
# uninstall has be deprecated for chocolatey_package
# use remove instead
action :chocopkguninstall do
    chocolatey_package new_resource.pkg do
      action :remove
      notifies :run, 'ruby_block[LogUninstallPkgMsg]', :immediate
    end

    # pass a customized message to the writelog function
    ruby_block 'LogUninstallPkgMsg' do
      block do
        writelog "Uninstalled #{new_resource.pkg}"
      end
      action :nothing
    end
  end

  # upgrade the pkg
  action :chocopkgupgrade do
    chocolatey_package new_resource.pkg do
      action :upgrade
      notifies :run, 'ruby_block[LogUpgradePkgMsg]', :immediate
    end

    # pass a customized message to the writelog function
    ruby_block 'LogUpgradePkgMsg' do
      block do
        writelog "Upgraded #{new_resource.pkg}"
      end
      action :nothing
    end
  end

action :installpspkg do
  powershell_package new_resource.pspkg do #'PSWindowsUpdate'
    notifies :run, 'ruby_block[LogPsPkgMsg]', :immediate
  end

  # pass a customized message to the writelog function
  ruby_block 'LogPsPkgMsg' do
    block do
      writelog "Installed PS Module #{new_resource.pspkg}"
    end
    action :nothing
  end
end

# Try running updates daily with the time set via attribute
# The force property will cause the task to be overwritten
action :winupdatetask do
  windows_task 'windows-update' do
    command "powershell get-date | out-file -append c:\scripts\WindowsUpdateLog.log; get-windowsupdate -Install -AcceptAll -AutoReboot | out-file -append #{node['swinstall']['logfile']}"
    run_level :highest
    frequency :daily
    start_time new_resource.updatestarttime
    force
  end
end

# this does not work as expected/hoped do not use without more research
action :clientupdate do
  chef_client_updater 'Install a diff client version' do
    version chefclientver
    post_install_action 'exec'
  end
end
# /does not work

def writelog(msg)
    logfile = Chef::Util::FileEdit.new(node['swinstall']['logfile'].to_s)
    logfile.insert_line_if_no_match('~~~~~~~~~~', "logged: #{Time.new.strftime('%Y-%m-%d %H:%M:%S')}")
    logfile.insert_line_if_no_match('~~~~~~~~~~', "#{msg}")
    logfile.insert_line_if_no_match('~~~~~~~~~~', '')
    logfile.write_file
  end