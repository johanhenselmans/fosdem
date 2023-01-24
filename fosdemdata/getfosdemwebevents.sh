#!/bin/sh
HOME=`cwd`
mkdir ${HOME}/2001
cd ${HOME}/2001
/opt/local/bin/wget -rl 1  https://archive.fosdem.org/2001/program/index.html
mkdir ${HOME}/2002
cd ${HOME}/2002
/opt/lcoal/bin/wget -rl 1  https://archive.fosdem.org/2002/schedule/index.html
mkdir ${HOME}/2003
cd ${HOME}/2003
/opt/local/bin/wget -rl 1  https://archive.fosdem.org/2003/index/schedule.html
for year in 2004 2005 2006; do
mkdir ${HOME}/${year}
cd ${HOME}/${year}
/opt/local/bin/wget -rl 1  https://archive.fosdem.org/${year}/${year}/index/schedule.html;
done
for year in 2007 2008 2009 2010; do
mkdir ${HOME}/${year}
cd ${HOME}/${year}
/opt/local/bin/wget -rl 1  https://archive.fosdem.org/${year}/schedule/events/
/opt/local/bin/wget -rl 1  https://archive.fosdem.org/2008/schedule/events/
/opt/local/bin/wget -rl 1  https://archive.fosdem.org/2009/schedule/events/
/opt/local/bin/wget -rl 1  https://archive.fosdem.org/2010/schedule/events/
done
for year in 2011 2012; do
    mkdir ${HOME}/${year}
    cd ${HOME}/${year}
    /opt/local/bin/wget -rl 1  https://archive.fosdem.org/${year}/schedule/event/;
done
cd ${HOME}
for year in 2013 2014 2015 2016 2017; do
    mkdir ${HOME}/${year}
    cd ${HOME}/${year}
    curl -O https://fosdem.org/{year}/schedule/xml
done
