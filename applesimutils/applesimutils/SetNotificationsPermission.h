//
//  SetNotificationsPermission.h
//  applesimutils
//
//  Created by Leo Natan on 30/03/2017.
//  Copyright © 2017-2021 Leo Natan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetNotificationsPermission : NSObject

+ (BOOL)setNotificationsStatus:(NSString*)enabled forBundleIdentifier:(NSString*)bundleIdentifier displayName:(NSString*)displayName simulatorIdentifier:(NSString*)simulatorId error:(NSError**)error;

@end
