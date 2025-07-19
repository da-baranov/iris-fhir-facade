Class FHIRServer.ADHDSInteractions Extends HS.FHIRServer.Storage.JsonAdvSQL.Interactions
{

Parameter ResourceValidatorClass = "FHIRServer.ADHDSResourceValidator";

Parameter BatchHandlerClass = "FHIRServer.ADHDSBundleProcessor";

Parameter OperationHandlerClass = "FHIRServer.ADHDSCustomOperations";

/// The method intercepts FHIR read interactions (e.g. /Patient/1)
Method Read(pResourceType As %String, pResourceId As %String, pVersionId As %String = "") As %DynamicObject
{
    #Dim status as %Status

	If (pResourceType = "Patient")
    {
        // Check if the patient exists
        If (##class(DemoData.Patient).%ExistsId(pResourceId) = 0)
        {
            // Correctly handle 404
            $$$ThrowFHIR($$$HSFHIRErrResourceNotFound, pResourceType, pResourceId, $$$OutcomeNotFound)
        }

        // Read entity
        #Dim patientEntity as DemoData.Patient
        Set patientEntity = ##class(DemoData.Patient).%OpenId(pResourceId)

        // Transform entity to FHIR
        #Dim patient as HS.FHIR.DTL.vR4.Model.Resource.Patient
        Set status = ##class(DemoData.PatientDTL).Transform(patientEntity, .patient)
        If $$$ISERR(status)
        {
            $$$ThrowStatus(status)
        }

        // Transform FHIR resource to %DynamicObject
        #Dim result as %DynamicObject = ##class(Util).ToDynamicObject(patient)
        Return result

    }
    return ##super(pResourceType, pResourceId, pVersionId)
}

/// The method overrides FHIR search interactions (e.g. /Patient?given=Dmitry)
Method Search(pResourceType As %String, pCompartment As %String, pCompartmentId As %String, pParameters As HS.FHIRServer.API.Data.QueryParameters = "", ByRef pSortKeys = "") As HS.FHIRServer.Util.SearchResult
{
    If (pResourceType = "Patient")
    {
        // Initialize a resultset
        #Dim result as HS.FHIRServer.Util.SearchResult
        Set result = ##class(HS.FHIRServer.Util.SearchResult).Create()

        // Parse parameters
        #Dim family = pParameters.GetParameterValue("family")
        #Dim given as %String = pParameters.GetParameterValue("given")

        // Prepare and execute SQL
        #Dim st
        Set st = $SYSTEM.SQL.Prepare("select ID from DemoData.Patient where 1 = 1 and (? is null or ? = Given) and (? is null or ? = Family)")
        Set rs = st.execute(given, given, family, family)

        // Iterate recordset
        While (rs.%Next())
        {
            Set patientEntity = ##class(DemoData.Patient).%OpenId(rs.%Get("ID"))
            #Dim patient as HS.FHIR.DTL.vR4.Model.Resource.Patient
            $$$ThrowOnError(##class(DemoData.PatientDTL).Transform(patientEntity, .patient))
            Set patientJson = ##class(Util).ToDynamicObject(patient)
            Do result.AddRow(patientEntity.%Id(), "Patient", patientEntity.%Id(), 1, "match", , patientJson, "http://", "123")
        }

        // Return
        Return result
    }
	return ##super(pResourceType, pCompartment, pCompartmentId, pParameters, .pSortKeys)
}

}
