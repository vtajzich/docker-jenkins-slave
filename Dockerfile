FROM vtajzich/java:oracle-java8

RUN apt-get update && apt-get -y install ssh git && mkdir ~/.ssh && chmod 700 ~/.ssh

ADD id_rsa /root/.ssh/
ADD id_rsa.pub /root/.ssh/

RUN cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys

RUN locale-gen en_US.UTF-8

ENV LC_ALL en_US.UTF-8

EXPOSE 5005

CMD service ssh restart && bash