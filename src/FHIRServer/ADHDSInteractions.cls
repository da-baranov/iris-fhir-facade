Class FHIRServer.ADHDSInteractions Extends HS.FHIRServer.Storage.JsonAdvSQL.Interactions
{

Parameter ResourceValidatorClass = "FHIRServer.ADHDSResourceValidator";

Parameter BatchHandlerClass = "FHIRServer.ADHDSBundleProcessor";

Parameter OperationHandlerClass = "FHIRServer.ADHDSCustomOperations";

Method Read(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %DynamicObject
{
    #Dim status as %Status

	If (pResourceType = "Patient")
    {
        // Check if the patient exists
        If (##class(DemoData.Patient).%ExistsId(pResourceId) = 0)
        {
            Return $$$NULLOREF // HTTP 404
        }

        // Read entity
        #Dim patientEntity as DemoData.Patient
        Set patientEntity = ##class(DemoData.Patient).%OpenId(pResourceId)

        // Transform entity to FHIR
        Set status = ##class(DemoData.PatientDTL).Transform(patientEntity, .patient)

        // Transform FHIR to %DynamicObject

        // Return

    }
    return ##super(pResourceType, pResourceId, pVersionId)
}

}
