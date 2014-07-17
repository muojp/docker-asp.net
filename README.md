# ASP.NET vNext Docker Image

This Docker image contains a ready-to-go environment to run [ASP.NET vNext][vnext] applications in Linux using [Mono][mono].

See the `Dockerfile` for more details about how the image is built. The image is officially built on [Docker Hub][hub-link].

### Image build outline

* Base image is `ubuntu:latest`
* Builds Mono from its `master` branch. (planning to pick a tag soon since master branch sometimes breaks. v3.6+ tag is not available yet.)
* Updates the certificate store, installs NuGet/MyGet SSL certificates.
* Installs the ASP.NET vNext `kvm` (from its `master` branch).
* Installs the latest KRE.

This should get you a working image with latest official Mono/ASP.NET vNext bits. 

### Build upon this image

If you are writing a Dockerfile, begin with:

    FROM ahmetalpbalkan/aspnet-vnext
    
Or pull this image using the `docker` command:

    $ docker pull ahmetalpbalkan/aspnet-vnext
   
and play with the image you downloaded. In order to use `kvm`, `kpm` and `k` commands you should run `source ~/.kre/kvm/kvm.sh`. 

If you're planning to make a command like `k web` your ENTRYPOINT in your Dockerfile it should look like this:


    ENTRYPOINT /bin/bash -c "source ~/.kre/kvm/kvm.sh && \
        k web"

Unfortuntely, right now the 	ASP.NET commands like `k`, `kpm` and `kvm` are just bash functions, not executables that can be added to the PATH environment variable. So you can only run these in the same shell you sourced the `kvm.sh`, just like above.

### Disclaimer

This project is not affiliated with Microsoft or ASP.NET. It is independently maintained and the purpose is to have a base Docker image where binaries are coming from official Mono & ASP.NET GitHub repositories and versions are carefully picked as stable ones working reliably.

### Known issues

* `kvm upgrade` installs the latest KRE successfully but gives a non-successful exit code (=1). This currently might break the build. ([See issue](https://github.com/aspnet/kvm/issues/31))
* `k` command terminates just after starting while in the container because it expects some input from STDIN. You should use `docker run -i` to keep the process alive. ([See issue](https://github.com/aspnet/Hosting/issues/59))

### TODO

*(Feeling like contributing? Feel free to pick something below.)*

- [ ] Wait for Mono to release a ≥3.6 tag and fix the Mono build number to a stable.
- [ ] Find a way to fix kvm installation (kvminstall.sh) to a stable build.
- [ ] Add link to example Dockerfile built upon this image.
- [ ] Write a blog post about this.
- [ ] Talk about this in a meetup.


[mono]: https://github.com/mono/mono
[hub-link]: https://registry.hub.docker.com/u/ahmetalpbalkan/aspnet-vnext/
[vnext]: http://www.asp.net/vnext