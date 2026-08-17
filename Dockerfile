FROM tomcat:10.1-jdk17
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY target/avaliaqui.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
<<<<<<< HEAD
CMD ["catalina.sh", "run"]
=======
CMD ["catalina.sh", "run"]
>>>>>>> branch 'main' of https://github.com/Lukoak/ifinancas
