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

