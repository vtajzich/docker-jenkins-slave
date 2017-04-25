FROM fedora:25

RUN dnf -y update && dnf -y install iputils net-tools wget openssh-server supervisor git && mkdir ~/.ssh && chmod 400 ~/.ssh && dnf clean all

RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/run/supervisord

ENV JAVA_VERSION 8u131
ENV BUILD_VERSION b11

RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/d54c1d3a095b4ff2b6607d096fa80163/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm

RUN dnf -y install /tmp/jdk-8-linux-x64.rpm && rm /tmp/jdk-8-linux-x64.rpm

RUN alternatives --install /usr/bin/java java /usr/java/latest/bin/java 1
RUN alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 1
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 1
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 1

ENV JAVA_HOME /usr/java/jdk1.8.0_131

ADD id_rsa /root/.ssh/
ADD id_rsa.pub /root/.ssh/

RUN cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys && chmod -R 400 /root/.ssh && chmod 0755 /var/run/sshd

ENV LC_ALL en_US.UTF-8

ADD https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.4/swarm-client-3.4.jar /root/

VOLUME /root/.gradle

EXPOSE 5005 22

RUN /usr/bin/ssh-keygen -A

CMD /usr/sbin/sshd && java -jar /root/swarm-client-3.4.jar $SWARM_CLIENT_OPTS