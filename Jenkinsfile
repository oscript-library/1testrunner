#!groovy
node("slave") {
    def isUnix = isUnix();

    stage "checkout"

    if (isUnix && !env.DISPLAY) {
       env.DISPLAY=":1"
    }
    
    // checkout scm
    // if (isUnix) {sh 'git submodule update --init'} else {bat "git submodule update --init"}
    
    stage "test"

    // dir('tests') {
    def commandToRun = "oscript -encoding=utf-8 testrunner.os -runall tests xddReportPath tests/report.xml";

    if (isUnix){
        sh "${commandToRun}"
    } else {
        bat "${commandToRun}"
        // bat "@chcp 1251 > nul \n${commandToRun}"
    }    
    // }

    step([$class: 'JUnitResultArchiver', testResults: '**/tests/*.xml'])

}