"Data Science Workbench"
============

This is a shell script that spins up several popular data science-y server environments on one box. This script is
tested and verified on Ubuntu 14.01.

This environment is built for a fresh install of Ubuntu 14.04. It will update/upgrade all base packages and
install all needed dependencies. Software packages installed include:

 - [R](http://www.r-project.org/)
 - [RStudio Server](https://www.rstudio.com/products/rstudio/download-server/)
 - [Shiny-Server](http://www.rstudio.com/shiny/)
 - [Anaconda Python](https://www.continuum.io/downloads): 
        Anaconda inclues [Jupyter Notebook](http://jupyter.org/) (formerly IPython Notebook).
 - [Jupyterhub](https://github.com/jupyter/jupyterhub): A multi-user server for Jupyter Notebook.
 - [PostgreSQL Database](http://www.postgresql.org/): Because every data science box needs a decent database.

Installation
============

Download or copy the shell script and run it on your Ubuntu box under your home user:

	$ ./data_science_workbench.sh

WARNING: Don't execute as root, it needs your home directory for a couple things.

Post-installation
============

You'll be dumped into a Tmux shell since the Anaconda environment needs a new shell session to take affect.

Once you restart, Anaconda will be your default environment for Python and Pip.

Configuration
=============

After the script finishes, you'll have a few things running on their default ports.

 - RStudio: On localhost:8787 (Username and password set in the script)
 - Shiny-Server: On localhost:3838 (No username or password)
 - Jupyterhub not started by default but you can fire it up with the command `jupyterhub`.
   On localhost:8000 (Username and password are the same as those of the Ubuntu user that ran the script.)

SSL Authentication?
=============

By default Jupyterhub use basic authentication, although SSL is available. To set
up SSL, see the [Jupytherhub documentation](https://github.com/jupyter/jupyterhub/blob/master/docs/getting-started.md#Security).

Shiny and RStudio Server are differant stories. Shiny open-souce edition ships with no authentication whatsoever, 
and RStudio Server only wiht basic auth. Both offer "Enterprise" editions, which offer SSL. 

The simple solution
would be to use an Apache2 reverse proxy to add SSL to both, but I have a feeling that may violate the
terms of service. I'm too lazy to read the entire TOS, so I'll just recomend you don't do it. They are both
licensed under [AGPL v3](https://opensource.org/licenses/AGPL-3.0) if anyone is interested.

Other Data Science Boxes
=============

In all fairness to the open-source ethos, the idea for this box came from the [Data Science Box](https://github.com/drewconway/data_science_box), which is based on Ubuntu 12.04. 

So, if you're looking for something for an older machine, there you go! That box differs in the fact that it does not
install Anaconda, Postgres, Jupyter Notebook or Jupyterhub. Instead it uses the older IPython Notbook and IPython Server set-ups. Those aren't in current development anymore but may work better for older versions of Ubuntu.





