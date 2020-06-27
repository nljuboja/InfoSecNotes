# Android Notes
## Android Manifest
* Exported components
  * Look for 'exported="true"' in some of the components; that means that other applications can interact with it
    * Acitivities - UI windows of an application
      * An exported activity means that another app can call that activity directly if no permissions are set
      * Look for activity sending information backout when "finished()" is called, it could have some information with "setResult"
      * A privileged user can call a non exported activity
      * If there's an exported activity, does the activity check if the user has already logged in?
    * Fragments - smaller UI windows, "sub activities"
      * In versions before Android 4.3, PreferenceActivity had a vulnerability to inject fragments
  * The tag "intent-filter" is automatically exported by default and there's no export flag
* Permissions
  * The signature level means that only apps with same certificate can be granted permission
## Intents
* Content provider
  * SQL Injection
    * Look for cursor queueries because you might be able to use the "uri", "selection" and "sortOrder" in the SQL query
  * File-Backed Content Providers
    * Look for "openFile" and check if you can set a file path
  * Broadcast Receivers
    * Application specifies custom broadcast receivers and does not specify permissions
    * These can exposed in the manifest and examined in there, "<receiver\>" and "exported" in the tag
    * Look for "sendBroadcast" and what code is run on "onReceive"
      * Could also be registered at runtime using "registerReceiver"
    * Intent Sniffing
      * Look for "sendBroadcast" and another app registers to receive broadcasts
## Storage
## Services
* Unprotected services
  * Look for "onStartCommand" and if the commands can be set
* Unprotected bound services
  * Look for "onBind" and if commands were set
* Messenger Vulnerability
  * Look for "handleMessage" and how it's set
