# install flask from pip3
package { 'python3-pip':
  ensure => installed,
}

exec { 'install_flask':
  command     => '/usr/bin/pip3 install flask==2.1.0',
  path        => ['/usr/bin', '/usr/local/bin'],
  unless      => '/usr/bin/flask --version | grep "2.1.0"',
  require     => Package['python3-pip'],
  environment => ['PIP_DISABLE_PIP_VERSION_CHECK=1'],
}
