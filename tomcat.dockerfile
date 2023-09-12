FROM tomcat

RUN apt-get update && apt-get -y upgrade

# Set environment variables, adjust as needed
ENV CATALINA_HOME /usr/local/tomcat

WORKDIR $CATALINA_HOME

COPY source $CATALINA_HOME/webapps

# Expose the HTTP port (default: 8080)
EXPOSE 8081

# Start Tomcat when the container starts
CMD ["catalina.sh", "run"]