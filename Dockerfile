FROM khanlab/neuroglia-core:latest
MAINTAINER <alik@robarts.ca>

RUN mkdir /opt/mp2rage_correction
COPY  . /opt/mp2rage_correction


RUN /opt/mp2rage_correction/install_scripts/05.install_MCR.sh /opt v96 R2019a

ENV MCRROOT /opt/mcr/v96
ENV PATH /opt/mp2rage_correction/mcr/v96:/opt/mp2rage_correction/bin:$PATH

ENTRYPOINT ["/opt/mp2rage_correction/mp2rage_correction"]
