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
* Look for intent "BROWSABLE", this means the app or activity can be opened through the browser
* Activities
  * Review entry points of the activity; "onCreate", "onReceive", "query, insert, update, delete" (for Content Provider), "onStartCommand, onBind" (for services)
  * If an activity does not have 'exported="true"' but does have an intent-filter, it might not be exposed
## Storage
* Private File Storage
  * App private sotrage is in /data/data/<app_name>
  * The owner and group of the app is u0_a<app_num>
    * If you can somehow change the world permissions on the directory, you can read the private storage
  * Make sure files that are created are "MOVE_PRIVATE"
* SD Card Storage
  * If app has "WRITE_EXTERNAL_STORAGE" in manifest, it has permission to write to SD card
  * If app has "READ_EXTERNAL_STORAGE" in manifest, it has permission to read to SD card
    * Check if a non privileged user can read the app's contents in SD storage
* Make sure all passwords are masked
* Look for SQL injection in any stored DB
* Directory Traversal
  * Make sure it's hard to traverse the directory when accessing files
    * The method "getCanonicalPath" of File class removes "." and ".." characters from file path
## Services
* Unprotected services
  * Look for "onStartCommand" and if the commands can be set
* Unprotected bound services
  * Look for "onBind" and if commands were set
* Messenger Vulnerability
  * Look for "handleMessage" and how it's set
## WebViews
* Security Configurations to Look For
  * "setAllowContentAccess" - default is true and it allows WebView access to content providers on system
  * "setAllowFileAccess" - default is true and it allows WebView to load content from filesystem using file:// scheme
  * "setAllowFileAccessFromFileURLs" - default is false for API >= 16 and it allows the HTML file that's loaded using file:// scheme to access other files on system
  * "setAllowUniversalAccessFromFileURLs" - default is false for API >= 16 and it allows HTML file loaded with file:// scheme to access content from any origin
  * "setJavaScriptEnabled" - default is false and it allows WebView to execute javascript
  * "setPluginState" - deprecated in API 18 and it allows loading of plugins (eg. Flash) inside of WebView
  * "setSavePassword" - deprecated in API 18, default is true and it allows WebView to save passwords entered
  * It is more secure if "setJavaScriptEnabled(false)" used
  * More secure if "setAllowFileAccessFromFileURLs(false)" and "setAllowContentAccess(false)"
  * More secure if web content validated by overriding "shouldInterceptRequest" and checking web content
* Intents and WebView
  * Look for intents that pass a url that loads a WebView
  * Look for "addJavascriptInterface" method to WebView because that's a bridge between the application and the javascript
  * Look for loading clear text or having SSL bypass code
  * Look for custom app updates or custom app store used
  * Make sure the WebView site uses HTTPS
## Native Code
* Discovery
  * Look for "System.loadLibrary", "System.load" or "native" keyword; these should load native code
  * The library loaded with "System.loadLibrary" needs be included in the APk under /lib but "System.load" can be anywhere in the filesystem
  * Look for remote loading of code (this can be native or C code)
    * Look for DexClassLoader class to load new code to the application
* Research
  * Need to use IDA or Ghidra to analyze the native binary
  * You can also attach a debugger to the native code
## Logic
* Check password reset logic and OTP (One Time Password - usually SMS text sent with code) entered
  * Check to make sure the OTP code isn't sent as part of the url request (otherwise, we can take it and use that for an accoun takeover)
* Watch out for passing in files or websites as post parameters
* Try adding empty strings as ID or string post params

