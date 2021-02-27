//
//  SetLocationPermission.m
//  applesimutils
//
//  Created by Leo Natan on 19/04/2017.
//  Copyright © 2017-2021 Leo Natan. All rights reserved.
//

#import "SetLocationPermission.h"
#import "SimUtils.h"

static void startStopLocationdCtl(NSString* simulatorId, BOOL stop)
{
	NSURL *locationdDaemonURL = [SetLocationPermission locationdURL];
	NSCAssert(locationdDaemonURL != nil, @"Launch daemon “com.apple.locationd” not found. Please open an issue.");
	
	NSTask* rebootTask = [NSTask new];
	rebootTask.launchPath = [SimUtils xcrunURL].path;
	rebootTask.arguments = @[@"simctl", @"spawn", simulatorId, @"launchctl", stop ? @"unload" : @"load", locationdDaemonURL.path];
	[rebootTask launch];
	[rebootTask waitUntilExit];
}

@implementation SetLocationPermission

+ (NSURL*)locationdURL
{
	static NSURL *locationdDaemonURL;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		 locationdDaemonURL = [SimUtils launchDaemonPlistURLForDaemon:@"com.apple.locationd"];
	});
	return locationdDaemonURL;
}

+ (BOOL)setLocationPermission:(NSString*)permission forBundleIdentifier:(NSString*)bundleIdentifier simulatorIdentifier:(NSString*)simulatorId error:(NSError**)error
{
	LNLog(LNLogLevelDebug, @"Setting location permission");
	
	NSURL* plistURL = [[SimUtils libraryURLForSimulatorId:simulatorId] URLByAppendingPathComponent:@"Caches/locationd/clients.plist"];
	
	NSData* plistData = [NSData dataWithContentsOfURL:plistURL];
	NSMutableDictionary* locationClients;
	if(plistData == nil)
	{
		locationClients = [NSMutableDictionary new];
	}
	else
	{
		locationClients = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListMutableContainers format:nil error:error];
	}
	
	if(locationClients == nil)
	{
		*error = [NSError errorWithDomain:@"SetLocationPermissionsError" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Unable to parse clients.plist"}];
		return NO;
	}
	
	if([permission isEqualToString:@"unset"])
	{
		[locationClients removeObjectForKey:bundleIdentifier];
	}
	else
	{
		NSMutableDictionary* bundlePermissions = locationClients[bundleIdentifier];
		if(bundlePermissions == nil)
		{
			bundlePermissions = [NSMutableDictionary new];
		}
		
		NSDictionary* permissionMapping = @{@"never": @1, @"inuse": @2, @"always": @4};
		
		bundlePermissions[@"AuthorizationUpgradeAvailable"] = @NO;
		bundlePermissions[@"SupportedAuthorizationMask"] = @7;
		bundlePermissions[@"Authorization"] = permissionMapping[permission];
		bundlePermissions[@"BundleId"] = bundleIdentifier;
		bundlePermissions[@"Whitelisted"] = @NO;
		
		NSURL* binaryURL = [SimUtils binaryURLForBundleId:bundleIdentifier simulatorId:simulatorId];
		NSString* path = binaryURL != nil ? binaryURL.path : @"";
		
		bundlePermissions[@"Executable"] = path;
		bundlePermissions[@"Registered"] = path;
		bundlePermissions[@"TrialPeriodBegin"] = @([NSDate.date timeIntervalSinceReferenceDate]);
		
		locationClients[bundleIdentifier] = bundlePermissions;
	}
	
	startStopLocationdCtl(simulatorId, YES);
	
	[[NSPropertyListSerialization dataWithPropertyList:locationClients format:NSPropertyListBinaryFormat_v1_0 options:0 error:NULL] writeToURL:plistURL atomically:YES];
	
	startStopLocationdCtl(simulatorId, NO);
	
	return YES;
}

@end
