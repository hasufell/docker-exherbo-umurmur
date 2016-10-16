## Installation

```sh
docker build -t hasufell/exherbo-umurmur .
```

## Configuration

All configuration variables (except channel configuration)
from the [config file](https://code.google.com/p/umurmur/wiki/Configuring02x)
can simply be set when starting the container via the `-e` switches. E.g.
if you want to set `password = "abc";` in `umurmur.conf` you just pass
`-e password=abc` to the `docker run` command.

If you don't like the `-e`-foo just modify `config/umurmur.conf` and
`config/channels.conf` in-place in this repository or mount them into
the container from the host.

### Channels

Either modify `config/channels.conf` directly or mount your own `channels.conf`
in from the host. It must be in the container at the location
`/umurmurconfig/channels.conf`! So e.g.:

```sh
	-v /var/lib/umurmurconf/channels.conf:/umurmurconfig/channels.conf
```

### Certificates

Mount in your private key and certificate from the host into the container,
e.g. at `/etc/ssl/` and then pass the environment variables `certificate`
and `private_key` to `docker run`.

E.g.:

```sh
	-v /ets/ssl/mydomain:/etc/ssl/mydomain \
	-e certificate=/etc/ssl/mydomain/foo.crt \
	-e private_key=/etc/ssl/mydomain/foo.key
```

## Running

A full command could look like this:

```sh
docker run -ti -d \
	--name=umurmur \
	-v /var/lib/umurmurconf/channels.conf:/umurmurconfig/channels.conf \
	-v /ets/ssl/mydomain:/etc/ssl/mydomain \
	-e certificate=/etc/ssl/mydomain/foo.crt \
	-e private_key=/etc/ssl/mydomain/foo.key \
	-e password=blah \
	-e admin_password=foo \
	-e username=murmur \
	-e groupname=murmur \
	-p 64738:64738 \
	hasufell/exherbo-umurmur
```


