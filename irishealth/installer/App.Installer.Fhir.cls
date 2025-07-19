Class App.Installer.Fhir
{

ClassMethod InstallFoundation(fhirFondation As %String)
{
    // Insall foundation namespace
    ZN "HSLIB"
    Do ##class(HS.Util.Installer.Foundation).Install(fhirFondation)
}

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

}
