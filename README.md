# uzyexe/foreman

## What is foreman

Foreman is a complete lifecycle management tool for physical and virtual servers.

[http://theforeman.org/](http://theforeman.org/)

## Dockerfile

[**Trusted Build**](https://registry.hub.docker.com/u/uzyexe/foreman/)

[**Source Repository**](https://github.com/uzyexe/dockerfile-foreman)

This Docker image is based on the [debian:wheezy](https://registry.hub.docker.com/_/debian/) base image.

## How to use this image

```
docker run -d --name=foreman --net=host uzyexe/foreman

  * Foreman is running at https://your_machine/
      Initial credentials are admin / changeme
  * Foreman Proxy is running at https://your_machine:8443
  * Puppetmaster is running at port 8140
  The full log is at /var/log/foreman-installer/foreman-installer.log
```
