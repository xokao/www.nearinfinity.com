file { '/etc/motd' :
  content => "\nWelcome to your Vagrant-built virtual machine!\nManaged by Puppet.\n\nwww> cd /vagrant\nwww> bundle exec rake jekyll server\n\nlocal> open http://localhost:4000\n\n",
}

exec { 'aptitude-update' :
  command => '/usr/bin/aptitude update',
  logoutput => 'on_failure',
}

Package {
  provider => 'aptitude',
  require => Exec['aptitude-update'],
}

package { 'build-essential' :
  ensure => present,
}

package { 'ruby-1.9' :
  name => 'ruby1.9.3',
  ensure => present,
}

package { 'ruby-dev' :
  name => 'ruby1.9.1-dev',
  ensure => present,
  require => Package['ruby-1.9'],
}

package { ['libxslt-dev', 'libxml2-dev'] :
  ensure => present,
}

package { ['python', 'python-pip'] :
  ensure => present,
}

package { 'bundler' :
  ensure   => present,
  provider => 'gem',
  require => Package['ruby-dev'],
}

package { 'Pygments' :
  ensure   => present,
  provider => 'pip',
  require => Package['python-pip'],
}

exec { 'bundle-install' :
  cwd => '/vagrant',
  command => '/usr/local/bin/bundle install',
  require => [ Package['bundler'], Package['libxslt-dev'], Package['libxml2-dev'] ],
  logoutput => true,
}

package { 'git' :
  ensure => present,
}

file { '/home/vagrant/.ssh/config' :
  content => "IdentityFile /home/vagrant/dot-ssh/id_rsa",
}