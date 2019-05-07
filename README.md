huntprod/fwbase
===============

This Docker image (`huntprod/fwbase`) serves as a decent jumping
off point for packaging up complex, host-specific firewall rules
into a Docker container image, for distribution to one or more
hosts (not running something "bigger" like k8s or swarm).

Running the Image
-----------------

You always want these flags:

    --net=host       Put the container in the host's network
                     namespace (so it can see the interfaces)

    --privileged     Run the container with a subset of root's
                     capabilities, so it can muck about with
                     the kernel, for iptables manipulation.

To validate that everything is working, run it, interactively,
with no arguments to get an iptables listing (via `-L -nv`):

    $ docker run -it --net=host --rm --privileged huntprod/fwbase
    Chain INPUT (policy ACCEPT 1474K packets, 1274M bytes)
     pkts bytes target     prot opt in     out     source               destination

    Chain FORWARD (policy DROP 0 packets, 0 bytes)
     pkts bytes target     prot opt in     out     source               destination
    5804K  739M DOCKER-USER  all  --  *      *       0.0.0.0/0            0.0.0.0/0
    5804K  739M DOCKER-ISOLATION-STAGE-1  all  --  *      *       0.0.0.0/0            0.0.0.0/0
     5517   32M ACCEPT     all  --  *      docker0  0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
    ... etc ...

Usually, however, you'll want to bake in your own rules.

Building a Custom Firewall
--------------------------

As the `base` suffix implies, you'll want to use this image as a
`FROM` line in a custom image that encodes your rules.

When the container entrypoint (`/init`) starts up, it looks for a
file at `/etc/firewall.sh`; if that exists, the initialization
script runs it.  You can add this file to a custom image you build
on top of `fwbase` with the following Dockerfile:

    FROM huntprod/fwbase:latest
    ADD firewall.sh /etc/firewall.sh

Then, when you run the image (using the `--privileged` and
`--net=host` flags mentioned above), you'll end up with a firewall
configured according to the script you added.

What This Image Really Provides
-------------------------------

The secret: not much.  All this base image is giving you is:

  1. Alpine Linux 3.9
  2. The `iptables` package pre-loaded
  3. An entrypoint
  4. Support for a user-supplied `/etc/firewall.sh`

The rest is up to you!

Nuts-n-Bolts
------------

The code for this Docker image is hosted at
<https://github.com/huntprod/fwbase>.

The Dockerfile is at
<https://github.com/huntprod/fwbase/blob/master/Dockerfile>.
