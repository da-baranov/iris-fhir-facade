Class FHIRServer.Util Extends %RegisteredObject
{

ClassMethod ToDynamicObject(res As HS.FHIR.DTL.vR4.Model.Base.Resource) As %DynamicObject
{
    If (res = $$$NULLOREF) Return ""

    #Dim stream as %Stream.Object 
    Set stream = res.ToJSON()
    Do stream.Rewind()
    #Dim result as %DynamicObject
    Set result = {}.%FromJSON(stream)
    Kill stream
    Return result
}

ClassMethod ToISODateTime(value As %Library.TimeStamp) As %String
{
    Return $ZDATE(value,3) _ "T" _ $ZTIME(value, 1)
}

ClassMethod SetFullDebugMode()
{
    Set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint("/csp/healthshare/adhds/fhir/r4")
    Set config = strategy.GetServiceConfigData()
    Set config.DebugMode = 7 // = 1 | 2 | 4
    Write config.DebugMode, !
    Do strategy.SaveServiceConfigData(config)
}

}
