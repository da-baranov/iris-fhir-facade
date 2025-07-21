Class App.Installer Extends %RegisteredObject
{

ClassMethod SetupNamespace(nsName As %String) As %Status
{
    If nsName="" {
        Write "Error: Namespace name cannot be empty", !
        Quit $$$ERROR($$$GeneralError, "Namespace name cannot be empty")
    }

    Set dbName = nsName
    Set dbProperties("Name") = dbName
    Set dbProperties("Path") = "/usr/irissys/databases/"_dbName

    Set sc = ##Class(Config.Databases).Create(dbName, .dbProperties)

    If $$$ISERR(sc) {
        Write "Error creating database: ", $SYSTEM.Status.GetErrorText(sc), !
        Quit sc
    }

    Set nsProperties("Globals") = dbName
    Set nsProperties("Routines") = dbName
    Set nsProperties("DefaultDatabase") = dbName
    Set nsProperties("RoutineDatabase") = dbName

    Set sc = ##Class(Config.Namespaces).Create(nsName, .nsProperties)

    If $$$ISERR(sc) {
        Write "Error creating namespace: ", $SYSTEM.Status.GetErrorText(sc), !
        Quit sc
    }

    Quit $$$OK
}

ClassMethod AddWebApp(ns As %String, webName As %String, MatchRoles As %String) As %Status
{ 
    Set namespace = ns
    ZN "%SYS"
    Set webName = webName
    Set webProperties("NameSpace") = namespace
    Set webProperties("Enabled") = 1
    Set webProperties("AutheEnabled") = 96 // Password + Unauthenticated
    Set webProperties("ServeFiles") = 2
    Set webProperties("Recurse") = 1
    Set webProperties("MatchRoles") = MatchRoles
    Set webProperties("Type")=2 // CSP Web App

    Set sc = ##class(Security.Applications).Create(webName, .webProperties)

    If $$$ISERR(sc) {
        Write "Error creating web application: ", $SYSTEM.Status.GetErrorText(sc), !
    } Else {
        Write "Web application created: ", webName, " in namespace ", namespace, !
    }

    Quit sc
}
}