rem #========================================================================
rem # Batch File    : ccuSend
rem # Description   : This batch script set nacessary environment variables and   
rem #               :  call the java ccu api to send a request to Akamai cache invalidation
rem #               : 
rem # I/P Parameter : urls string
rem #				  			:			urls is a signle string with "\t" delimitated full urls 
rem #				  			:        			
rem # O/P Parameter : 
rem # Usage         : java  com.akamai.www.purge.CCURequest -user ywang1 -pwd monday12 -email ywang@rccl.com -text "http://media.celebritycruises.com/celebrity/content/audio/swf/ship_1.jpg	http://media.celebritycruises.com/celebrity/content/audio/swf/ship_2.jpg http://media.celebritycruises.com/celebrity/content/audio/swf/ship_3.jpg"
rem #               :  
rem # Modification History
rem #
rem # Date				Author		Description
rem # ----				------		-----------
rem #========================================================================

set CCU_HOME=C:\ccuapi-axis
set TEAMSITE_HOME=F:\iw-home\TeamSite
set AXIS_HOME=%CCU_HOME%\axis-1_4
set XERCES_HOME=%CCU_HOME%\xerces-2_7_1
set AXIS_LIB=%AXIS_HOME%\lib
set AXISCLASSPATH=%AXIS_LIB%\axis.jar;%AXIS_LIB%\commons-discovery-0.2.jar;%AXIS_LIB%\commons-logging-1.0.4.jar;%AXIS_LIB%\jaxrpc.jar;%AXIS_LIB%\saaj.jar;%AXIS_LIB%\log4j-1.2.8.jar;%XERCES_HOME%\xml-apis.jar;%AXIS_LIB%\wsdl4j-1.5.1.jar;%XERCES_HOME%\xercesImpl.jar
set CLASSPATH=%CLASSPATH%;%AXISCLASSPATH%;%CCU_HOME%
%TEAMSITE_HOME%\tools\java\jre\bin\java  -classpath ".;C:\ccuapi-axis\com\akamai\www\purge\json-simple-1.1.jar;C:\ccuapi-axis\com\akamai\www\purge\javax.mail-1.3.3.01.jar" com.akamai.www.purge.PurgeApiREST teamsite_admin@rccl.com Upgrade741 teamsite_admin@rccl.com %1