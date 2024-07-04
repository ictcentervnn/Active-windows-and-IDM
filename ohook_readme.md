ohook
=====
An universal Office "activation" hook with main focus of enabling full functionality of subscription editions.

This project is released mainly for [our partners](https://massgrave.dev/ohook.html). We won't be directly providing any kind of support for users.

Installation
------------
Example steps for 64-bit C2R Office running on a 64-bit version of Windows:

1. Create a symlink of the system `sppc.dll` in the Office C2R `System` directory as `sppcs.dll`:
```
mklink "%programfiles%\Microsoft Office\root\vfs\System\sppcs.dll" "%windir%\System32\sppc.dll"
```

2. Copy the hook library as `sppc.dll` to the Office C2R `System` directory
```
copy /y sppc64.dll "%programfiles%\Microsoft Office\root\vfs\System\sppc.dll"
```

3. (optional) In case of some Office editions which show "There was a problem checking this device's license status" banner, you may need to add the following to the `hosts` file:
```
0.0.0.0 ols.officeapps.live.com
```

4. Install a blank key for the edition you want to use.

Please note these steps are an example and are based on our internal tests. As stated before, no direct support will be provided for usage of this method. You should use one of the solutions provided by [our **authorized** partners](https://massgrave.dev/ohook.html) and direct your support queries to them.

Blank keys
----------
The table contains keys for probably the most needed editions.

|Edition|Marketing Name|Key|
|-------|--------------|---|
|O365HomePrem|Microsoft 365|`NBBBB-BBBBB-BBBBB-BBBBG-234RY`|
|O365ProPlus|Microsoft 365 Apps for enterprise|`NBBBB-BBBBB-BBBBB-BBBCF-PPK9C`|

How does this even work?
------------------------
As some would say, "It's trivial."

* The `sppc.dll` copied to the `System` directory in the Office is used instead of the system library.

* The only real license check is done during the startup of the Office applications using the `SLGetLicensingStatusInformation` function.

* The `SLGetLicensingStatusInformation` function can be easily hooked to lie about the activation status.

FAQ
---
### Why not just use a subscription edition with Mondo licenses?
This will be probably the most frequently asked question.

While Mondo 2016 licenses allow all the Office applications to work and support KMS activation, these are only partially updated for newer versions of Office. Thus, the product policy provided by these licenses lack some of the policies found in licenses for newer versions. Since Office product policy mainly consist of entries like `office-UUID`, there is no way to verify which features may not work.

With this method, a correct license for the installed edition is used, meaning every feature should work as intended.

There are also other issues with installing license files from other editions but we won't be bothering with them.

### Why is the modification of TimeOfLastHeartbeatFailure or the hosts file required in some cases?
After the license check, some Office editions make a request to the `ols.officeapps.live.com` service to retrieve an expiration date of user's subscription. This is done in order to evaluate should the local license be renewed. Since the service replies there is no subscription associated with the device, a notification is shown. Setting TimeOfLastHeartbeatFailure to some date in the future or modifying the hosts file prevents Office from doing this check.

### Will this enable 1TB of storage on OneDrive, Python in Excel or some other online feature?
No.

### ohook vs ohook+
A regular ohook build provides only a basic functionality of hooking up a licensing state response from the system.

A "plus" build of ohook, in addition to the functionality of regular ohook, modifies the TimeOfLastHeartbeatFailure value in the registry to prevent an online subscription check.

Generally, it is recommended to use a regular build of ohook, as it is much less invasive to the system and less likely to be falsely detected by an antivirus software.

License
-------
The project is licensed under the terms of the MIT License.
