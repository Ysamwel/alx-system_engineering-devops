# Ensure the file line contains the correct limit
file_line { 'set_nginx_open_files_limit':
  path  => '/etc/default/nginx',
  line  => 'NGINX_ULIMIT=10000',
  match => '^NGINX_ULIMIT=',
  notify => Service['nginx'],  # Notify Nginx service if the line changes
}

# Ensure Nginx service is restarted if necessary
service { 'nginx':
  ensure => running,
  enable => true,
  subscribe => File_line['set_nginx_open_files_limit'],  # Restart Nginx if the configuration changes
}

# Ensure the system-wide limits are properly set
exec { 'increase_system_open_files_limit':
  command => 'echo "* soft nofile 10000\n* hard nofile 10000" >> /etc/security/limits.conf',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  unless  => 'grep -q "10000" /etc/security/limits.conf',  # Only run if not already set
}
