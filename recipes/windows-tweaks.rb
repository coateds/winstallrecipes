#
# Cookbook:: windows-installation-recipes
# Recipe:: windows-tweaks
#
# Copyright:: 2017, The Authors, All Rights Reserved.

if node['windows-tweaks']['general-tweaks'].to_s == 'y'
  # I usually place scripts in the following directory, so why not create it right away
  directory 'C:\scripts'

  # This disables the scheduled task that opens Server Manager at everyone's logon
  windows_task '\Microsoft\Windows\Server Manager\ServerManager' do
    action :disable
  end

  # Sometimes the PowerShell 5.1 installation wipes out the icons on the task bar
  # This puts a link on the desktop as a short term fix
  # Remember that the cookbook_file resource copies a file from the cookbook to the client
  # It does not create it
  cookbook_file 'C:\Users\Public\Desktop\Windows PowerShell.lnk' do
    source 'Windows PowerShell.lnk'
  end
end