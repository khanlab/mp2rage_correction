FROM khanlab/neuroglia-core:latest
MAINTAINER <alik@robarts.ca>

RUN mkdir /opt/mp2rage_correction
COPY  . /opt/mp2rage_correction


ENV MCRVERSION v96
ENV MCRRELEASE R2019a
RUN /opt/mp2rage_correction/install_scripts/05.install_MCR.sh /opt $MCRVERSION $MCRRELEASE 

ENV MCRROOT /opt/mcr/$MCRVERSION
ENV PATH /opt/mp2rage_correction/mcr/$MCRVERSION:/opt/mp2rage_correction/bin:$PATH

ENTRYPOINT ["/opt/mp2rage_correction/mp2rage_correction"]
