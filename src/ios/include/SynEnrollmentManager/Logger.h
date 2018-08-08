#import <Foundation/Foundation.h>

@interface Logger : NSObject

@property(nonatomic) BOOL isLoggingEnabled;

+(id) sharedInstance;

-(void) logInfo:(NSString *) format, ... ;

-(void) logDebug:(NSString *) format, ... ;

-(void) logError:(NSString *) format, ... ;

@end
