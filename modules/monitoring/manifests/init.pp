class monitoring {

  package { 'python-rrdtool':
    ensure => 'installed',
  }

  include nagios
  include ganglia
  include graphite

  include govuk::htpasswd

  # Include monitoring-server-only checks
  include monitoring::checks

  $domain = extlookup('app_domain')
  $vhost = "monitoring.${domain}"
  $enable_ssl = str2bool(extlookup('nginx_enable_ssl', 'yes'))

  nginx::config::ssl { $vhost: certtype => 'wildcard_alphagov' }
  nginx::config::site { $vhost:
    content => template('monitoring/nginx.conf.erb'),
  }

  file { '/opt/graphite/storage/rrd/ganglia':
    ensure => link,
    target => '/var/lib/ganglia/rrds/GDS/',
  }

  file { '/var/www/monitoring':
    ensure => directory,
  }

  file { '/var/www/monitoring/index.html':
    ensure  => present,
    content => template('monitoring/index.html.erb'),
    require => File['/var/www/monitoring'],
  }

  file { '/var/www/ganglia-views':
    ensure  => directory,
    source  => 'puppet:///modules/monitoring/ganglia-views',
    recurse => true,
    force   => true,
    purge   => true,
    owner   => 'www-data',
    group   => 'www-data',
  }

}
