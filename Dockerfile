FROM fedora:23

RUN dnf -y update && dnf -y install wget openssh-server git && mkdir ~/.ssh && chmod 700 ~/.ssh

ENV JAVA_VERSION 8u92
ENV BUILD_VERSION b14

RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm

RUN yum -y install /tmp/jdk-8-linux-x64.rpm && rm /tmp/jdk-8-linux-x64.rpm

RUN alternatives --install /usr/bin/java java /usr/java/latest/bin/java 1
RUN alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 1
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 1
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 1

ENV JAVA_HOME /usr/java/latest

ADD id_rsa /root/.ssh/
ADD id_rsa.pub /root/.ssh/

RUN cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys && chmod -R 600 /root/.ssh && mkdir /var/run/sshd && chmod 0755 /var/run/sshd

ENV LC_ALL en_US.UTF-8

VOLUME /root/.gradle

EXPOSE 5005

CMD ["/usr/sbin/sshd", "-D"]