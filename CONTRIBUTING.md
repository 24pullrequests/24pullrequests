# Contributing

 * Fork the project.
 * Make your feature addition or bug fix.
 * Add tests for it. This is important so I don't break it in a future version unintentionally.
 * Send a pull request. Bonus points for topic branches.

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## Using Vagrant

The project comes with a Vagrant setup that you can use to quickly get the app up and running. You'll need:

 * [Vagrant](https://www.vagrantup.com/downloads.html)
 * [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
 * [Ansible](http://docs.ansible.com/intro_installation.html)

Download and install the appropriate packages for your Operating System.

_Windows Users: Ansible does not support Windows as controller machine, but there's a little hack in the Vagrantfile that will allow you to run the provision using a local
SSH connection Guest-Guest. Just install Vagrant and VirtualBox, and you should be able to get it running._

Once you have the dependencies installed, go to the project directory via console and run:

    $ vagrant up

The first time you run _vagrant_, the process will take several minutes, as it will download the base box and run all the tasks necessary to setup the VM server.
Once the process is completed, you need to log in, by running:

    $ vagrant ssh

There's no need to provide login or password. Now go to the project directory inside the VM in order to run the rails server:

    $ cd /vagrant
    $ bundle exec rails s -b 0.0.0.0

This will initialize the development Rails server.
Now you can go to your regular browser, in the Host machine (your main OS) and access the application through the address `http://192.168.12.34:3000`.

Any changes that you make to the app files will be reflected inside the VM server. You can use your regular workflow for development, as if the server was local.

When you want to pause or finish working, you can run:

    $ vagrant suspend

And the VM will be suspended. Whenever you want to get back to it, the state will be saved, you just need to run:

    $ vagrant resume

To get the VM running again, in the state you left it. Remember that if you turn off the VM or if you restart your main OS, you will need to run `vagrant up` again, but this time
it will be much faster because the VM is already provisioned.

For more instructions on how to use Vagrant, have a look at their official documentation: [https://docs.vagrantup.com/v2/getting-started/](https://docs.vagrantup.com/v2/getting-started/).
