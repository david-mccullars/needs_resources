# needs_resources

## DESCRIPTION:

Needs-resources is an extremely lightweight Inversion of Control provider of
resources for an application.  When an application needs to interact with any
number of external resources or configurable components, this allows for a
generic, standard way of externalizing those resources in a minimal effort
sort of way.

## SUPPORT:

The [bug tracker](https://github.com/david-mccullars/needs_resources/issues)
is available here:

  * https://github.com/david-mccullars/needs_resources/issues

## SYNOPSIS:

```ruby
class LinuxHost
  include NeedsResources::NestedResourceType

  attr :ip, :required => true
  attr :hostname, :username, :required => false
end

class Service
  include NeedsResources::ResourceType

  attr :port, :required => true
  attr :admin_email, :default => 'admin@xyz.com'
end

class MyApplication
  extend NeedsResources

  needs_resource :linux_host
  linux_host.needs_resources :http_service, :https_service, :smtp_service

  def main
    NeedsResources.ensure_resources

    puts "My linux host is #{linux_host.ip} (#{linux_host.hostname})"

    puts "It has the following services:"
    linux_host.resources.each do |name, service|
      puts "  * #{name} - port #{service.port} [#{service.admin_email}]"
    end

    puts "We can also reference nested resources by name, e.g. #{linux_host.http_service.admin_email}"
  end
end

MyApplication.new.main
```

Resources can be specified in one of three places:

* Home directory (~/.resources)
* Current working directory (.resources)
* Environment variable (RESOURCES=/home/foo/my.resources)

Only the latter option allows for a custom file name.

The following would be an example .resources file for the above setup:

```json
---
linux_host:
  ip: 10.10.0.42
  hostname: archimedes
  resources:
    http_service:
      port: 8080
    https_service:
      port: 8443
    smtp_service:
      port: 587
      admin_email: email.admin@xyz.com
```

## Requirements

* ruby 1.9.3 or higher
