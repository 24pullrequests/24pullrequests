rbenv
========

Role for installing [rbenv](https://github.com/sstephenson/rbenv).

Role ready status
------------

[![Build Status](https://travis-ci.org/zzet/ansible-rbenv-role.png?branch=master)](https://travis-ci.org/zzet/ansible-rbenv-role)

Requirements
------------

none

Role Variables
--------------

Default variables are:

    rbenv:
      env: system
      version: v0.4.0
      ruby_version: 2.0.0-p247

    rbenv_repo: "git://github.com/sstephenson/rbenv.git"

    rbenv_plugins:
      - { name: "rbenv-vars",
          repo: "git://github.com/sstephenson/rbenv-vars.git",
          version: "v1.2.0" }

      - { name: "ruby-build",
          repo: "git://github.com/sstephenson/ruby-build.git",
          version: "v20131225.1" }

      - { name: "rbenv-default-gems",
          repo: "git://github.com/sstephenson/rbenv-default-gems.git",
          version: "v1.0.0" }

      - { name: "rbenv-installer",
          repo: "git://github.com/fesplugas/rbenv-installer.git",
          version: "8bb9d34d01f78bd22e461038e887d6171706e1ba" }

      - { name: "rbenv-update",
          repo: "git://github.com/rkh/rbenv-update.git",
          version: "32218db487dca7084f0e1954d613927a74bc6f2d" }

      - { name: "rbenv-whatis",
          repo: "git://github.com/rkh/rbenv-whatis.git",
          version: "v1.0.0" }

      - { name: "rbenv-use",
          repo: "git://github.com/rkh/rbenv-use.git",
          version: "v1.0.0" }

    rbenv_root: "{% if rbenv.env == 'system' %}/usr/local/rbenv{% else %}~/.rbenv{% endif %}"

    rbenv_users: []

Description:

- ` rbenv.env ` - Type of rbenv installation. Allows 'system' or 'user' values
- ` rbenv.version ` - Version of rbenv to install (tag from [rbenv releases page](https://github.com/sstephenson/rbenv/releases))
- ` rbenv.ruby_version ` - Version of ruby to install as global rbenv ruby
- ` rbenv_repo ` - Repository with source code of rbenv to install
- ` rbenv_plugins ` - Array of Hashes with information about plugins to install
- ` rbenv_root ` - Install path
- ` rbenv_users ` - Array of Hashes with users for multiuser install. User must be present in the system

Example:

    - hosts: web
      vars:
        rbenv:
          env: user
          version: v0.4.0
          ruby_version: 2.0.0-p353
      roles:
        - role: zzet.rbenv
          rbenv_users:
            - { name: "user", home: "/home/user/", comment: "Deploy user" }

Dependencies
------------

none

License
-------

MIT

Author Information
------------------

[Andrew Kumanyaev](http://github.com/zzet)

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/zzet/ansible-rbenv-role/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

