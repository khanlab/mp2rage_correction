FROM khanlab/neuroglia-core:latest
MAINTAINER <alik@robarts.ca>

RUN mkdir /opt/mp2rage_correction
COPY  . /opt/mp2rage_correction


RUN /opt/mp2rage_correction/install_scripts/05.install_MCR.sh /opt v93 R2017b

ENV MCRROOT /opt/mcr/v93
ENV PATH /opt/mp2rage_correction/mcr/v93/mp2rage_correction:/opt/mp2rage_correction/bin:$PATH

ENTRYPOINT ["/opt/mp2rage_correction/mp2rage_correction"]
