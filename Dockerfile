FROM ubuntu:13.10

RUN apt-get update
RUN apt-get install -y git make curl software-properties-common sudo wget man openssh-server
RUN apt-get install -y iptables ca-certificates lxc
RUN git clone https://github.com/progrium/dokku /root/dokku
RUN cd /root/dokku; make sshcommand pluginhook copyfiles
RUN dokku plugins-install

RUN wget -O /root/buildstep.tar.gz $(grep PREBUILT_STACK_URL /root/dokku/Makefile | head -n1 | cut -d' ' -f3)

VOLUME ["/home/dokku","/var/lib/docker"]

ENV HOME /root
WORKDIR /root
ADD ./setup.sh /root/setup.sh
ADD ./wrapdocker /usr/local/bin/wrapdocker
ADD https://get.docker.io/builds/Linux/x86_64/docker-latest /usr/local/bin/docker
RUN chmod +x /usr/local/bin/docker /usr/local/bin/wrapdocker
RUN touch /root/.firstrun

EXPOSE 22
EXPOSE 80
EXPOSE 443

CMD ["bash", "/root/setup.sh"]
