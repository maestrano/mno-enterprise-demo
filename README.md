# Maestrano Enterprise Demo

Generic mno-enterprise express project

## Getting started

Update `config/settings/development.yml` and `config/application.yml` with the configuration you've been provided with.


```
$ bundle
$ foreman start
```

Open http://localhost:7000/ in your browser

## What's in it?

* Generic mno-enterprise host project, generated using the [rails app template](https://github.com/maestrano/mno-enterprise/tree/master/rails-template)
* [Custom fonts](https://github.com/maestrano/mno-enterprise#adding-a-custom-font)
* Impac! KPIs
* Impac! Dashboard printing

## Upgrading

```
# Update mno-enterprise
bundle update mno-enterprise

# Rebuild the admin-frontend
rm -rf tmp/build tmp/cache
bin/rake mnoe:admin:dist
bin/rake mnoe:frontend:update
```
