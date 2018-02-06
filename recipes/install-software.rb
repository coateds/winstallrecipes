# This will install Chocolatey if not already
# include_recipe 'chocolatey::default' do
#   # goober
#   notifies :run, 'ruby_block[name]', :immediate
# end
#
# ruby_block 'name' do
#   block do
#     puts "install chocolatey?!?!?!"
#     logfile = Chef::Util::FileEdit.new('c:/scripts/file.txt')
#     logfile.insert_line_if_no_match('~~~~~~~~~~', "logged: #{Time.new.strftime('%Y-%m-%d %H:%M:%S')}")
#     logfile.insert_line_if_no_match('~~~~~~~~~~', "Goober!!")
#     logfile.insert_line_if_no_match('~~~~~~~~~~', '')
#     logfile.write_file
#   end
#   action :nothing
# end


winstallrecipes_swinstall 'setup swinst log' do
  action :setuplog
end

winstallrecipes_swinstall 'install chocolatey' do
  action :instchoco
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

node.default['swinstall']['uninstall-chocopkgs'] = []
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