# Prerequisites #
* Docker Desktop (available on [homebrew](https://formulae.brew.sh/formula/docker#default) or [official site](https://www.docker.com/products/docker-desktop/))
* Visual Studio Code (available on [homebrew](https://formulae.brew.sh/cask/visual-studio-code#default) or [official site](https://code.visualstudio.com/download))
* [VS Code Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

# Getting Started #

1. Open this repository in Visual Studio Code.
1. When prompted, reopen the workspace in a development container.
1. Open a terminal.
1. Run `solution start`.  

This will spin up all of the solution's docker containers on your physical machine's docker engine.  Likewise, to stop your solution's containers, run `stop-solution`.

There are various commands in the `auto` folder of this repository.  Please review that folder for more information.

For your convenience, your laptop's `~/.ssh` folder is mounted into this dev container.  This will give you permissions to perform github operations right inside the container.

# Grafana #
The grafana endpoint is hosted at http://localhost:3000.  To log in for the first time, use the username `admin` and the password `admin`.  

After logging in, you will be asked to update your password.  You can either update it to whatever you want or click the "Skip" button.

If you need to update the grafana server configuration, modify projects/grafana/grafana.ini and re-run `start-solution`.

# Developing #
The focus of this project is to develop grafana dashboards.  For an ergonomic workflow, you can watch for changes in the grafana project, which will automatically build and push your changes to the grafana endpoint.

To do that, run `project grafana watch`.

Happy coding!