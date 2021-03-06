#!/bin/bash


function before_install {
	sudo apt-get install -f cmake
	sudo apt-get install -f libpthread-stubs0-dev
	sudo apt-get install -f libnuma-dev
	
	cmakepath=`which cmake`
	echo "cmakepath: $cmakepath"
}

function install {
	[ -f spark ] || mkdir spark && cd spark && wget http://archive.apache.org/dist/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz && cd ..
	tar -xf ./spark/spark-2.4.4-bin-hadoop2.7.tgz
	export SPARK_HOME=`pwd`/spark-2.4.4-bin-hadoop2.7
	echo "function install: $SPARK_HOME"
	#exit 0
}

function before_script {
	echo "cmakepath: $cmakepath"
	cd /tmp
	git clone https://github.com/memkind/memkind.git
	cd memkind && ./build.sh
	make
	sudo make install
	cd ${TRAVIS_BUILD_DIR}
	cmakepath=`which cmake`
	echo $cmakepath
}

function script {
	export SPARK_HOME=`pwd`/spark-2.4.4-bin-hadoop2.7
	echo "function script: $SPARK_HOME"
	cd oap-cache/oap/
	mvn clean -q -Ppersistent-memory test
}

if [ "$1" = "before_install" ]; then
	before_install
elif [ "$1" = "install" ]; then
	install
elif [ "$1" = "before_script" ]; then
	before_script
elif [ "$1" = "script" ]; then
	script
else
	echo "Don't support this arg: $1"
fi

