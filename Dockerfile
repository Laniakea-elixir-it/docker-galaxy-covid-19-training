# Galaxy - covid-19-training

FROM bgruening/galaxy-stable:19.01

MAINTAINER Pietro Mandreoli, pietro.mandreoli@unimi.it

ENV GALAXY_CONFIG_BRAND="Covid-19-genomics"

#tool data table for covacs flavour
#RUN wget https://raw.githubusercontent.com/indigo-dc/Reference-data-galaxycloud-repository/master/elixir-italy.covacs.refdata/location/tool_data_table_conf.xml -O /etc/galaxy/tool_data_table_conf.xml

WORKDIR /galaxy-central

RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test Tool Shed'
RUN wget https://raw.githubusercontent.com/galaxyproject/SARS-CoV-2/master/genomics/deploy/all_covid_tools.yaml -O $GALAXY_ROOT/all_covid_tools.yaml

RUN install-tools $GALAXY_ROOT/all_covid_tools.yaml -a admin -g http://localhost:8080

# Install workflows
RUN mkdir -p $GALAXY_HOME/workflows

RUN git clone https://github.com/galaxyproject/SARS-CoV-2.git

RUN mv SARS-CoV-2/genomics/deploy/workflows/* $GALAXY_HOME/workflows
RUN rm -rf SARS-CoV-2

#RUN startup_lite && \
#galaxy-wait && \
#workflow-install --workflow_path $GALAXY_HOME/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE :80
EXPOSE :21
EXPOSE :8800
# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]
