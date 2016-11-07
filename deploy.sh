grp=edu.illinois.cs.cogcomp
artifact=illinois-xlwikifier-resources
version=1.0.7
file=$artifact-$version.jar

# second create the jar file
jar cvf $file `find . -name "xlwikifier-data*"`
# we have to generate our own pom.xml file since Maven won't allow us deploy to a non standard repo
echo "<project xmlns=\"http://maven.apache.org/POM/4.0.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
	xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd\">
	<modelVersion>4.0.0</modelVersion>
	<groupId>$grp</groupId>
	<artifactId>$artifact</artifactId>
	<version>$version</version>
	<build>
		<extensions>
			<extension>
				<groupId>org.apache.maven.wagon</groupId>
				<artifactId>wagon-ssh</artifactId>
				<version>2.4</version>
			</extension>
		</extensions>
	</build>
</project>" > pom.xml
m2repository=scp://bilbo.cs.illinois.edu:/mounts/bilbo/disks/0/www/cogcomp/html/m2repo
  
mvn deploy:deploy-file -Durl=$m2repository -DrepositoryId=CogcompSoftware -Dfile=$file \
   -DpomFile=pom.xml -Dpackaging=jar
# cleanup
rm $file
rm pom.xml
