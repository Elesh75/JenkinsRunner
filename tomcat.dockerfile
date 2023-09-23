FROM tomcat:9.0-jre8

# Set environment variables (optional but recommended)
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

WORKDIR /usr/local/tomcat/webapps/ROOT

COPY /var/jenkins_home/workspace/jen2/target/tesla.war .

RUN rm -rf /usr/local/tomcat/webapps/*

RUN unzip -q tesla.war -d .

RUN rm tesla.war

# Expose the default Tomcat port (8080) if necessary
EXPOSE 8080

# Start Tomcat when the container starts
CMD ["catalina.sh", "run"]


