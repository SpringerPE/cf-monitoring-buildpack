# cf-monitoring-buildpack

This is an intermediate buildpack (non final) to automatically enable monitoring compatibility
between service broker instances and plain environment variables.

An intermediate buildpack like this has no software, dependencies, so it is not
capable of executing anything, so you still need to provide another buildpack
to "run" the application.

The functionality is defined in the `.profile.d` folder.

# Using it

In general you can use more than one buildpack on the command line:

```
cf push APP-NAME -b FIRST-BUILDPACK -b SECOND-BUILDPACK -b FINAL-BUILDPACK
```

in the case of a Ruby application

```
cf push APP-NAME -b https://github.com/SpringerPE/cf-monitoring-buildpack.git -b https://github.com/cloudfoundry/ruby-buildpack.git
```

or in a `manifest.yml`:

```
buildpacks:
  - https://github.com/SpringerPE/cf-monitoring-buildpack.git
  - https://github.com/cloudfoundry/ruby-buildpack.git
```

# Alternatives

If you do not want to use multiple buildpacks or CF version does not support it,
just copy the `.profile.d` folder to the folder of your app and re-deploy.

