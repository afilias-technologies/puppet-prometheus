# Class: prometheus::sachet
#
# This module manages the sachet messaging service for prometheus.
#
class prometheus::sachet (
    String $arch                   = $prometheus::real_arch,
    String $bin_dir                = $prometheus::bin_dir,
    Hash $providers,
    Hash $receivers,
    Array[String] $templates,
    String $config_file,
    String $config_mode            = $prometheus::config_mode,
    String $download_extension,
    Optional[String] $download_url = undef,
    String $download_url_base,
    Array[String] $extra_groups,
    String $extra_options          = '',
    String $group,
    String $init_style             = $prometheus::init_style,
    String $install_method         = $prometheus::install_method,
    Boolean $manage_group          = true,
    Boolean $manage_service        = true,
    Boolean $manage_user           = true,
    String $os                     = $prometheus::os,
    String $package_ensure,
    String $package_name,
    Boolean $restart_on_change     = true,
    Boolean $service_enable        = true,
    String $service_ensure         = 'running',
    String $service_name           = 'sachet',
    String $user,
    String $version,
) {

    # Automatically restart service on config change?
    $notify_service = $restart_on_change ? {
        true    => Service[$service_name],
        default => undef,
    }

    $options = "-config ${config_file} ${extra_options}"

    file { $config_file:
        ensure => present,
        owner  => $user,
        group  => $group,
        mode   => $config_mode,
        content => template('prometheus/sachet.yaml.erb'),
        notify  => $service,
    }
    prometheus::daemon { $service_name :
        install_method     => $install_method,
        version            => $version,
        download_extension => $download_extension,
        os                 => $os,
        arch               => $arch,
        bin_dir            => $bin_dir,
        notify_service     => $notify_service,
        package_name       => $package_name,
        package_ensure     => $package_ensure,
        manage_user        => $manage_user,
        user               => $user,
        extra_groups       => $extra_groups,
        group              => $group,
        manage_group       => $manage_group,
        options            => $options,
        init_style         => $init_style,
        service_ensure     => $service_ensure,
        service_enable     => $service_enable,
        manage_service     => $manage_service,
    }

}
