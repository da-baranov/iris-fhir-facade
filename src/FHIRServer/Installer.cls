Class FHIRServer.Installer [ Abstract ]
{

ClassMethod InstallFHIRServer(fhirFondation As %String, appKey As %String, debugMode As %Integer) As %Status
{
    Set st = $$$OK

    // Install FHIR server
    ZN fhirFondation
    Do $SYSTEM.OBJ.CompilePackage("FHIRServer")

    Set appKey = appKey
    // Set mainStrategyClass = "HS.FHIRServer.Storage.JsonAdvSQL.InteractionsStrategy"
    Set mainStrategyClass = "FHIRServer.ADHDSInteractionsStrategy"
    Set metadataPackages = $lb("hl7.fhir.r4.core@4.0.1")

    // Set components fo FHIR
    Do ##class(HS.FHIRServer.Installer).InstallNamespace()

    // FHIR-instance installation
    If '##class(HS.FHIRServer.ServiceAdmin).EndpointExists(appKey) {
        Do ##class(HS.FHIRServer.Installer).InstallInstance(appKey, mainStrategyClass, metadataPackages)
    }

    // Set debug mode
    Set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(appKey)
    Set config = strategy.GetServiceConfigData()
    Set config.DebugMode = debugMode
    Do strategy.SaveServiceConfigData(config)

    Return $$$OK
}

ClassMethod Install()
{
    Set ns = "ADHDS"
    Set fhirEndpoint = "/csp/healthshare/adhds/fhir/r4"
    Do ..InstallFHIRServer(ns, fhirEndpoint, 7) // 7 = 1 || 2 || 4

    // SEED
    Do $system.OBJ.CompilePackage("DemoData")
    Do ##class(DemoData.Seed).SeedPatients()
}

}
