FROM containers.intersystems.com/intersystems/irishealth-community:2025.1

USER root

WORKDIR /opt/irisapp

RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

COPY irishealth/installer installer
COPY src                  src
RUN chmod +x installer/entrypoint.sh

USER ${ISC_PACKAGE_MGRUSER}

ENTRYPOINT ["/opt/irisapp/installer/entrypoint.sh"]