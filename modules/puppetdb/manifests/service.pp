# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class puppetdb::service {

  service { 'puppetdb':
    ensure  => running,
  }

}
