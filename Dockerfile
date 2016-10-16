FROM        hasufell/exherbo:latest
MAINTAINER  Julian Ospald <hasufell@posteo.de>


COPY ./config/paludis /etc/paludis


##### PACKAGE INSTALLATION #####

RUN chgrp paludisbuild /dev/tty && \
	eclectic env update && \
	source /etc/profile && \
	cave sync && \
	cave resolve -z -1 repository/hasufell -x && \
	cave resolve -z -1 repository/python -x && \
	cave resolve -z -1 repository/worr -x && \
	cave resolve -z -1 repository/net -x && \
	cave update-world -s umurmurset && \
	cave resolve -ks -Sa -sa -B world -x -f --permit-old-version '*/*' && \
	cave resolve -ks -Sa -sa -B world -x --permit-old-version '*/*' && \
	cave purge -x && \
	cave fix-linkage -x && \
	rm -rf /var/cache/paludis/distfiles/* \
		/var/tmp/paludis/build/*

RUN eclectic config accept-all


################################

COPY ./config/umurmur.conf /etc/umurmur/umurmur.conf
RUN mkdir /umurmurconfig
COPY ./config/channels.conf /umurmurconfig/

COPY ./setup.sh /setup.sh
RUN chmod +x /setup.sh
COPY ./config/supervisord.conf /etc/supervisord.conf

EXPOSE 64738

CMD /setup.sh && exec /usr/bin/supervisord -n -c /etc/supervisord.conf
