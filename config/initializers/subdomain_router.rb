SubdomainRouter::Config.default_subdomain = "app"
Rails.env.production? ? SubdomainRouter::Config.domain = "mywebsite.com" : SubdomainRouter::Config.domain = "lvh.me"
SubdomainRouter::Config.tld_components = 1
SubdomainRouter::Config.subdomain_matcher = ->(subdomain, request) { Organization.subdomain_match(subdomain, request) }
