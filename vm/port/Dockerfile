FROM ubuntu
RUN apt-get update && apt-get -y install python3 socat
COPY challenge.py .
ENV PORT_EXPOSE_FLAG1=12345
ENV PORT_EXPOSE_FLAG2=TEMP
CMD  sed -i "s/REPLACE/${PORT_EXPOSE_FLAG2}/g" ./challenge.py && socat TCP-LISTEN:${PORT_EXPOSE_FLAG1},reuseaddr,fork EXEC:"python3 challenge.py"
