FROM ubuntu
RUN apt-get -qq update
RUN apt-get -qqy install wget python
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN rm get-pip.py
# Or use requirements.txt
RUN pip install jinja2 webapp2 WebOb webapp2_static paste
COPY app /app
WORKDIR /app

CMD ["python","main.py"]
