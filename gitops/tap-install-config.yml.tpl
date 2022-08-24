#@ load("@ytt:yaml", "yaml")
---
#@ def config():

#! full , view , build , iterate, run 
profile: view

tap:
  #! Set Backstage catalogs to include by default.
  catalogs:
  - https://github.com/tanzu-corp/tap-catalog/blob/main/catalog-info.yaml

  registry:
    host: registry.tanzu.corp
    repositories:
      buildService: tanzu/tanzu-build-service
      ootbSupplyChain: tanzu/tanzu-supply-chain

  domains:
    main: apps.tanzu.corp
    tapGui: tap-gui.apps.tanzu.corp
    learningCenter: learningcenter.apps.tanzu.corp
    knative: apps.tanzu.corp

  #! basic, testing, testing_scanning
  supply_chain: testing_scanning

  metadata_store:
    target: https://metadata-store-app.metadata-store:8443/api/v1
    auth_token: "ey..."
  
  techdocs:
    airgapped:
      bucketName: bucketname
      accessKeyId: admin
      secretAccessKey: pass
      endpoint: http://minio.example.com
  #! no need to provide value if not using multi cluster setup
  multiCluster:
    run:
      url: CLUSTER-URL
      name: run-cluster
      serviceAccountToken: "CLUSTER-TOKEN"
      skipTLSVerify: true
    build:
      url: CLUSTER-URL
      name: build-cluster
      serviceAccountToken: "CLUSTER-TOKEN"
      skipTLSVerify: true
    iterate:
      url: CLUSTER-URL
      name: iterate-cluster
      serviceAccountToken: "CLUSTER-TOKEN"
      skipTLSVerify: true

grype:
  metadataStore:
    url: metadata-store.apps.mytanzu.org
#@ end
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: tap-install-gitops
  namespace: tap-install-gitops
data:
  tap-config.yml: #@ yaml.encode(config())
