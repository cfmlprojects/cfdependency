component output="false" persistent="false" {

	function init(localPath=getDirectoryFromPath(getTemplatePath()) & "/repo", repositories="default", javaloader) {
		localRepositoryPath = localPath;
   		cl = javaloader;
		var jThread = cl.create("java.lang.Thread");
		var cTL = jThread.currentThread().getContextClassLoader();
		//jThread.currentThread().setContextClassLoader(cl.GETLOADER().getURLClassLoader());
		system = cl.create("java.lang.System");
		jFile = cl.create("java.io.File");

		//jMavenRepositorySystemSession = cl.create("org.apache.maven.repository.internal.MavenRepositorySystemSession");

		jConservativeAuthenticationSelector = cl.create("org.eclipse.aether.util.repository.ConservativeAuthenticationSelector");
		jDefaultAuthenticationSelector = cl.create("org.eclipse.aether.util.repository.DefaultAuthenticationSelector");
		jDefaultMirrorSelector = cl.create("org.eclipse.aether.util.repository.DefaultMirrorSelector");
		jDefaultProxySelector = cl.create("org.eclipse.aether.util.repository.DefaultProxySelector");

		jDefaultRepositoryCache = cl.create("org.eclipse.aether.DefaultRepositoryCache");
//		jDefaultSettingsBuildingRequest = cl.create("org.apache.maven.settings.building.DefaultSettingsBuildingRequest");
		jConfigurationProperties = cl.create("org.eclipse.aether.ConfigurationProperties");
		jDefaultLocalRepositoryProvider = cl.create("org.eclipse.aether.internal.impl.DefaultLocalRepositoryProvider");
		jDefaultRepositorySystemSession = cl.create("org.eclipse.aether.DefaultRepositorySystemSession");
		jDefaultRepositorySystem = cl.create("org.eclipse.aether.internal.impl.DefaultRepositorySystem");
		jRepositorySystem = cl.create("org.eclipse.aether.RepositorySystem");
		jRepositorySystemSession = cl.create("org.eclipse.aether.RepositorySystemSession");
		jLocalRepository = cl.create("org.eclipse.aether.repository.LocalRepository");
		jRemoteRepository = cl.create("org.eclipse.aether.repository.RemoteRepository$Builder");

		jArtifact = cl.create("org.eclipse.aether.artifact.Artifact");
		jSubArtifact = cl.create("org.eclipse.aether.util.artifact.SubArtifact");
		jArtifactRequest = cl.create("org.eclipse.aether.resolution.ArtifactRequest");
		jInstallRequest = cl.create("org.eclipse.aether.installation.InstallRequest");
		jDeployRequest = cl.create("org.eclipse.aether.deployment.DeployRequest");
		jArtifactResult = cl.create("org.eclipse.aether.resolution.ArtifactResult");
		jDefaultArtifact = cl.create("org.eclipse.aether.artifact.DefaultArtifact");
		jVersionRangeRequest = cl.create("org.eclipse.aether.resolution.VersionRangeRequest");

		//_modelBuilder = cl.create("org.apache.maven.model.building.DefaultModelBuilderFactory").newInstance();
    	//_settingsBuilder = cl.create("org.apache.maven.settings.building.DefaultSettingsBuilderFactory").newInstance();
    	//settingsDecrypter = new AntSettingsDecryptorFactory().newInstance();
		jMavenRepositorySystemUtils = cl.create("org.apache.maven.repository.internal.MavenRepositorySystemUtils");
		jModelBuilder = cl.create("org.apache.maven.model.building.DefaultModelBuilderFactory").newInstance();
		jModel = cl.create("org.apache.maven.model.Model");
		jRepositoryConnectorFactory = cl.create("org.eclipse.aether.spi.connector.RepositoryConnectorFactory");
		jTransporterFactory = cl.create("org.eclipse.aether.spi.connector.transport.TransporterFactory");
		//jAsyncRepositoryConnectorFactory = cl.create("org.eclipse.aether.connector.async.AsyncRepositoryConnectorFactory");
//		jFileRepositoryConnectorFactory = cl.create("org.eclipse.aether.connector.file.FileRepositoryConnectorFactory");

		jVersionRangeResolver = cl.create("org.eclipse.aether.impl.VersionRangeResolver");
		jVersionResolver = cl.create("org.eclipse.aether.impl.VersionResolver");
		jArtifactDescriptorReader = cl.create("org.eclipse.aether.impl.ArtifactDescriptorReader");
		jCollectRequest = cl.create("org.eclipse.aether.collection.CollectRequest");
		jDependency = cl.create("org.eclipse.aether.graph.Dependency");
		jDependencyRequest = cl.create("org.eclipse.aether.resolution.DependencyRequest");
		jDependencyFilterUtils = cl.create("org.eclipse.aether.util.filter.DependencyFilterUtils");
		jJavaScopes = cl.create("org.eclipse.aether.util.artifact.JavaScopes");
		jArtifactDescriptorRequest = cl.create("org.eclipse.aether.resolution.ArtifactDescriptorRequest");
		jMavenXpp3Writer = cl.create("org.apache.maven.model.io.xpp3.MavenXpp3Writer");
		jRequerstTrace = cl.create("org.eclipse.aether.RequestTrace");
		if(!directoryExists(localRepositoryPath))
			directoryCreate(localRepositoryPath);
		jDefaultRepositorySystemSession.init();
		//_repositorySystem = jMavenRepositorySystemSession.init();
		initDefaults();
		if(repositories=="default") {
			addDefaultRepositories();
		}
		return this;
	}

    private void function initDefaults() {
		variables.repositories = [];
    	variables.locator = jMavenRepositorySystemUtils.newServiceLocator();
//    	request.debug(locator);
        //locator.setErrorHandler( new AntServiceLocatorErrorHandler( project ) );
        //locator.setServices( Logger.class, new AntLogger( project ) );
        //locator.setServices( jModelBuilder.class, _modelBuilder );
        var ul = cl.GETLOADER().getURLClassLoader();
        locatorClasses = {
        	repositoryConnectorFactory : ul.loadClass("org.eclipse.aether.spi.connector.RepositoryConnectorFactory"),
        	loggerFactory : ul.loadClass("org.eclipse.aether.spi.log.LoggerFactory"),
        	MetadataGeneratorFactory : ul.loadClass("org.eclipse.aether.impl.MetadataGeneratorFactory"),
        	SyncContextFactory : ul.loadClass("org.eclipse.aether.impl.SyncContextFactory"),
        	FileProcessor : ul.loadClass("org.eclipse.aether.spi.io.FileProcessor"),
        	RepositoryEventDispatcher : ul.loadClass("org.eclipse.aether.impl.RepositoryEventDispatcher"),

        	transporterFactory : ul.loadClass("org.eclipse.aether.spi.connector.transport.TransporterFactory"),
        	modelBuilder : ul.loadClass("org.apache.maven.model.building.ModelBuilder"),
        	BasicRepositoryConnectorFactory : ul.loadClass("org.eclipse.aether.connector.basic.BasicRepositoryConnectorFactory"),
        	FileTransporterFactory : ul.loadClass("org.eclipse.aether.transport.file.FileTransporterFactory"),
        	HttpTransporterFactory : ul.loadClass("org.eclipse.aether.transport.http.HttpTransporterFactory"),
        	ClasspathTransporterFactory : ul.loadClass("org.eclipse.aether.transport.classpath.ClasspathTransporterFactory"),
        	repositorySystem : ul.loadClass("org.eclipse.aether.RepositorySystem"),
        	ArtifactDescriptorReader : ul.loadClass("org.eclipse.aether.impl.ArtifactDescriptorReader"),
        	defaultRepositorySystem : ul.loadClass("org.eclipse.aether.internal.impl.DefaultRepositorySystem")
        };
//        request.debug(jModelBuilder);
        locator.setServices( locatorClasses.modelBuilder, [jModelBuilder] );
        locator.addService( locatorClasses.repositoryConnectorFactory, locatorClasses.BasicRepositoryConnectorFactory );
        locator.addService( locatorClasses.TransporterFactory, locatorClasses.FileTransporterFactory );
        locator.addService( locatorClasses.TransporterFactory, locatorClasses.HttpTransporterFactory );
        locator.addService( locatorClasses.TransporterFactory, locatorClasses.ClasspathTransporterFactory );
        //locator.addService( locatorClasses.repositoryConnectorFactory, locatorClasses.asyncRepositoryConnectorFactory );
//		sys.initService(locator);
        locator.getService( locatorClasses.defaultRepositorySystem );
        variables.repoSys = locator.getService( ul.loadClass("org.eclipse.aether.RepositorySystem") );
        if ( isNull(variables.repoSys) ) {
            throw( "The repository system could not be initialized" );
        }
//        request.debug(repoSys);
    }

    private function getLocatorService(string className) {
        return variables.locator.getService(locatorClasses[className]);
    }

    private function getLocatorServices(string className) {
        return variables.locator.getServices(locatorClasses[className]);
    }

    private function getSystem() {
        return variables.repoSys;
    }

    private function getRepositories() {
        return variables.repositories;
    }

    private function getSession() {
    	if(isNull(variables.msession)) {
      		variables.msession = jMavenRepositorySystemUtils.newSession();
	        var localRepo = jLocalRepository.init( getDefaultLocalRepoDir() );
	        var configProps = cl.create("java.util.LinkedHashMap").init();
	        configProps.put( jConfigurationProperties.USER_AGENT, "cfaether" );
	//        configProps.putAll( system.getProperties() );
	        msession.setConfigProperties( configProps );
	        //msession.setOffline( isOffline() );
	        msession.setOffline( false );
	        msession.setSystemProperties(system.getProperties());
	//        msession.setUserProperties( project.getUserProperties() );
	        msession.setLocalRepositoryManager( getSystem().newLocalRepositoryManager( msession, localRepo ) );
	        msession.setProxySelector( getProxySelector() );
	        msession.setMirrorSelector( getMirrorSelector() );
	        msession.setAuthenticationSelector( getAuthSelector() );
	        msession.setCache( jDefaultRepositoryCache.init() );

//			msession.setDependencyGraphTransformer(javacast("null",""));

	//        msession.setRepositoryListener( new AntRepositoryListener( task ) );
	//        msession.setTransferListener( new AntTransferListener( task ) );
	//        msession.setWorkspaceReader( ProjectWorkspaceReader.getInstance() );
    	}
    	return msession;
    }

    public function resolveArtifact(artifactId) {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( "org.sonatype.aether:aether-util:1.9" );
        var artifactRequest = jArtifactRequest.init();
        artifactRequest.setArtifact( artifact );
        artifactRequest.setRepositories( getRepositories() );
        var artifactResult = getSystem().resolveArtifact( getSession(), artifactRequest );
        artifact = artifactResult.getArtifact();

		pomArtifact = cl.create("org.apache.maven.repository.internal.ArtifactDescriptorUtils").toPomArtifact(artifact);
        artifactRequest = jArtifactRequest.init();
        artifactRequest.setArtifact( pomArtifact );
        artifactRequest.setRepositories( getRepositories() );
        var artifactResult = getSystem().resolveArtifact( getSession(), artifactRequest );
        artifact = artifactResult.getArtifact();

        return artifact & " resolved to  " & artifact.getFile();
    }

    public function install(artifactId,artifactFile,pomFile) {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( artifactId );
        var aFile = jFile.init( artifactFile );
        artifact = artifact.setFile( aFile );
		var pomArtifact = cl.create("org.apache.maven.repository.internal.ArtifactDescriptorUtils").toPomArtifact(artifact);
        if(isNull(pomFile)){
        	pomFile = pom(artifact);
        }
        pomArtifact = pomArtifact.setFile( jFile.init( pomFile ) );
/*
        request.debug(getLocatorService("LoggerFactory"));
        request.debug(getLocatorService("FileProcessor"));
        request.debug(getLocatorService("RepositoryEventDispatcher"));
        request.debug(getLocatorService("MetadataGeneratorFactory"));
        request.debug(getLocatorService("SyncContextFactory"));
        request.debug(getLocatorService("SyncContextFactory").newInstance( msession, false ));
*/
        var installRequest = jInstallRequest.init();
        installRequest.addArtifact( artifact ).addArtifact( pomArtifact );
        var installResult = getSystem().install( msession, installRequest );
//        request.debug(installResult);
//        iTrace = jRequerstTrace.newChild( installRequest.getTrace(), installRequest );
//        request.debug(iTrace.toString());
        return installResult;
    }

    public function deploy(artifactId,artifactFile="",dependencies) {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( artifactId );
        var aFile = jFile.init( artifactFile );
        artifact = artifact.setFile( aFile );
		var pomArtifact = cl.create("org.apache.maven.repository.internal.ArtifactDescriptorUtils").toPomArtifact(artifact);
        if(isNull(pomFile)){
        	pomFile = pom(artifact);
        }
        pomArtifact = pomArtifact.setFile( jFile.init( pomFile ) );
		var distRepo =
            jRemoteRepository.init( "org.eclipse.aether.examples", "default", jFile.init( localRepositoryPath ).toURI().toString() ).build();
        var deployRequest = jDeployRequest.init();
        deployRequest.addArtifact( artifact ).addArtifact( pomArtifact );
        deployRequest.setRepository( distRepo );
        var deployResult = getSystem().deploy( msession, deployRequest );
        return deployResult;
    }

    public function pom(artifactId) {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( artifactId );
        var model = jModel.init();
		model.setArtifactId(artifact.getArtifactId());
		model.setGroupId(artifact.getGroupId());
		model.setVersion(artifact.getVersion());
		model.setName(artifact.getArtifactId());
		var writer = cl.create("java.io.FileWriter").init("/tmp/pom.xml");
		jMavenXpp3Writer.write(writer,model);
		writer.close();
		return "/tmp/pom.xml";
    }



    public function resolveNull(artifactId) {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( "org.sonatype.aether:aether-util:1.9" );
        var artifactRequest = jArtifactRequest.init();
        artifactRequest.setArtifact( artifact );
        artifactRequest.setRepositories( getRepositories() );
        jModelBuildingRequest = cl.create("org.apache.maven.model.building.ModelBuildingRequest");
        jDefaultModelBuildingRequest = cl.create("org.apache.maven.model.building.DefaultModelBuildingRequest");
        jDefaultModelCache = cl.create("org.apache.maven.repository.internal.DefaultModelCache");
        jDefaultModelResolver = cl.create("org.apache.maven.repository.internal.DefaultModelResolver");
        jFileModelSource = cl.create("org.apache.maven.model.building.FileModelSource");
		pomArtifact = cl.create("org.apache.maven.repository.internal.ArtifactDescriptorUtils").toPomArtifact(artifact);
        artifactRequest = jArtifactRequest.init();
        artifactRequest.setArtifact( pomArtifact );
        artifactRequest.setRepositories( getRepositories() );
        var artifactResult = getSystem().resolveArtifact( getSession(), artifactRequest );
        pomArtifact = artifactResult.getArtifact();


        modelRequest = jDefaultModelBuildingRequest.init();
        modelRequest.setValidationLevel( jModelBuildingRequest.VALIDATION_LEVEL_MINIMAL );
        modelRequest.setProcessPlugins( false );
        modelRequest.setTwoPhaseBuilding( false );
       modelRequest.setModelCache( jDefaultModelCache.newInstance( msession ) );
/*
       modelRequest.setModelResolver( jDefaultModelResolver.init( msession, trace.newChild( modelRequest ),
                                                                         artifactRequest.getRequestContext(), artifactResolver,
                                                                         remoteRepositoryManager,
                                                                         artifactRequest.getRepositories() ) );
*/
        modelRequest.setModelSource( jFileModelSource.init( pomArtifact.getFile() ) );

         model = modelBuilder.build( modelRequest ).getEffectiveModel();

             return artifact & " resolved to  " & artifact.getFile();
    }

    public function dependency(artifactId) {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( "org.sonatype.aether:aether-util:1.9" );
		var rangeRequest = jVersionRangeRequest.init();
        rangeRequest.setArtifact( artifact );
        rangeRequest.setRepositories( getRepositories() );
        var rangeResult = getSystem().resolveVersionRange( msession, rangeRequest );
        var newestVersion = rangeResult.getHighestVersion();
        var message = "Newest version " & newestVersion & " from repository "
            & rangeResult.getRepository( newestVersion );
        return message;
    }

    public function resolved(artifactId) {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( artifactId );
        var repoManager = msession.getLocalRepositoryManager();
        var artifactFile = jFile.init(localRepositoryPath & "/" & repoManager.getPathForLocalArtifact(artifact));
        return artifactFile.exists();
    }

    public function versions(artifactId,range="[0,)") {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( artifactId & ":" & range );
		var rangeRequest = jVersionRangeRequest.init();
        rangeRequest.setArtifact( artifact );
        var repoManager = msession.getLocalRepositoryManager();;
        rangeRequest.setRepositories( getRepositories() );
        var rangeResult = getSystem().resolveVersionRange( msession, rangeRequest );
        var high = rangeResult.getHighestVersion();
        var low = rangeResult.getLowestVersion();
        var versionMax = {version:high.toString(),repository:rangeResult.getRepository(rangeResult.getHighestVersion()).toString(),resolved:resolved(artifactId & ":" & high.toString())};
        var versionMin = {version:low.toString(),repository:rangeResult.getRepository(rangeResult.getLowestVersion()).toString(),resolved:resolved(artifactId & ":" & low.toString())};
        var versions = [];
        for(var ver in rangeResult.getVersions()) {
        	arrayAppend(versions,{version:ver.toString(),repository:rangeResult.getRepository(ver).toString(),resolved:resolved(artifactId & ":" & ver.toString())});
        }
        return {min:versionMin,max:versionMax,versions:versions};
    }

    public function repositories() {
        var repos = [];
        for(var repo in getRepositories()) {
        	arrayAppend(repos,repo.toString());
        }
        return repos;
    }

    public function dependencies(artifactId,scopes="compile") {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( "org.sonatype.aether:aether-util:1.9" );
        var collectRequest = jCollectRequest.init();
        var filter = jDependencyFilterUtils.classpathFilter( [scopes] );
        var dependency = jDependency.init( artifact, "" );
        request.debug(dependency);
        collectRequest.setRoot( dependency );
        collectRequest.setRepositories( getRepositories() );
        var dependencyRequest = jDependencyRequest.init( collectRequest, filter );
        request.debug(dependencyRequest.getCollectRequest().getDependencies());
        var artifactResults =
            getSystem().listDependencies( msession, dependencyRequest ).getArtifactResults();
        for ( artifactResult in artifactResults ) {
            systemOutput( artifactResult.getArtifact() & " resolved to " & artifactResult.getArtifact().getFile() );
        }
        return artifact & " resolved to  " & artifact.getFile();
    }

    public function transdependency(artifactId,scopes="compile") {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( artifactId );
        var filter = jDependencyFilterUtils.classpathFilter( [jJavaScopes.COMPILE] );
        var collectRequest = jCollectRequest.init();
        collectRequest.setRoot( jDependency.init( artifact, jJavaScopes.COMPILE ) );
        collectRequest.setRepositories( getRepositories() );
        var dependencyRequest = jDependencyRequest.init( collectRequest, filter );
        var resolved = getSystem().resolveDependencies( msession, dependencyRequest );
        for ( artifactResult in resolved.getArtifactResults() ) {
            systemOutput( artifactResult.getArtifact() & " resolved to " & artifactResult.getArtifact().getFile() );
        }
        return artifact & " resolved to  " & artifact.getFile();
    }

	public function materialize(artifactId, directory, Boolean unzip = false) {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( artifactId );
        var filter = jDependencyFilterUtils.classpathFilter( [jJavaScopes.COMPILE] );
        var collectRequest = jCollectRequest.init();
        collectRequest.setRoot( jDependency.init( artifact, jJavaScopes.COMPILE ) );
        collectRequest.setRepositories( getRepositories() );
        var dependencyRequest = jDependencyRequest.init( collectRequest, filter );
        var resolved = getSystem().resolveDependencies( msession, dependencyRequest );
		if(!directoryExists(directory)) {
			directoryCreate(directory);
		}
        for ( artifactResult in resolved.getArtifactResults() ) {
			if(unzip) {
				zip action="unzip" file="#file#" destination="#directory#" overwrite=true;
			} else {
				var artifactFile = artifactResult.getArtifact().getFile();
				if(!fileExists(directory & artifactFile.getName()))
				fileCopy(artifactFile.getAbsolutePath(),directory);
			}
        }
        return resolved.getArtifactResults();
	}

    public function directDependencies(required artifactId) {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( artifactId );
		var descriptorRequest = jArtifactDescriptorRequest.init();
        descriptorRequest.setArtifact( artifact ).setRepositories( getRepositories() );
        var descriptorResult = getSystem().readArtifactDescriptor( msession, descriptorRequest );
        var deps = [];
        for ( var dependency in descriptorResult.getDependencies() )
        {
        	var dep = {
            	artifactId:dependency.getArtifact().toString(),
            	artifact:dependency.getArtifact(),
            	optional:dependency.isOptional(),
            	resolved:resolved(dependency.getArtifact().toString()),
            	scope:dependency.getScope()
			};
            arrayAppend(deps,dep);
        }
        return deps;
    }

    public function collectDependencies(artifactId,scopes="") {
        var msession = getSession();
        var artifact = jDefaultArtifact.init( artifactId );
        var collectRequest = jCollectRequest.init();
        collectRequest.setRoot( jDependency.init( artifact, "") );
        collectRequest.setRepositories( getRepositories() );
        var dependencies = getSystem().collectDependencies( msession, collectRequest );
        var graph = cl.create("org.eclipse.aether.util.graph.visitor.PreorderNodeListGenerator").init();
        dependencies.getRoot().accept( graph );
        var deps = [];
        for ( var dependency in graph.getDependencies(true) )
        {
        	var dep = {
            	artifactId:dependency.getArtifact().toString(),
            	artifact:dependency.getArtifact(),
            	optional:dependency.isOptional(),
            	resolved:resolved(dependency.getArtifact().toString()),
            	scope:dependency.getScope()
			};
            arrayAppend(deps,dep);
        }
        return deps;
    }


    private function getSettings() {
        if ( isNull(settings)) {
            var srequest = jDefaultSettingsBuildingRequest.init();
//            srequest.setUserSettingsFile( getUserSettings() );
//            srequest.setGlobalSettingsFile( getGlobalSettings() );
//            srequest.setSystemProperties( getSystemProperties() );
//            srequest.setUserProperties( getUserProperties() );
            try {
                settings = _settingsBuilder.build( srequest ).getEffectiveSettings();
            } catch ( Any e ) {
                log( "Could not process settings.xml: " + e.message);
            }
//            result = settingsDecrypter.decrypt( new DefaultSettingsDecryptionRequest( settings ) );
//            settings.setServers( result.getServers() );
//            settings.setProxies( result.getProxies() );
        }
        return settings;
    }

    public function addRemoteRepository(name,type="default",repourl){
        var repo = jRemoteRepository.init( name, type, repourl ).build();
    	arrayAppend(variables.repositories,repo);
    }

    private function addDefaultRepositories(){
    	addRemoteRepository( "central", "default", "http://repo1.maven.org/maven2/" );
    	addRemoteRepository( "cfmlprojects", "default", "http://cfmlprojects.org/artifacts/" );
    }

    private function getDefaultLocalRepoDir(){
        return localRepositoryPath;
    }

    private function getProxySelector() {
        var selector = jDefaultProxySelector.init();
/*
        for ( proxy : proxies ) {
            selector.add( ConverterUtils.toProxy( proxy ), proxy.getNonProxyHosts() );
        }
        Settings settings = getSettings();
        for ( org.apache.maven.settings.Proxy proxy : settings.getProxies() ) {
            org.eclipse.aether.repository.Authentication auth = null;
            if ( proxy.getUsername() != null || proxy.getPassword() != null ) {
                auth = new org.eclipse.aether.repository.Authentication( proxy.getUsername(), proxy.getPassword() );
            }
            selector.add( new org.eclipse.aether.repository.Proxy( proxy.getProtocol(), proxy.getHost(),
                                                                    proxy.getPort(), auth ), proxy.getNonProxyHosts() );
        }
*/
        return selector;
    }

    private function getMirrorSelector() {
        var selector = jDefaultMirrorSelector.init();
/*
        for ( Mirror mirror : mirrors ) {
            selector.add( mirror.getId(), mirror.getUrl(), mirror.getType(), false, mirror.getMirrorOf(), null );
        }
        Settings settings = getSettings();
        for ( org.apache.maven.settings.Mirror mirror : settings.getMirrors() ) {
            selector.add( String.valueOf( mirror.getId() ), mirror.getUrl(), mirror.getLayout(), false,
                          mirror.getMirrorOf(), mirror.getMirrorOfLayouts() );
        }
*/
        return selector;
    }

    private function getAuthSelector() {
        var selector = jDefaultAuthenticationSelector.init();
/*
        Collection<String> ids = new HashSet<String>();
        for ( Authentication auth : authentications ) {
            List<String> servers = auth.getServers();
            if ( !servers.isEmpty() ) {
                org.eclipse.aether.repository.Authentication a = ConverterUtils.toAuthentication( auth );
                for ( String server : servers ) {
                    if ( ids.add( server ) ) {
                        selector.add( server, a );
                    }
                }
            }
        }
        Settings settings = getSettings();
        for ( Server server : settings.getServers() ) {
            org.eclipse.aether.repository.Authentication auth =
                new org.eclipse.aether.repository.Authentication( server.getUsername(), server.getPassword(),
                                                                   server.getPrivateKey(), server.getPassphrase() );
            selector.add( server.getId(), auth );
        }
*/
        return jConservativeAuthenticationSelector.init( selector );
    }

	/**
	 * Access point for this component.  Used for thread context loader wrapping.
	 **/
	function callMethod(methodName, required args) {
		var jThread = cl.create("java.lang.Thread");
		var cTL = jThread.currentThread().getContextClassLoader();
		jThread.currentThread().setContextClassLoader(cl.GETLOADER().getURLClassLoader());
		try{
			var theMethod = this[methodName];
			return theMethod(argumentCollection=args);
		} catch (any e) {
			jThread.currentThread().setContextClassLoader(cTL);
			throw(e);
		}
		jThread.currentThread().setContextClassLoader(cTL);
	}

}