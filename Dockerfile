FROM 009543623063.dkr.ecr.eu-west-2.amazonaws.com/jenkins-base:corretto-21
LABEL maintainer="info@catapult.cx"
LABEL org.label-schema.description="Default image for Jenkins gradle builds"

ARG SONAR_VERSION="5.0.1.3006"
ARG GRADLE_VERSION="8.5"

USER root

# install gradle
RUN curl -L -O https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip  && \
    unzip gradle-${GRADLE_VERSION}-bin.zip  && \
    mv gradle-${GRADLE_VERSION} /usr/local/gradle && \
    rm gradle-${GRADLE_VERSION}-bin.zip  && \
    ln -s /usr/local/gradle/bin/gradle /usr/local/bin/

# install sonar cli
RUN curl -L -O https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_VERSION}-linux.zip && \
    unzip sonar-scanner-cli-${SONAR_VERSION}-linux.zip && \
    rm sonar-scanner-cli-${SONAR_VERSION}-linux.zip  && \
    mv sonar-scanner-${SONAR_VERSION}-linux /usr/local/sonar && \
    ln -s /usr/local/sonar/bin/sonar-scanner /usr/local/bin/

# cleanup
RUN rm -rf /tmp/* && \
    dnf clean all && \
    rm -rf /var/cache/yum

USER jenkins
WORKDIR /home/jenkins

RUN echo "gradle:           $(gradle --version)" && \
    echo "sonar-scanner:    $(sonar-scanner --version)"
