#This class will create prometheus yaml file to collect information for webs urls, redirects
#it will check that url is existed, that content is right, that redirects are existed

prometheus::webservices {
  $websites = hash_hiera("websites");

  concat::fragment{ 'blackbox_website.yml' :
    target  => "/usr/local/etc/blackbox_exporter.yml",
    content => template('prometheus/blackbox_websites.yaml.erb'),
    order => '10',
  }
    concat::fragment{ 'prometheus_ws.yaml' :
    target  => "/usr/local/etc/prometheus/prometheus.yaml",
    content => template('prometheus/prometheus_ws.yaml.erb'),
    order => '10',
  }
}