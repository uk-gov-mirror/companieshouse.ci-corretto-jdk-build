FROM 416670754337.dkr.ecr.eu-west-2.amazonaws.com/ci-base-build:1.0.5

ARG ARTIFACTORY_URL=""
ENV ARTIFACTORY_URL=${ARTIFACTORY_URL}
ARG ANT_VERSION="1.10.14"
ARG IVY_VERSION="2.5.2"

RUN dnf upgrade -y && \
    dnf install -y \
    java-21-amazon-corretto \
    maven-amazon-corretto21.noarch && \
    dnf clean all

# Set home env vars
ENV ANT_HOME /usr/lib/ant
ENV IVY_HOME /usr/lib/ivy
ENV JAVA_HOME /usr/lib/jvm/java-21-openjdk

# Download and extract Apache Ant
RUN wget -O /tmp/apache-ant.tar.gz https://downloads.apache.org/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
    mkdir -p $ANT_HOME && \
    tar -xzf /tmp/apache-ant.tar.gz -C $ANT_HOME --strip-components=1 && \
    rm /tmp/apache-ant.tar.gz

# Download and extract Apache Ivy and add to ant lib
RUN wget -O /tmp/apache-ivy.tar.gz https://downloads.apache.org/ant/ivy/${IVY_VERSION}/apache-ivy-${IVY_VERSION}-bin.tar.gz && \
    mkdir -p $IVY_HOME && \
    tar -xzf /tmp/apache-ivy.tar.gz -C $IVY_HOME --strip-components=1 && \
    rm /tmp/apache-ivy.tar.gz && \
    cp /usr/lib/ivy/ivy-${IVY_VERSION}.jar /usr/lib/ant/lib/

# Add ant to path
ENV PATH $ANT_HOME/bin:$PATH

COPY resources/configure-maven /usr/local/bin/configure-maven
