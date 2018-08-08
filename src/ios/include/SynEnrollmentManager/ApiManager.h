
#import <Foundation/Foundation.h>
#import "EnrollmentEntry.h"
@interface ApiManager : NSObject

+ (id) sharedInstance;

- (void) requestServerAtPathURL:(NSURL *)url httpBody:(NSData *)httpBody httpMethodType:(NSString *)httpMethodType httpHeaders:(NSDictionary *) httpHeaders success:(OnAPISuccess)success failure:(OnFailure)failure;

@end
