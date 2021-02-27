//
//  SetServicePermission.h
//  applesimutils
//
//  Created by Leo Natan on 02/04/2017.
//  Copyright © 2017-2021 Leo Natan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetServicePermission : NSObject

+ (BOOL)isSimulatorReadyForPersmissions:(NSString*)simulatorId;
+ (BOOL)setPermisionStatus:(NSString*)status forService:(NSString*)service bundleIdentifier:(NSString*)bundleIdentifier simulatorIdentifier:(NSString*)simulatorId operatingSystemVersion:(NSOperatingSystemVersion)operatingSystemVersion error:(NSError**)error;

@end
