Class DemoData.Seed Extends %RegisteredObject
{

ClassMethod GetRandomPerson() As Patient
{
    // Arrays of British first names and surnames (10 each for total of 20 names)
    Set firstNames = $ListBuild("James", "William", "Oliver", "Benjamin", "Henry", "Charlotte", "Amelia", "Olivia", "Emily", "Sophie")
    Set lastNames = $ListBuild("Smith", "Johnson", "Williams", "Brown", "Jones", "Miller", "Davis", "Wilson", "Moore", "Taylor")
    
    // Get random indices (1-10 for each array)
    Set firstIndex = $Random(10) + 1
    Set lastIndex = $Random(10) + 1
    
    // Get random first and last name
    Set firstName = $ListGet(firstNames, firstIndex)
    Set lastName = $ListGet(lastNames, lastIndex)
    
    #Dim result as Patient = ##class(Patient).%New()
    Set result.Family = lastName
    Set result.Given = firstName

    If firstIndex <= 5 
    {
        Set result.Gender = "M"
    }
    Else
    {
        Set result.Gender = "F"
    }
    
    Set result.BirthDate = ..GetRandomPastTimestamp()
    Set result.Identifier = ..GetRandomSSN()
    Return result
}

ClassMethod GetRandomPastTimestamp() As %Library.TimeStamp
{
    Set r = -($RANDOM(40) + 40)
    #Dim rv As %Library.TimeStamp = ""
    #Dim rs as %SQL.StatementResult
    #Dim sql = "select dateadd('year', ?, now()) as rv"
    Set st = $System.SQL.Prepare(sql)
    Set rs = st.execute(r)
    Do rs.%Next()
    Set rv = rs.%Get("rv")
    Set rs = ""
    Set st = ""
    return rv
}

ClassMethod GetRandomSSN() As %String
{
    Set areaNum = $Random(898) + 1
    If areaNum >= 666 {
        Set areaNum = areaNum + 1
    }
    Set groupNum = $Random(99) + 1
    Set serialNum = $Random(9999) + 1
    Set ssn = $Translate($Justify(areaNum, 3), " ", "0") _ "-" _ 
              $Translate($Justify(groupNum, 2), " ", "0") _ "-" _ 
              $Translate($Justify(serialNum, 4), " ", "0")
    
    Return ssn
}

ClassMethod SeedPatients()
{
    For i = 1:1:1000
    {
        Set patient = ..GetRandomPerson()
        $$$ThrowOnError(patient.%Save())
    }
    Write "Seeding OK", !
}

ClassMethod Temp()
{
    Set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint("/csp/healthshare/adhds/fhir/r4")
    Set config = strategy.GetServiceConfigData()
    Set config.DebugMode = 7
    Write config.DebugMode, !
    Do strategy.SaveServiceConfigData(config)
}

}
