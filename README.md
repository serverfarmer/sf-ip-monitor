sf-ip-monitor extension periodically checks the external IP of current server
for changes and notifies administrator about such changes.

This extension is meant for monitoring services connected to Internet through
DSL or similar lines, with dynamic IP, which changes very rarely. Such Internet
connections are perfect choice for particular service types, eg. distributed
backup services, where it is acceptable that the service is inaccessible for
users for a few minutes each few months/years. And this extension notifies
owner that IP just changed and DNS needs to be updated asap.
