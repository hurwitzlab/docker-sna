# docker-sna
#
# VERSION	1.0

FROM	ubuntu:14.04
MAINTAINER	Illyoung Choi <iychoi@email.arizona.edu>

##############################################
# Setup USER
##############################################
ENV USER ruser
ENV HOME /home/$USER

RUN useradd $USER && echo "$USER:$USER" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir /home/$USER && \
    chown -R $USER:$USER $HOME

WORKDIR $HOME


##############################################
# Setup utility packages
##############################################
RUN apt-get update && \
    apt-get install -y wget unzip build-essential ssh


##############################################
# Setup R
##############################################
RUN sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list' && \
    gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 && \
    gpg -a --export E084DAB9 | apt-key add -

RUN apt-get update && \
    apt-get install -y r-base


##############################################
# Setup CRAN repository
##############################################
USER $USER
ADD Rprofile $HOME/.Rprofile


##############################################
# Setup SNA
##############################################
RUN wget https://github.com/hurwitzlab/stampede-mash/archive/master.zip && \
    unzip master.zip && \
    mv stampede-mash-master stampede-mash && \
    rm master.zip


##############################################
# Setup SNA dependencies
##############################################
ADD install_sna_dep.r $HOME/
USER root

RUN chmod 777 $HOME/install_sna_dep.r
RUN ./install_sna_dep.r

USER $USER
