file { '/etc/motd' :
  content => "\nWelcome to your Vagrant-built virtual machine!\nManaged by Puppet.\n\n",
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

package { 'ruby1.9.3' :
  ensure => present,
}

package { 'ruby1.9.1-dev' :
  ensure => present,
  require => Package['ruby1.9.3'],
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
  require => Package['ruby1.9.1-dev'],
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
