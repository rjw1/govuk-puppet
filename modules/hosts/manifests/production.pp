# == Class: hosts::production
#
# Manage /etc/hosts entries for various machines
#
# these are real hosts (1-1 mapping between host and service) anything that
# ends .cluster is maintained for backwards compatibility with ec2
#
# === Parameters:
#
# [*carrenza_vcloud*]
#   Creates an /etc/hosts entry to access the vCloud API from a
#   whitelisted IP without requiring a VPN connection.
#   Default: false
#
# [*external_licensify*]
#   Boolean indicating whether Licensify is hosted externally to this environment.
#
# [*ip_api_lb*]
#   The IP address of the API load-balancer
#
# [*ip_backend_lb*]
#   The IP address of the backend load-balancer
#
# [*ip_bouncer*]
#   The IP address of the bouncer vse load-balancer
#
# [*ip_draft_api_lb*]
#   The IP address of the Draft API load-balancer
#
# [*ip_frontend_lb*]
#   The IP address of the frontend load-balancer
#
# [*ip_licensify_lb*]
#   The IP address of the licensify load-balancer
#
# [*licensify_hosts*]
#   Hash of host entries which should be created for Licensify if it's
#   hosted externally.
#
# [*releaseapp_host_org*]
#   Whether to create the `release.$app_domain` vhost alias within this environment.
#   Default: false
#
class hosts::production (
  $carrenza_vcloud             = false,
  $external_licensify          = false,
  $ip_api_lb                   = '127.0.0.1',
  $ip_backend_lb               = '127.0.0.1',
  $ip_bouncer                  = '127.0.0.1',
  $ip_draft_api_lb             = '127.0.0.1',
  $ip_frontend_lb              = '127.0.0.1',
  $ip_licensify_lb             = '127.0.0.1',
  $licensify_hosts             = {},
  $releaseapp_host_org         = false,
) {

  $app_domain = hiera('app_domain')

  validate_bool($carrenza_vcloud)

  if !is_ip_address($ip_api_lb) {
    fail("ip_api_lb is not a valid IP address: ${ip_api_lb}")
  }
  if !is_ip_address($ip_backend_lb) {
    fail("ip_backend_lb is not a valid IP address: ${ip_backend_lb}")
  }
  if !is_ip_address($ip_bouncer) {
    fail("ip_bouncer is not a valid IP address: ${ip_bouncer}")
  }
  if !is_ip_address($ip_draft_api_lb) {
    fail("ip_draft_api_lb is not a valid IP address: ${ip_draft_api_lb}")
  }
  if !is_ip_address($ip_frontend_lb) {
    fail("ip_frontend_lb is not a valid IP address: ${ip_frontend_lb}")
  }
  if !is_ip_address($ip_licensify_lb) {
    fail("ip_licensify_lb is not a valid IP address: ${ip_licensify_lb}")
  }

  #api vdc machines
  class { 'hosts::production::api':
    app_domain           => $app_domain,
    draft_internal_lb_ip => $ip_draft_api_lb,
    internal_lb_ip       => $ip_api_lb,
  }

  #backend vdc machines
  class { 'hosts::production::backend':
    app_domain          => $app_domain,
    releaseapp_host_org => $releaseapp_host_org,
    internal_lb_ip      => $ip_backend_lb,
  }

  #efg vdc machines
  govuk::host { 'efg-mysql-master-1':
    ip             => '10.4.0.10',
    vdc            => 'efg',
    legacy_aliases => ['efg.master.mysql'],
  }

  govuk::host { 'efg-frontend-1':
    ip  => '10.4.0.2',
    vdc => 'efg',
  }
  govuk::host { 'efg-mysql-slave-1':
    ip             => '10.4.0.11',
    vdc            => 'efg',
    legacy_aliases => ['efg.slave.mysql'],
  }

  # elms (licence finder) vdc machines
  class { 'hosts::production::licensify':
    app_domain     => $app_domain,
    internal_lb_ip => $ip_licensify_lb,
  }

  #frontend vdc machines
  class { 'hosts::production::frontend':
    app_domain     => $app_domain,
    internal_lb_ip => $ip_frontend_lb,
  }

  #management vdc machines
  class { 'hosts::production::management': }

  # redirector vdc machines
  class { 'hosts::production::redirector':
    ip_bouncer => $ip_bouncer,
  }

  #router vdc machines
  class { 'hosts::production::router': }

  # 3rd-party hosts
  host { 'gds01prod.aptosolutions.co.uk':
    ip => '185.40.10.139',
  }

  if $carrenza_vcloud{
    host { 'vcloud-no-vpn.carrenza.com':
      ip => '31.210.240.69',
    }
  }

  if $external_licensify {
    create_resources('host', $licensify_hosts)
  }
}
