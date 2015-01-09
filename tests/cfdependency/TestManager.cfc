component extends="mxunit.framework.TestCase" {

	public void function beforeTests()  {
		datapath = "#getDirectoryFromPath(getMetadata(this).path)#../data";
		workpath = "#datapath#/work";
		if(directoryExists(workpath))
			directoryDelete(workpath,true);
		directoryCreate(workpath);
 	}


	public void function setUp()  {
		datapath = "#getDirectoryFromPath(getMetadata(this).path)#../data";
		workpath = "#datapath#/work";
		cfdistro = "/home/valliant/cfdistro/artifacts";
		manager = new cfdependency.Manager(workpath&"/repo");
		manager.addRemoteRepository( "jboss", "http://repository.jboss.org/nexus/content/repositories/releases" );
		//manager = new cfdependency.Manager(cfdistro);
 	}

	public void function tearDown()  {
	}

	function testResolve()  {
		var payload = "this is so awesome!";
//		var result = manager.resolve("org.getrailo:railo:4.2.1.000");
//		var result = manager.resolve("org.apache.maven:maven-aether-provider:3.1.0");
		var result = manager.resolve("cfml:javatools:zip:1.0.0");
		assertTrue(find("cfml:javatools:pom:1.0.0 resolved to",result));
		debug(result);
	}

	function testVersions()  {
		testResolve();
		var payload = "this is so awesome!";
		var result = manager.versions(artifactId="org.sonatype.aether:aether-util");
		debug(result);
		assertEquals(payload,result);
	}

	function testRepositories()  {
		var payload = "this is so awesome!";
		var result = manager.repositories();
		debug(result);
	}

	function testInstall()  {
		var payload = "this is so awesome!";
		zip source = expandPath("/cfdependency") file="#workpath#/artifact.jar" {};
		var result = manager.install(artifactId="org.test.cfaether:cfaether:1.0.0", artifactFile="#workpath#/artifact.jar");
		debug(result);
	}

	function testDeploy()  {
		var payload = "this is so awesome!";
		zip source = expandPath("/cfdependency") file="#workpath#/artifact.jar" {};
		var result = manager.deploy(artifactId="org.test.cfaether:cfaether:1.0.0", artifactFile="#workpath#/artifact.jar");
		debug(result);
	}

	function testGeneratePom()  {
		var payload = "this is so awesome!";
		var result = manager.pom();
		debug(result);
	}

	function testDependency()  {
		var payload = "this is so awesome!";
		var result = manager.dependency();
		debug(result);
		assertEquals(payload,result);
	}

	function testTransDependency()  {
		var payload = "this is so awesome!";
		var result = manager.transdependency(artifactId="org.sonatype.aether:aether-util:1.9");
		debug(result);
		assertEquals(payload,result);
	}

	function testMaterialize()  {
		var payload = "this is so awesome!";
//		var result = manager.materialize("org.sonatype.aether:aether-util:1.9", workpath & "/libsman");
		var modeshapeVersion = "4.0.0.Beta1";
		result = manager.materialize(deps="org.modeshape.bom:modeshape-bom-embedded:pom:#modeshapeVersion#", directory = workpath & "/libsman");

		debug(result);
		assertEquals(payload,result);
	}

	function testDirectDependency()  {
		var payload = "this is so awesome!";
		//var result = manager.directDependencies(artifactId="org.sonatype.aether:aether-util:1.9");
		var result = manager.directDependencies("org.modeshape.bom:modeshape-bom-embedded:pom:4.0.0.Beta1");
		debug(result);
		assertEquals(payload,result);
	}

	function testManagedDependency()  {
		var payload = "this is so awesome!";
		//var result = manager.directDependencies(artifactId="org.sonatype.aether:aether-util:1.9");
		var result = manager.managedDependencies("org.modeshape.bom:modeshape-bom-embedded:pom:4.0.0.Beta1");
		debug(result);
		assertEquals(payload,result);
	}

	function testMaterializeManagedDependency()  {
		var payload = "this is so awesome!";
		//var result = manager.directDependencies(artifactId="org.sonatype.aether:aether-util:1.9");
		var deps = manager.managedDependencies("org.modeshape.bom:modeshape-bom-embedded:pom:4.0.0.Beta1","org.modeshape:modeshape-jcr-api,org.modeshape:modeshape-jcr","org.modeshape:modeshape-jcr-tck");
		var result = manager.materialize(deps=deps, directory = workpath & "/libsman");
		debug(result);
		assertEquals(payload,result);
	}

	function testCollectDependency()  {
		var payload = "this is so awesome!";
		//var result = manager.collect(artifactId="org.apache.maven:maven-aether-provider:3.1.0");
		var modeshapeVersion = "4.0.0.Beta1";
		var result = manager.collect(artifactId="org.modeshape.bom:modeshape-bom-embedded:pom:#modeshapeVersion#", directory = workpath & "/libsman")

		debug(result);
		assertTrue(arrayLen(result) > 5);
	}

	function testDependencies()  {
		var payload = "this is so awesome!";
		var result = aether.callMethod("dependencies",{artifactId:"org.sonatype.aether:aether-util:1.9"});
		debug(result);
		assertEquals(payload,result);
	}

}
