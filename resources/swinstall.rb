# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html

property :chefclientver, String

# attempting to use chef client updater cookbook
# Too many difficulties
# Use something like this to call from a recipe
# winstallrecipes_swinstall 'install a diff chef client version' do
#   chefclientver '13.7.16'
#   action :clientupdate
# end


action :clientupdate do
  chef_client_updater 'Install a diff client version' do
    version chefclientver
    post_install_action 'exec'
  end
end