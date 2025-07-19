Class DemoData.PatientDTL Extends Ens.DataTransform
{

/// Transform an input object into an output object
ClassMethod Transform(source As DemoData.Patient, ByRef target As HS.FHIR.DTL.vR4.Model.Resource.Patient, ByRef aux) As %Status
{
    Try
    {
        Set patient = ##class(HS.FHIR.DTL.vR4.Model.Resource.Patient).%New()
        Set identifier = ##class(HS.FHIR.DTL.vR4.Model.Datatype.Identifier).%New()
        Set identifier.value = source.Identifier
        Do patient.identifier.Insert(identifier)
        Set patient.birthDate = ##class(%Library.TimeStamp).LogicalToXSD(source.BirthDate)
        Set patient.active = 1
        If (source.Gender = "M")
        {
            Set patient.gender = "male"
        }
        Else
        {
            Set patient.gender = "female"
        }
        Set name = ##class(HS.FHIR.DTL.vR4.Model.Datatype.HumanName).%New()
        Set name.family = source.Family
        Do name.given.Insert(source.Given)
        Do patient.name.Insert(name)
        Set target = patient
        Return $$$OK
    }
    Catch (ex)
    {
        Return ex.AsStatus()
    }
}

}
