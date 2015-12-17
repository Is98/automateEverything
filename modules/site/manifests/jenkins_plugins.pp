class site::jenkins_plugins {
  # This resource default will ensure the Jenkins service
  # restarts automatically after Puppet configures all plugins.
  Jenkins::Plugin { notify => Class[jenkins::service] }
  # Tell Puppet to configure and manage the Jenkins Git Plugin.
  jenkins::plugin { 'rake': }
  jenkins::plugin { 'git': }
  jenkins::plugin { 'jira': }
}
