FROM python:3.5.1-alpine@sha256:f88925c97b9709dd6da0cb2f811726da9d724464e9be17a964c70f067d2aa64a
MAINTAINER Greg Taylor <gtaylor@gc-taylor.com>

RUN pip install --upgrade pip setuptools wheel
COPY wheeldir /opt/app/wheeldir
# These are copied and installed first in order to take maximum advantage
# of Docker layer caching (if enabled).
COPY *requirements.txt /opt/app/src/
RUN pip install --use-wheel --no-index --find-links=/opt/app/wheeldir \
    -r /opt/app/src/requirements.txt
RUN pip install --use-wheel --no-index --find-links=/opt/app/wheeldir \
    -r /opt/app/src/test-requirements.txt

COPY . /opt/app/src/
WORKDIR /opt/app/src
RUN python setup.py install

EXPOSE 5000
CMD dronedemo
