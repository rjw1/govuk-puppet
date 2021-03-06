# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::ghe_vpn {

  host { 'github.gds':
    ip      => '192.168.9.110',
    comment => 'Ignore VPN DNS and set static host for GHE',
  }

  # Other params come from hiera.
  class { '::openconnect':
    dnsupdate => false,
  }

  @@icinga::check { "check_openconnect_upstart_up_${::hostname}":
    check_command       => 'check_nrpe!check_upstart_status!openconnect',
    service_description => 'openconnect upstart up',
    host_name           => $::fqdn,
  }

  @icinga::nrpe_config { 'check_ghe_responding':
    source => 'puppet:///modules/govuk/ghe_vpn/nrpe_check_ghe.cfg',
  }

  @@icinga::check { "check_ghe_connection_on_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_ghe_responding',
    service_description => 'connection to github.gds failing',
    host_name           => $::fqdn,
  }
}
