Class FHIRServer.Util Extends %RegisteredObject
{

ClassMethod ToDynamicObject(res As HS.FHIR.DTL.vR4.Model.Base.Resource) As %DynamicObject
{
    #Dim stream as %Stream.Object 
    Set stream = res.ToJSON()
    Do stream.Rewind()
    Return {}.%FromJSON(stream)
}

ClassMethod ToISODateTime(value As %Library.TimeStamp) As %String
{
    Return $ZDATE(value,3) _ "T" _ $ZTIME(value, 1)
}

}
