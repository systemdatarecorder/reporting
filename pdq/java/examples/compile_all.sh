#!/bin/sh
#
#  Purpose: Compile a list of Java programs
#
#  $Id: compile_all.sh,v 4.2.1.1 2007/10/07 07:10:50 stevej098 Exp $
#
#---------------------------------------------------------------------

# export JAVA_HOME=/c/PROGRA~1/Java/j2sdk1.4.2_08

#---------------------------------------------------------------------

ALL="
Ch2_Closed.java
Ch2_Open.java
Ch3_Closed.java
Ch3_FESC.java
Ch3_Feedback.java
Ch3_MCTest.java
Ch3_MultiClass.java
Ch3_Passport.java
Ch3_ShadowCPU.java
Ch3_SimpleSeries.java
Ch6_DBC.java
Ch7_Multibus.java
Ch7_abcache.java
Ch8_Baseline.java
Ch8_Scaleup.java
Ch8_Upgrade1.java
Ch8_Upgrade2.java
Ch9_HTTP.java
Ch9_IIS.java
Ch9_eBiz.java"

#---------------------------------------------------------------------

if [ ! -f classes ] ; then
   mkdir classes
fi

#---------------------------------------------------------------------

for JAVA in $ALL ; do
   echo $JAVA
   ./compile.sh $JAVA
done


