//
//  Settings.h
//  dyson
//
//  Created by Singh on 2018-06-16.
//  Copyright © 2018 Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enumerations.h"
@interface Settings : NSObject

+ (id) sharedInstance;
-(NSDictionary *) getEnvironmentDetailsFor:(Environment) environment;
@end
