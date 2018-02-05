# winstallrecipes

This is going to be a refactor of windows-installation-recipes with an eye toward utilizing more custom resources. In fact, I discovered that calling custom resources when there are hyphens in the cookbook name can be problematic. Hence, a new name.

## Recipes envisioned
The recipes I envision in this new cookbook will include:
* windows-tweaks - set up some directories, get rid of server manager at start up
* software-installation - The goal is to
* access-rdp - Grant permissions and set up firewall for allowing RDP access. This could use a good re-factor

## ToDo:
* finish windows-tweaks -- recipe and tests for rename computer/reboot

## Log:
* Plumbed up basic operation of windows-tweaks
* Tested via ChefSpec
* Generate files and copy PowerShell link
* Kitchen Create/Converge
