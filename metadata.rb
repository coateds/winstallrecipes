name 'winstallrecipes'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures winstallrecipes'
long_description 'Installs/Configures winstallrecipes'
version '0.1.6'
chef_version '>= 12.1' if respond_to?(:chef_version)

# v0.1.6 first tries at ps updates including pswindowsupdates module install

# v0.1.5 choco install choco msu on node (not winrm?) plus choco install

# v0.1.4 Add create and write to log file

# v0.1.3 Add Join/Unjoin AD

# v0.1.2 Attribute and resource for log file and directory

# v0.1.1 Add computer rename functionality

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/winstallrecipes/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/winstallrecipes'

depends 'chocolatey'
depends 'chef_client_updater'
