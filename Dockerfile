FROM nginx:1.19.10

LABEL maintainer="Matteo Quintiliani <matteo.quintiliani@ingv.it>"

ENV INITRD No
ENV FAKE_CHROOT 1
ENV GROUP_NAME=gmtuser
ENV USER_NAME=gmtuser
ENV PASSWORD_USER=gmtuser

ENV HOMEDIR_USER=/home/${USER_NAME}
ENV DOCKERIGNORED_DIR=/docker_ignored_dir
ENV BASHRC_USER=${HOMEDIR_USER}/.bashrc_custom_user

ENV GIT_MOPAD_BASE_URL=https://github.com/geophysics/MoPaD.git

##################################
# Update and install packages
##################################
# RUN \
		# apk update \
		# apk upgrade && \
		# apk --update add --no-cache \
		# procps \
		# sudo \
		# git \
		# python \
		# py-numpy \
		# py-matplotlib

RUN apt-get clean && apt-get update \
		&& apt-get dist-upgrade -y --no-install-recommends \
		&& apt-get install -y \
		apt-utils \
		sudo \
		git \

		python \
		python-numpy \
		python-matplotlib\

		fcgiwrap

ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./nginx/fcgiwrap.conf /etc/nginx/fcgiwrap.conf
ADD ./nginx/default.conf /etc/nginx/conf.d/default.conf

RUN mkdir /usr/lib/cgi-bin -p
ADD ./nginx/test.py /usr/lib/cgi-bin/test.py
RUN chmod 755 /usr/lib/cgi-bin/test.py
ADD ./nginx/test.bash /usr/lib/cgi-bin/test.bash
RUN chmod 755 /usr/lib/cgi-bin/test.bash

ADD ./nginx/mopad.cgi /usr/lib/cgi-bin/mopad.cgi
RUN chmod 755 /usr/lib/cgi-bin/mopad.cgi

RUN sed -i 's/www-data/nginx/g' /etc/init.d/fcgiwrap
RUN chown nginx:nginx /etc/init.d/fcgiwrap

##################################
# Create user and add to sudo users
##################################
RUN addgroup --system ${GROUP_NAME} \
		&& adduser --system --home ${HOMEDIR_USER} --ingroup ${GROUP_NAME} --shell /bin/bash ${USER_NAME} 
RUN ls -al ${HOMEDIR_USER}
# Change passwords
RUN echo "root:rootDocker!" | chpasswd
RUN echo "${USER_NAME}:${PASSWORD_USER}" | chpasswd

##################################
# Configure sudo for ${USER_NAME}
##################################
# Allow ${USER_NAME} to execute sudo without password
RUN echo "${USER_NAME} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/local

##################################
# Create DOCKERIGNORED_DIR that should be in .gitignore
##################################
RUN mkdir -p ${DOCKERIGNORED_DIR} \
		&& chown -R ${USER_NAME}:${GROUP_NAME} ${DOCKERIGNORED_DIR}

##################################
# Copy GIT deploy SSH key for user
##################################
# RUN mkdir ${HOMEDIR_USER}/.ssh
# RUN chmod 700 ${HOMEDIR_USER}/.ssh/
# COPY DockerDataBuild/id_rsa ${HOMEDIR_USER}/.ssh/
# RUN chmod 600 ${HOMEDIR_USER}/.ssh/id_rsa
# COPY DockerDataBuild/id_rsa.pub ${HOMEDIR_USER}/.ssh/
# RUN chmod 644 ${HOMEDIR_USER}/.ssh/id_rsa.pub
# COPY DockerDataBuild/known_hosts ${HOMEDIR_USER}/.ssh/
# RUN chmod 644 ${HOMEDIR_USER}/.ssh/known_hosts
# RUN chown -R ${USER_NAME}:${GROUP_NAME} ${HOMEDIR_USER}/.ssh/

##################################
# Clone MoPaD git repository and Compile
##################################
RUN cd  ${DOCKERIGNORED_DIR}  \
		&& git clone --recursive ${GIT_MOPAD_BASE_URL} \
		&& cd MoPaD \
		&& python setup.py build \
		&& python setup.py install \
		&& cd .. \
		&& rm -fr MoPaD

# ##################################
# # Set ENTRYPOINT
# ##################################
# # Change user and set workdir
# USER ${USER_NAME}
# Set PATH
RUN echo 'export PATH=/usr/local/bin:${PATH}' >> ${BASHRC_USER}

# # Test .dockerignore
# RUN echo "Test" >> ${DOCKERIGNORED_DIR}/test

# WORKDIR ${HOMEDIR_USER}
COPY ./entrypoint.sh /opt/docker/entrypoint.sh

ENTRYPOINT ["/opt/docker/entrypoint.sh"]


# CMD /etc/init.d/fcgiwrap start && nginx -g 'daemon off;'
