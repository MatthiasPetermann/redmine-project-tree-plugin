# Development Setup

See scripts/setup-dev-environment.sh

Precompile assets:

```
podman exec -it redmine
~/redmine $ RAILS_ENV=production bundle exec rake assets:clobber
~/redmine $ RAILS_ENV=production bundle exec rake assets:precompile
podman pod stop --all
podman pod start --all
```
