FROM vtajzich/java:oracle-java8

RUN apt-get update && apt-get -y install openssh-server git && mkdir ~/.ssh && chmod 700 ~/.ssh

ADD id_rsa /root/.ssh/
ADD id_rsa.pub /root/.ssh/

RUN cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys && chmod -R 600 /root/.ssh && mkdir /var/run/sshd && chmod 0755 /var/run/sshd

RUN locale-gen en_US.UTF-8

ENV LC_ALL en_US.UTF-8

EXPOSE 5005

CMD ["/usr/sbin/sshd", "-D"]