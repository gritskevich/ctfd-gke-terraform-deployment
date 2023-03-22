FROM ubuntu

RUN apt-get update

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY init.sh .
ENV SSH_BRUTEFORCE_PASSWORD=user
ENV SSH_BRUTEFORCE_LOGIN=password
CMD ./init.sh -u $SSH_BRUTEFORCE_LOGIN -p $SSH_BRUTEFORCE_PASSWORD && /usr/sbin/sshd -D
