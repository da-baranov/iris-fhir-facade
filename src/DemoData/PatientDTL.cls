Class DemoData.PatientDTL Extends Ens.DataTransform
{

/// Transform an input object into an output object
ClassMethod Transform(source As DemoData.Patient, ByRef target As HS.FHIR.DTL.vR4.Model.Resource.Patient, ByRef aux) As %Status
{
    Try
    {
        Set target = ##class(HS.FHIR.DTL.vR4.Model.Resource.Patient).%New()
        Set identifier = ##class(HS.FHIR.DTL.vR4.Model.Datatype.Identifier).%New()
        Set identifier.value = source.Identifier
        Set target.birthDate = source.BirthDate
        If (source.Gender = "M")
        {
            Set target.gender = "male"
        }
        Else
        {
            Set target.gender = "female"
        }
        Set name = ##class(HS.FHIR.DTL.vR4.Model.Datatype.HumanName).%New()
        Set name.family = source.Family
        Do name.given.Insert(source.Given)
        Return $$$OK
    }
    Catch (ex)
    {
        Return ex.AsStatus()
    }
}

}
