# == Class: govuk_jenkins::job::deploy_puppet
#
# Create a file on disk that can be parsed by jenkins-job-builder
#
# === Parameters
#
# [*auth_token*]
#   Token which will allow this job to be triggered remotely
#
class govuk_jenkins::job::deploy_puppet (
  $auth_token = undef,
) {
  file { '/etc/jenkins_jobs/jobs/deploy_puppet.yaml':
    ensure  => present,
    content => template('govuk_jenkins/jobs/deploy_puppet.yaml.erb'),
    notify  => Exec['jenkins_jobs_update'],
  }
}
