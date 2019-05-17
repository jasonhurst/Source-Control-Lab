import org.sonatype.nexus.repository.config.Configuration
import org.sonatype.nexus.repository.manager.RepositoryManager

def manager = container.lookup(RepositoryManager.class.name)
manager.create(new Configuration(
    repositoryName: 'install-artifacts',
    recipeName: 'maven2-hosted',
    online: true,
    attributes: [
        maven: [
            versionPolicy: 'RELEASE',
            layoutPolicy: 'PERMISSIVE'
        ],
        storage: [
            blobStoreName: 'default',
            writePolicy: 'ALLOW'
        ]
    ]
))