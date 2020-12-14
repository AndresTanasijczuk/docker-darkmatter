FROM centos:centos7

COPY docker/.singularity.d /.singularity.d

RUN yum -y upgrade

RUN yum -y groups mark convert && \
    yum -y grouplist && \
    yum -y groupinstall "Compatibility Libraries" \
                        "Development Tools" \
                        "Scientific Support"

RUN yum -y install libXt wget

RUN yum clean all

RUN mkdir /cvmfs

RUN wget https://ssd.mathworks.com/supportfiles/downloads/R2019b/Release/5/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2019b_Update_5_glnxa64.zip && \
    unzip MATLAB_Runtime_R2019b_Update_5_glnxa64.zip -d MATLAB_Runtime_R2019b_Update_5_glnxa64 && \
    cd MATLAB_Runtime_R2019b_Update_5_glnxa64 && \
    ./install -mode silent -agreeToLicense yes -outputFile ./install.log && \
    cd .. && \
    rm MATLAB_Runtime_R2019b_Update_5_glnxa64.zip && \
    rm -rf MATLAB_Runtime_R2019b_Update_5_glnxa64

RUN rpm -ivh http://repo.opensciencegrid.org/osg/3.5/osg-3.5-el7-release-latest.rpm && \
    rpm -ivh http://software.ligo.org/lscsoft/scientific/7/x86_64/production/l/lscsoft-production-config-1.3-1.el7.noarch.rpm && \
    yum clean all && \
    yum makecache && \
    yum -y install lscsoft-epel-config &&\
    yum -y install lscsoft-grid-config && \
    yum clean all && \
    yum makecache && \
    yum -y install gfal2-util gfal2-all && \
    yum -y install osg-ca-certs
