# Dimbu

Dimbu - simple **D**ocker **Im**age **Bu**ilder

## Pre-requisites
* linux
* bash
* docker
* yarn/npm

## How to

Step 1. Add the package:
```
yarn add --dev izonder/dimbu
```

Step 2. Specify a script, make sure you have specified a repo namespace with leading `/`:
```
...
  "scripts": {
    ...
    "build": "dimbu -r myrepo/",
    ...
  }
...
```

Step 3. Type the command:
```
yarn build
```

## CLI

```
Usage: dimbu -r <repo prefix> [-a <build args for Docker image>]
```

Parameters:

`r` - repo namespace, e.g. `myrepo/` or `myregistry.tld:5000/myrepo/`

`a` - (optional) build arguments for Docker images, e.g. `'--build-arg FOO=bar --build-arg BAZ=boo'`

`s` - (optional) silent mode to publish package without prompts 

## FAQ

**Q.** Who is Dimbu?

**A.** Dimbu was a Cragmoloid employed as a bouncer at the Kinyen cantina Chorba Chuggers (proof http://starwars.wikia.com/wiki/Dimbu).