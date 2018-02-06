# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html

property :chefclientver, String

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