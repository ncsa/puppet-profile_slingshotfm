# @summary Install and Configure Fabric Manager
#
# Install and configure fabric manager
#
# @example
#   include profile_slingshot::fm
class profile_slingshot::fm (
  Boolean         $enable,
  Array[ String ] $required_pkgs,
) {

  if ($enable) {
    #exec { 'dnf-modules':
    #  path        => $path,
    #  command     => 'dnf -y module reset php container-tools nginx',
    #  require      => Exec['dnf-enable'],
    #  refreshonly => true,
    #}
    exec { 'slingshot-dnf-modules':
      path     => $path,
      provider => shell,
      command  => 'dnf -y module reset php container-tools nginx;dnf -y module enable php:7.3 nginx:1.16 container-tools',
      before   => Package['slingshot-fmn-redhat'],
      onlyif   => 'rpm -e --test slingshot-fmn-redhat',
    }
    package { 'slingshot-fmn-redhat':
      ensure  => installed,
      require => Exec['slingshot-dnf-modules'],
    }
    Exec['slingshot-dnf-modules'] -> Package['slingshot-fmn-redhat']
  }
}
