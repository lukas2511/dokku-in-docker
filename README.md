Dokku inside Docker.

Run with something like this:

```bash
docker run -d -t -i -e VHOSTNAME=example.org -e USERNAME=progrium -e PUBKEY='your ssh pubkey here' --privileged -p 22 -p 80 --name dokku lukas2511/dokku-in-docker
```

You can attach to the container to get a shell.
