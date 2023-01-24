

HOME=/Users/johan/projecten/testdevel/cocoaObjC/FosDem/fosdem/fosdemdata

#cd ${HOME}/2010; for i in archive.fosdem.org/2010/schedule/events/* ; do  echo "https://$i" ; done
#for year in 2007 2008 2009 2010; do
#	echo ${year};
#	cd ${HOME}/${year}; j=0 ; for i in archive.fosdem.org/$year/schedule/events/* ; do  echo "https://$i" ; ../spiderfosdem "https://$i" ${year} $j ; ((j++)) ; done
#	cd ${HOME}/${year}/eventxml ;cat Aconferenceheaderxml *-*-Saturday Adaybreakxml *-*-Sunday Afooterxml > xmldata${year}.xml
#done

#for year in 2011; do
#	echo ${year};
#	cd ${HOME}/${year}; j=0 ; for i in archive.fosdem.org/$year/schedule/event/* ; do  echo "https://$i" ; ../spiderfosdem2011 "https://$i" ${year} $j ; ((j++)) ; done
#	cd ${HOME}/${year}/eventxml ;cat Aconferenceheaderxml *-*-Saturday Adaybreakxml *-*-Sunday Afooterxml > xmldata${year}.xml
#done

#for year in 2012; do
#	echo ${year};
#	cd ${HOME}/${year}; j=0 ; for i in archive.fosdem.org/$year/schedule/event/*.html ; do  echo "https://$i" ; ../spiderfosdem2012 "https://$i" ${year} $j ; ((j++)) ; done
#	cd ${HOME}/${year}/eventxml ;cat Aconferenceheaderxml *-*-Saturday Adaybreakxml *-*-Sunday Afooterxml > xmldata${year}.xml
#done
cd ${HOME}	

#cd ${HOME}/2008 ; go run ../spiderfosdem.go https://archive.fosdem.org/2008/schedule/events/welcome.html 2008 1
#cd ${HOME}/2008 ; go run ../spiderfosdem.go https://archive.fosdem.org/2008/schedule/events/ror_using_rails_for_agile.html 2008 1
#cd ${HOME}/2011 ; go run ../spiderfosdem2011.go https://archive.fosdem.org/2011/schedule/event/zfs.html 2011 1
cd ${HOME}/2012 ; go run ../spiderfosdem2012.go https://archive.fosdem.org/2012/schedule/event/dsl_llvm.html 2012 1
