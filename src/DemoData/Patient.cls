Class DemoData.Patient Extends %Persistent
{

Property Identifier As %String(MAXLEN = 20);

Property Family As %String(MAXLEN = 200);

Property Given As %String(MAXLEN = 200);

Property BirthDate As %TimeStamp;

Property Gender As %String(MAXLEN = 1);

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Identifier</Value>
</Value>
<Value name="3">
<Value>Family</Value>
</Value>
<Value name="4">
<Value>Given</Value>
</Value>
<Value name="5">
<Value>BirthDate</Value>
</Value>
<Value name="6">
<Value>Gender</Value>
</Value>
</Data>
<DataLocation>^DemoData.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^DemoData.PatientD</IdLocation>
<IndexLocation>^DemoData.PatientI</IndexLocation>
<StreamLocation>^DemoData.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
