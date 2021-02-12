/*
 * Copyright (c) 2011-2020 HERE Europe B.V.
 * All rights reserved.
 */

#import "AppDelegate.h"
#import <NMAKit/NMAKit.h>

// To obtain the application credentials, please register at https://developer.here.com/develop/mobile-sdks
NSString* const appID = @"ennF6lADcnxKrcutFqak";
NSString* const appCode = @"-pY8CbasVdUHyCEji1elFw";
NSString* const license = @"Nct8Mdkx0IJu+nAMAoxXogJg8vwvbMUHHXYsbsFbYQWAJg8Ygi+pHn1SAbksXTuTVWN9wdxXX8oEh5dc0/r7xHCcWqN3yCIW3tm+17JETktDjL/P1lOo6jQAJq7XIfQWnuPz+mH7aQhaD56eZTseEBZt5laLYwMrk7RChuBXQNHi5oZq6IAhm5D0CTUejbYjMUYYq5nEeZt0SDk1D6aISLnXvIjdQNHJqhXDKGP9cq5iUNS9WLCRwuSx8mWDbZMEfZyRPzcgxMNoFU1+0xbUwIOkYCtKaUMSnUmITcE+JhsaF3iahwsgUxfOmyNRHyqF2BZ82aboKgyUdHMTEagtX0tT4Qz5jphhrHms0PbVg7TDDtmpfoAdqLuB9+aoU1eCMnPfdWtSls9gmpbALkwSR8uRdvH4JmZXjvYNgzO8tY6iwzoRqbbQpEHHxaTC2fmZKmMh2Md1zEw4G7NUJvDefB5R+SBORj6TPFsL1DrPFawSVwxxgylrEk3FnROg6Y9qy+p5OII6hiF5iHH+ZdtSJfkfFJ5k6mv3zPvP7nx/VpEPyYJJSkfE4QhrEhSAy6P5vrlz0GAOm7DW22GU6QWA9iqWnmMfUi8DwE7YAsnNqOXm9HbgVHi9gGumoYRRKozknhmVY7zN71XsNMI40oQ3tkWrZaxMoMmwcU0bk/AmL6w=";

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // set application credentials
    [NMAApplicationContext setAppId:appID
                            appCode:appCode
                         licenseKey:license];
    return YES;
}

@end
