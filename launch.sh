SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export ARCH=x86_64
JVM=zulu17.50.19-ca-fx-jdk17.0.11-linux_x64
set -e
ZIP=$JVM.tar.gz
export JAVA_HOME=$HOME/bin/java17/
if test -d $JAVA_HOME/$JVM/; then
  echo "$JAVA_HOME exists."
else
	rm -rf $JAVA_HOME
	mkdir -p $JAVA_HOME
	wget https://cdn.azul.com/zulu/bin/$ZIP 
	tar -xvzf $ZIP -C $JAVA_HOME
	mv $JAVA_HOME/$JVM/* $JAVA_HOME/
fi
echo "Java home set to $JAVA_HOME"

JAR=BowlerStudio.jar
if test -e $JAR; then
   echo "Jar downloaded"
else
   wget https://github.com/CommonWealthRobotics/BowlerStudio/releases/latest/download/BowlerStudio.jar 
fi
if [ "$#" -lt 2 ]; then
  echo "Need file and port specified to run server"
  exit 0
fi
xvfb-run -s '-screen 0 1024x768x24' $JAVA_HOME/bin/java -Djava.awt.headless=true -Dprism.order=sw -Dprism.allowhidpi=false -Dprism.verbose=true -XX:MaxRAMPercentage=90.0 --add-exports javafx.graphics/com.sun.javafx.css=ALL-UNNAMED --add-exports javafx.controls/com.sun.javafx.scene.control.behavior=ALL-UNNAMED --add-exports javafx.controls/com.sun.javafx.scene.control=ALL-UNNAMED --add-exports javafx.base/com.sun.javafx.event=ALL-UNNAMED --add-exports javafx.controls/com.sun.javafx.scene.control.skin.resources=ALL-UNNAMED --add-exports javafx.graphics/com.sun.javafx.util=ALL-UNNAMED --add-exports javafx.graphics/com.sun.javafx.scene.input=ALL-UNNAMED --add-opens javafx.graphics/javafx.scene=ALL-UNNAMED  -jar BowlerStudio.jar -csgserver $@
