#!/bin/bash

DOWNLOAD_FOLDER=/tmp/sonar-test-plugins
FINAL_CONFIGURATION_FOLDER=/tmp/extensions-plugins

# create cache download folders
mkdir -p $DOWNLOAD_FOLDER

# clean and re-create extensions-plugins
rm -rf $FINAL_CONFIGURATION_FOLDER && mkdir -p $FINAL_CONFIGURATION_FOLDER

function dwget() {
    if [[ -f $DOWNLOAD_FOLDER/$1 ]]; then 
      echo "$1 in cache" 
    else
      wget -P $DOWNLOAD_FOLDER $2/$1
    fi
    cp $DOWNLOAD_FOLDER/$1 $FINAL_CONFIGURATION_FOLDER
}

function dmaven() {
    if [[ -f $DOWNLOAD_FOLDER/$1 ]]; then 
      echo "$1 in cache" 
    else
      mvn org.apache.maven.plugins:maven-dependency-plugin:2.4:get -Dartifact=$2 -Dtransitive=false -Ddest=$DOWNLOAD_FOLDER/$1
    fi
    cp $DOWNLOAD_FOLDER/$1 $FINAL_CONFIGURATION_FOLDER
}

# branches
PLUGIN_VERSION_BRANCHES=1.8.0

# languages
# PLUGIN_VERSION_CSHARP=8.22.0.31243     -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_CSS=1.4.2.2002          -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_FLEX=2.6.1.2564         -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_GOLANG=1.8.3.2219       -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_HTML=3.4.0.2754         -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_JACOCO=1.1.1.1156       -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_JAVA=6.15.1.26025       -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_JAVASCRIPT=7.4.2.15501  -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_KOTLIN=1.8.3.2219       -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_PHP=3.17.0.7439         -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_PYTHON=3.4.1.8066       -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_RUBY=1.8.3.2219         -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_SCALA=1.8.3.2219        -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_VBNET=8.22.0.31243      -- INCLUIDO EN LA IMAGEN BASE
# PLUGIN_VERSION_XML=2.2.0.2973          -- INCLUIDO EN LA IMAGEN BASE
PLUGIN_VERSION_COMMUNITY_FSHARP=3.2.389
PLUGIN_VERSION_RUST=0.0.3
PLUGIN_VERSION_GROOVY=1.6
PLUGIN_VERSION_SWIFT=0.4.4
PLUGIN_VERSION_TYPESCRIPT=2.1.0.4359
PLUGIN_VERSION_JSON=2.3

# extensions on Java
PLUGIN_VERSION_FINDBUGS=4.0.3
PLUGIN_VERSION_PMD=3.3.1
PLUGIN_VERSION_CHECKSTYLE=8.40
#PLUGIN_VERSION_ANDROID=1.1              -- NO FUNCIONA EN SONAR 8.9
PLUGIN_VERSION_ANDROID_LINT=1.1.0
PLUGIN_VERSION_AEM_RULES=1.3
PLUGIN_VERSION_QUALINSIGHT=3.0.1

## DESCARGAS

dwget sonarqube-community-branch-plugin-${PLUGIN_VERSION_BRANCHES}.jar https://github.com/mc1arke/sonarqube-community-branch-plugin/releases/download/${PLUGIN_VERSION_BRANCHES}

dwget sonar-communityfsharp-plugin-${PLUGIN_VERSION_COMMUNITY_FSHARP}.jar https://github.com/jmecosta/sonar-fsharp-plugin/releases/download/v${PLUGIN_VERSION_COMMUNITY_FSHARP}
dwget sonar-rust-plugin-${PLUGIN_VERSION_RUST}.jar https://github.com/elegoff/sonar-rust/releases/download/v${PLUGIN_VERSION_RUST}
dwget sonar-groovy-plugin-${PLUGIN_VERSION_GROOVY}.jar https://github.com/Inform-Software/sonar-groovy/releases/download/${PLUGIN_VERSION_GROOVY}
dwget backelite-sonar-swift-plugin-${PLUGIN_VERSION_SWIFT}.jar http://github.com/Backelite/sonar-swift/releases/download/${PLUGIN_VERSION_SWIFT}
dwget sonar-typescript-plugin-${PLUGIN_VERSION_TYPESCRIPT}.jar https://repo1.maven.org/maven2/org/sonarsource/typescript/sonar-typescript-plugin/${PLUGIN_VERSION_TYPESCRIPT}
dwget sonar-json-plugin-${PLUGIN_VERSION_JSON}.jar https://github.com/racodond/sonar-json-plugin/releases/download/${PLUGIN_VERSION_JSON}

dwget sonar-pmd-plugin-${PLUGIN_VERSION_PMD}.jar https://github.com/jensgerdes/sonar-pmd/releases/download/${PLUGIN_VERSION_PMD}
dwget sonar-findbugs-plugin-${PLUGIN_VERSION_FINDBUGS}.jar  https://github.com/spotbugs/sonar-findbugs/releases/download/${PLUGIN_VERSION_FINDBUGS}
dwget checkstyle-sonar-plugin-${PLUGIN_VERSION_CHECKSTYLE}.jar https://github.com/checkstyle/sonar-checkstyle/releases/download/${PLUGIN_VERSION_CHECKSTYLE}
#-- no funciona en 8.9 -- dwget sonar-android-plugin-${PLUGIN_VERSION_ANDROID}.jar https://repo1.maven.org/maven2/org/codehaus/sonar-plugins/android/sonar-android-plugin/${PLUGIN_VERSION_ANDROID}
dwget sonar-android-lint-${PLUGIN_VERSION_ANDROID_LINT}.jar https://github.com/jvilya/sonar-android-plugin/releases/download/release/v${PLUGIN_VERSION_ANDROID_LINT}
dwget sonar-aemrules-plugin-${PLUGIN_VERSION_AEM_RULES}.jar https://github.com/wttech/AEM-Rules-for-SonarQube/releases/download/v${PLUGIN_VERSION_AEM_RULES}
dmaven qualinsight-plugins-sonarqube-badges-${PLUGIN_VERSION_QUALINSIGHT}.jar com.qualinsight.plugins.sonarqube:qualinsight-plugins-sonarqube-badges:${PLUGIN_VERSION_QUALINSIGHT}

# ----------------------------
# copy plugins to volume

if [[ ! -z "which docker" ]]; then

  docker run -it --rm \
    -v sonar-plugins:/opt/sonarqube/extensions/plugins \
    -v $FINAL_CONFIGURATION_FOLDER:/tmp/plugins:ro \
    alpine:3.13 \
    sh -c 'rm -rf /opt/sonarqube/extensions/plugins/* && cp -r /tmp/plugins/* /opt/sonarqube/extensions/plugins/'
fi
