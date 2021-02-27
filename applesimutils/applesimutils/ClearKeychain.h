//
//  ClearKeychain.h
//  applesimutils
//
//  Created by Leo Natan on 16/10/2017.
//  Copyright © 2017-2021 Leo Natan. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSURL* securitydURL(void);

extern void performClearKeychainPass(NSString* simulatorIdentifier);
