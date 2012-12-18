class datainsight::config::google_oauth {
  $google_client_id = extlookup('google_client_id_datainsight')
  $google_client_secret = extlookup('google_client_secret_datainsight')
  $google_analytics_refresh_token = extlookup('google_analytics_refresh_token_datainsight')
  $google_drive_refresh_token = extlookup('google_drive_refresh_token_datainsight')

  file { ["/etc/govuk/datainsight", "/var/lib/govuk/datainsight"]:
    ensure  => directory,
    owner   => "deploy"
  }

  file { "/etc/govuk/datainsight/google_credentials.yml":
    ensure  => present,
    content => template("datainsight/google_credentials.yml.erb"),
    owner   => "deploy"
  }

  # These are in /var/lib because they are initially generated by the application
  file { "/var/lib/govuk/datainsight/google-analytics-token.yml":
    ensure  => present,
    content => template("datainsight/google-analytics-token.yml.erb"),
    owner   => "deploy"
  }

  file { "/var/lib/govuk/datainsight/google-drive-token.yml":
    ensure  => present,
    content => template("datainsight/google-drive-token.yml.erb"),
    owner   => "deploy"
  }
}