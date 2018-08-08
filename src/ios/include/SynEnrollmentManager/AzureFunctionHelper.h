#import <Foundation/Foundation.h>
#import "ApiManager.h"
#import "EnrollmentEntry.h"

@interface AzureFunctionHelper : NSObject

+ (id) sharedInstance;

-(void) sendDataToAzureFunction:(EnrollmentEntry *) entry
                     WithOnSuccess:(OnSuccess)success
                        AndFailure:(OnFailure)failure;

@end
