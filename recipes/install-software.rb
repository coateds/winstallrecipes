# This is approximately my version 3 at putting together a general software installation recipe
# The major new functionality is to log (most) software installation activities to a separate log.
# Much of this recipe allows for automatic installation of software, particulary with windows update
# patching and new versions of installed Chocolatey packages.

# This recipe calls custom resouces from swinst.rb

# The first task is to set up the log file

# An interesting question is where to set up the attributes for the log directory and log file.
# There should be defaults built in, but by configuring with attributes, they can be overridden
# at the server level if needed. The defaults can be placed in an attribute file of this cookbook,
# but by placing them in this recipe, it is a bit easier to document.
node.default['swinstall']['logdir'] = 'c:/logs'
node.default['swinstall']['logfile'] = 'c:/logs/swinst.log'

# This calls a grouping of recources that create the log directory and file, plus add the first entry
winstallrecipes_swinstall 'setup swinst log' do
  action :setuplog
  logdir node['swinstall']['logdir']
  logfile node['swinstall']['logfile']
end

# The next thing to do is to install Chocolatey
# Unfortunately, I have not found a way to write a log entry only when Chocolatey is first installed
# Of course, I could just include the recipe right here, but I will keep with the format for now
winstallrecipes_swinstall 'install chocolatey' do
  action :instchoco
end

# At this point, I want to install PowerShell 5.1 if needed. The method used will depend on Test-Kitchen or Server.
if node.run_state['client-initiator'] = 'testkitchen'
  puts "Test Kitchen!"
else
  puts "Chef Server!"
end



# This is a demonstrator block for installing an older version of a pkg
# or a version that is intended to stay static (no auto upgrade)
# winstallrecipes_swinstall 'install old version of notepad++' do
#   pkg 'notepadplusplus'
#   ver '7.5.3'
#   action :chocopkginstall
# end

# 'dotnet4.5.2',  ---  does not work under some circumstances due to msu over winrm issues
# but does a node of a chef server use winrm???
# dotnet4.5.2 installs just fine on a chef server node!!
# Fill in the array of the installs attribube for packages that should be on every node
# or just used within test-kitchen
node.default['swinstall']['upgrade-chocopkgs'] = []
node['swinstall']['upgrade-chocopkgs'].each do |item|
  winstallrecipes_swinstall 'upgrade' do
    pkg item
    action :chocopkgupgrade
  end
end

node.default['swinstall']['uninstall-chocopkgs'] = ['curl']
node['swinstall']['uninstall-chocopkgs'].each do |item|
  winstallrecipes_swinstall 'uninstall' do
    pkg item
    action :chocopkguninstall
  end
end

# Set this value in chef server object attributes
node.default['swinstall']['updatetasktime'] = '14:45'

node.default['swinstall']['updatetasktime'] = '23:55' if node['swinstall']['updatetasktime'].nil?
winstallrecipes_swinstall 'config win update task' do
  action :winupdatetask
  updatestarttime node['swinstall']['updatetasktime']
end

winstallrecipes_swinstall 'install ps module' do
  action :installpspkg
  pspkg 'PSWindowsUpdate'
end