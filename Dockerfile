# Pull build image
FROM balenalib/raspberrypi3:jessie-build as builder
LABEL maintainer="Henrik Östman"

#RUN install_packages libtool automake libftdi-dev libusb-dev libusb-1.0.0-dev uthash-dev
#RUN git clone https://github.com/owfs/owfs.git\
#    && cd owfs\
#    && ./bootstrap\
#    && ./configure --disable-owftpd --disable-owhttpd --disable-owexternal --disable-ownet --disable-owcapi --disable-owperl --disable-owphp --disable-owpython --disable-owtcl --disable-owtap --disable-owmon --disable-owfs\
#    && make -j4 install

# Pull runtime image
FROM balenalib/raspberrypi3:jessie-run
LABEL maintainer="Henrik Östman"

ENV UDEV=1
ENV PATH="/owfs/bin:${PATH}"
ENV LD_LIBRARY_PATH="/owfs/lib:${LD_LIBRARY_PATH}"

#RUN install_packages libftdi1

ADD owfs.templ /owfs.templ
ADD run.sh /run.sh
RUN chmod +x /*.sh

# TCP socket
EXPOSE 4304

WORKDIR /owfs
#COPY --from=builder /opt/owfs .

CMD ["/run.sh"]
