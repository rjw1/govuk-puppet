# == Class: govuk::apps::content_tagger
#
# App to tag content on GOV.UK.
#
# === Parameters
#
# [*port*]
#   The port that the app is served on.
#   Default: 3116
#
# [*secret_key_base*]
#   The key for Rails to use when signing/encrypting sessions.
#
# [*errbit_api_key*]
#   Errbit API key used by airbrake
#
# [*db_hostname*]
#   The hostname of the database server to use in the DATABASE_URL.
#
# [*db_username*]
#   The username to use in the DATABASE_URL.
#
# [*db_password*]
#   The password for the database.
#
# [*db_name*]
#   The database name to use in the DATABASE_URL.
#
# [*oauth_id*]
#   Sets the OAuth ID
#
# [*oauth_secret*]
#   Sets the OAuth Secret Key
#
class govuk::apps::content_tagger(
  $port = '3116',
  $secret_key_base = undef,
  $errbit_api_key = '',
  $db_hostname = undef,
  $db_username = 'content_tagger',
  $db_password = undef,
  $db_name = 'content_tagger_production',
  $oauth_id = '',
  $oauth_secret = '',
) {
  $app_name = 'content-tagger'

  govuk::app { $app_name:
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }

  Govuk::App::Envvar {
    app => $app_name,
  }

  if $secret_key_base {
    govuk::app::envvar { "${title}-SECRET_KEY_BASE":
      varname => 'SECRET_KEY_BASE',
      value   => $secret_key_base;
    }
  }

  govuk::app::envvar {
    "${title}-ERRBIT_API_KEY":
      varname => 'ERRBIT_API_KEY',
      value   => $errbit_api_key;
    "${title}-OAUTH_ID":
      varname => 'OAUTH_ID',
      value   => $oauth_id;
    "${title}-OAUTH_SECRET":
      varname => 'OAUTH_SECRET',
      value   => $oauth_secret;
  }

  if $::govuk_node_class != 'development' {
    govuk::app::envvar::database_url { $app_name:
      type     => 'postgresql',
      username => $db_username,
      password => $db_password,
      host     => $db_hostname,
      database => $db_name,
    }
  }
}