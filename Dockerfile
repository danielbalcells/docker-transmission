FROM	debian

# Utils
RUN	apt-get update && apt-get install -y \
	git \
	sudo 

# Update repos, install transmission
RUN	apt-get update && apt-get install -y \
	transmission-cli \
	transmission-common \
	transmission-daemon

# Create transmission user and group, change permissions

RUN	adduser --uid 1999 --disabled-password --gecos '' transmission-user && \
	groupadd -g 1998 transmission && \
	usermod -a -G transmission transmission-user && \
	usermod -a -G sudo transmission-user && \
	echo 'transmission-user:SOME_PASSWORD' | chpasswd && \
	mkdir /home/transmission-user/transmission && \
	mkdir /home/transmission-user/transmission/completed && \
	mkdir /home/transmission-user/transmission/incomplete && \
	mkdir /home/transmission-user/transmission/torrents && \
	chgrp -R transmission /home/transmission-user/transmission && \
	chmod -R 777 /home/transmission-user/transmission

# Add custom configuration file
RUN	rm /etc/transmission-daemon/settings.json
ADD	settings.json /etc/transmission-daemon/settings.json
RUN	chgrp -R transmission /etc/transmission-daemon/settings.json && \
	chmod -R 777 /etc/transmission-daemon/settings.json && \
	chmod -R 777 /var/lib/transmission-daemon/

# Expose ports
EXPOSE 9999
EXPOSE 51000-52000 

# Include bash configuration repo
ADD     bashrc /home/transmission-user/.bashrc
RUN     mkdir /home/transmission-user/dotfiles && \
        git clone https://github.com/danielbalcells/dotfiles.git \
		/home/transmission-user/dotfiles

# Include start transmission script
ADD     start-transmission.sh /home/transmission-user/start-transmission.sh
RUN     chown transmission-user:transmission /home/transmission-user/start-transmission.sh && \
        chmod 770 /home/transmission-user/start-transmission.sh

# Select user
USER 	transmission-user
RUN	umask 007
# Start transmission
WORKDIR	/home/transmission-user
CMD 	./start-transmission.sh


