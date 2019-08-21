FROM ubuntu:18.04

# update dependencies
RUN apt-get update -y

# install python and all packages for starting chrome
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN pip3 install --upgrade pip

RUN apt-get install -y curl libgl1-mesa-glx libnss3 libxcursor-dev libxtst6 libxrandr2 libasound2 xvfb ghostscript \
                            libxi6 libgconf-2-4 unzip

WORKDIR /home

# install python libraries
RUN pip3 install selenium
RUN pip3 install pyvirtualdisplay
RUN pip3 install xvfbwrapper
RUN pip3 install pytest
RUN apt-get install wget

# download and install google chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
RUN echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get -y update
RUN apt-get -y install google-chrome-stable

# download chromedriver
RUN wget https://chromedriver.storage.googleapis.com/76.0.3809.68/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/chromedriver
RUN chown root:root /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver

# set display port to avoid crash
ENV DISPLAY=:1

# copy tests sources
ENV APP_HOME /usr/src/app
WORKDIR /$APP_HOME

# run tests
COPY . $APP_HOME/
RUN pytest $APP_HOME/tests/run.py
