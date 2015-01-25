
# The purpose of this salt state is to remove the salt-minion service that Vagrant installs.
# Vagrant doesn't like to just use salt-call.

salt-minion:
  service.disabled
