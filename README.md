# Getting Started #

To get started, run `start-solution`.  

This will spin up all of the solution's docker containers on your physical machine's docker engine.  Likewise, to stop your solution's containers, run `stop-solution`.

There are various commands in the `auto` folder of this repository.  Please review that folder for more information.

For your convenience, your laptop's `~/.ssh` folder is mounted into this dev container.  This will give you permissions to perform github operations right inside the container.

# Grafana #
The grafana endpoint is hosted at http://localhost:3000.  To log in for the first time, use the username `admin` and the password `admin`.  

After logging in, you will be asked to update your password.  You can either update it to whatever you want or click the "Skip" button.

If you need to update the grafana server configuration, modify projects/grafana/grafana.ini and re-run `start-solution`.