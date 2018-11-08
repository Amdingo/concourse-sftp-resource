FROM python:3-alpine

ADD requirements*.txt setup.cfg ./
RUN apk add --no-cache --virtual .pynacl_deps \
      build-base \
      python3-dev \
      libffi-dev \
      vsftpd \
      && \
      pip install --no-cache-dir -r requirements.txt -r requirements_dev.txt

ADD assets /opt/resources/
ADD test/ /opt/resource-tests/

RUN pylama /opt/resource /opt/resource-tests
RUN RESOURCE_DEBUG=1 py.test -l --tb=short -vv -r fE /opt/resource-tests

FROM python:3-alpine

ADD requirements*.txt setup.cfg ./
RUN pip install --no-cache -r requirements.txt

ADD assets/ /opt/resource/
ADD test/ /opt/resource-tests/