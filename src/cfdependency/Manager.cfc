component {

  function init(localPath=getDirectoryFromPath(getMetadata(this).path) & "/repo", repositories="default") {
    var cfdependency.version = "1.0.1";
    localRepositoryPath = localPath;
    remotes = [];
    thisdir = getDirectoryFromPath(getMetadata(this).path);
    if(isSimpleValue(repositories) && repositories == "default") {
      addDefaultRepositories();
    } else {
      for(var repo in repositories){
        addRemoteRepository(repo.name,repo.url,repo.type);
      }
    }
    rawMaterialize("org.cfmlprojects:cfaether:zip:#cfdependency.version#","#thisdir#/aether",true);
    rawMaterialize("org.cfmlprojects:cfdependency:jar:#cfdependency.version#","#thisdir#/aether/lib");
    rawMaterialize("cfml:javatools:zip:1.0.0","#thisdir#/javatools",true);
    javaloader = new javatools.LibraryLoader(pathlist=thisdir & "/aether/lib/", id="aether-classloader")
    aether = new aether.Aether(localPath=localPath, javaloader=javaloader, repositories=repositories);
  }
/*
 * AETHER
 **/
  public function resolve(artifactId) {
    return aether.callMethod("resolveArtifact",arguments);
  }

  public function versions(artifactId) {
    return aether.callMethod("versions",arguments);
  }

  public function collect(artifactId) {
    return aether.callMethod("collectDependencies",arguments);
  }

  public function install(artifactId,artifactFile,pomFile) {
    return aether.callMethod("install",arguments);
  }

  public function deploy(artifactId,artifactFile,pomFile) {
    return aether.callMethod("deploy",arguments);
  }

  public function directDependencies(artifactId,artifactFile,pomFile) {
    return aether.callMethod("directDependencies",arguments);
  }

  public function managedDependencies(artifactId,artifactIds,exclusions) {
    return aether.callMethod("managedDependencies",arguments);
  }

  public function repositories() {
    return aether.callMethod("repositories",arguments);
  }

  public function pom(required artifactId, pomFile) {
    return aether.callMethod("pom",arguments);
  }

  public function materialize(artifactId, directory, Boolean unzip = false) {
    return aether.callMethod("materialize",arguments);
  }

/*
 * /AETHER
 **/

  public function rawMaterialize(artifact, directory, Boolean unzip = false) {
    var files = rawResolve(artifact);
    if(!directoryExists(directory)) {
      try {
        directoryCreate(directory);
        for(var file in files) {
          if(unzip) {
            zip action="unzip" file="#file#" destination="#directory#" overwrite=true;
          } else {
            fileCopy(file,directory);
          }
        }
      } catch (any e) {
        directoryDelete(directory,true);
        rethrow(e);
      }
    }
  }

  public function rawResolve(artifact, Boolean dependencies = true, scope="runtime") {
    var files = [];
    if(isArray(artifact)) {
      for(var afact in artifact) {
        arrayAppend(files,resolve(afact,dependencies));
      }
      return files;
    }
    var artifactPom = toPomArtifact(artifact);
    var filePath = getPathForLocalArtifact(artifact);
    if(!fileExists(filePath) || !hashMatch(filePath)) {
      var pomfile = getRemoteArtifact(artifactPom);
      var artifactFile = getRemoteArtifact(artifact);
      arrayAppend(files,filePath);
      if(dependencies) {
        var mavenData = xmlParse(pomFile);
        var deps = xmlSearch(mavendata,"//*[name() = 'project']/*[name()='dependencies']/*[name()='dependency']");
        for(var depXml in deps) {
          var dep = {};
          for(var el in depXML.XmlChildren)
            dep[el.xmlName] = el.xmlText;
          if(!isNull(dep.version) && (isNull(dep.scope) || dep.scope == scope)) {
            var depArtifact = toArtifact(dep);
            arrayAppend(files, getRemoteArtifact(depArtifact));
          }
        }
      }
    }
    return files;
  }

  public function addRemoteRepository(required name,required repourl, type="default"){
    var repo = { name : name, type: type, repourl: repourl };
    arrayAppend(variables.remotes,repo);
    if(!isNull(aether))
      aether.addRemoteRepository(name,repourl,type);
  }

  private function addDefaultRepositories(){
    var userHome = createObject("java","java.lang.System").getProperty("user.home");
    addRemoteRepository( "cfdistro", "file://#userHome#/cfdistro/artifacts/" );
    addRemoteRepository( "cfmlprojects", "http://cfmlprojects.org/artifacts/" );
    addRemoteRepository( "central", "http://repo1.maven.org/maven2/" );
  }

  public function toArtifact( Required coords, Struct properties={} ) {
    var artifact = {groupId:"", artifactId:"", extension:"jar", classifier:"", version:""};
    if(isStruct(coords)) {
      structAppend(artifact,coords);
      return artifact;
    }
    var java = {
      Pattern : createObject("java","java.util.regex.Pattern")
    }
    var p = java.Pattern.compile( "([^: ]+):([^: ]+)(:([^: ]*)(:([^: ]+))?)?:([^: ]+)" );
    var m = p.matcher( coords );
    if ( !m.matches() ){
        throw( message = "Bad artifact coordinates " & coords
            & ", expected format is <groupId>:<artifactId>[:<extension>[:<classifier>]]:<version>" );
    }
    artifact.groupId = m.group( 1 );
    artifact.artifactId = m.group( 2 );
    artifact.extension = isEmpty(m.group( 4 )) ? "jar" : m.group( 4 );
    artifact.type = artifact.extension;
    artifact.classifier = isEmpty(m.group( 6 )) ? "" : m.group( 6 );
    artifact.version = m.group( 7 );
    artifact.file = "";
    artifact.properties = properties;
    return artifact;
  }

  public function toPomArtifact( required artifact ) {
    artifact = toArtifact(artifact);
    var pom = duplicate(artifact);
    pom.extension = "pom";
    pom.type = artifact.extension;
    pom.classifier = "";
    return pom;
  }

  public function getPathForArtifact( Required artifact ) {
    artifact = toArtifact(artifact);
    var slashGroupId = replace( artifact.groupId, ".", "/", "all" );
    var classifierPath = artifact.classifier == "" ? "" : "-#artifact.classifier#";
    var artifactPath = "#slashGroupId#/#artifact.artifactId#/#artifact.version#/#artifact.artifactId#-#artifact.version##classifierPath#.#artifact.extension#";
    return artifactPath;
  }

  public function getPathForLocalArtifact( Required artifact ) {
    var artifactPath = localRepositoryPath & "/" & getPathForArtifact(artifact);
    return artifactPath;
  }

  private Boolean function hashMatch(filePath) {
    if(fileExists("#filePath#.sha1") && fileExists(filePath)) {
      var fileHash = lcase(hash(fileReadBinary(filePath),"sha1"));
      var goodHash = lcase(fileRead(filePath & ".sha1"));
      if( fileHash == goodHash) {
        return true;
      }
    } else if(fileExists("#filePath#.md5") && fileExists(filePath)) {
      var fileHash = lcase(hash(fileReadBinary(filePath),"md5"));
      var goodHash = lcase(fileRead(filePath & ".md5"));
      if( fileHash == goodHash) {
        return true;
      }
    }
    return false;
  }

  private Boolean function hasValidHash(artifact) {
    var filePath = getPathForLocalArtifact(artifact);
    return hashMatch(filePath);
  }

  private function getRemoteArtifact(artifact) {
    artifact = toArtifact(artifact);
    var filePath = getPathForArtifact(artifact);
    var mavenMetaPath = getDirectoryFromPath(filePath).replaceAll(artifact.version&"\/$","") & "maven-metadata.xml";
    getRemoteFile(mavenMetaPath);
    getRemoteFile(filePath);
    return getPathForLocalArtifact(artifact);
  }

  private function getRemoteFile(filepath) {
    var localPath = localRepositoryPath & "/" & filepath;
    logMessage( "resolving #filepath# (#localPath#)" );
    if(hashMatch(localPath)) {
      logMessage( "already resolved #filepath# (#localPath#)" );
      return localPath;
    }
    for(var repository in remotes) {
      logMessage( "Trying remote repository #repository.name#..." );
      var fileUrl = repository.repourl & filepath;
      logMessage( "Downloading #fileUrl#..." );
      if(!directoryExists(getDirectoryFromPath(localPath)))
        directoryCreate(getDirectoryFromPath(localPath));
      httpGet("#fileUrl#.md5","#localPath#.md5");
      httpGet("#fileUrl#.sha1","#localPath#.sha1");
      httpGet("#fileUrl#","#localPath#");
      if( hashMatch(localPath)) {
        break;
      }
    }
    if( !hashMatch(localPath)) {
      request.debug(messages);
      throw(message="could not get #filePath# or hash incorrect");
    }
    return filePath;
  }

  public function httpGet(uri,toFile){
    if(uri.startsWith("file:")) {
      if(fileExists(uri)) {
        fileCopy(uri,toFile);
      } else {
        throw(message="no file #uri#");
      }
    } else {
      http url=uri file=toFile result="httpResult";
      if(httpResult.status_code != 200) {
        fileDelete(toFile);
        throw(message="#httpResult.statuscode# error for #uri#");
      }
    }
  }

  public function logMessage(message){
    if(isNull(messages)) {
      messages = [];
    }
    arrayAppend(messages,message);
   }

  public function getInstance(){
    if ( instance == null ){
      lock type="exclusive" timeout="3" {
        if ( isNull(instance) ){
            instance = new Manager();
        }
      }
    }
    return instance;
  }

  public function dropInstance(){
    instance = javacast("null","");
  }

}