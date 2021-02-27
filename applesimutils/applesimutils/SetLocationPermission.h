//
//  SetLocationPermission.h
//  applesimutils
//
//  Created by Leo Natan on 19/04/2017.
//  Copyright © 2017-2021 Leo Natan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetLocationPermission : NSObject

+ (NSURL*)locationdURL;

+ (BOOL)setLocationPermission:(NSString*)permission forBundleIdentifier:(NSString*)bundleIdentifier simulatorIdentifier:(NSString*)simulatorId error:(NSError**)error;

@end
