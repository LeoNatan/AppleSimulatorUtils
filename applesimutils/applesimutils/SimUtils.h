//
//  SimUtils.h
//  applesimutils
//
//  Created by Leo Natan on 19/04/2017.
//  Copyright © 2017-2021 Leo Natan. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSTimeInterval AppleSimUtilsRetryTimeout;

@interface SimUtils : NSObject

+ (NSURL*)xcrunURL;
+ (NSURL*)developerURL;
+ (NSURL*)URLForSimulatorId:(NSString*)simulatorId;
+ (NSURL*)dataURLForSimulatorId:(NSString*)simulatorId;
+ (NSURL*)libraryURLForSimulatorId:(NSString*)simulatorId;
+ (NSURL*)binaryURLForBundleId:(NSString*)bundleId simulatorId:(NSString*)simulatorId;
+ (NSURL*)launchDaemonPlistURLForDaemon:(NSString*)daemon;
+ (void)restartSpringBoardForSimulatorId:(NSString*)simulatorId;

+ (void)registerCleanupBlock:(dispatch_block_t)block;

@end
