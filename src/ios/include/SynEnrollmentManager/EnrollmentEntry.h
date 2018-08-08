#import <Foundation/Foundation.h>

typedef void (^OnSuccess)(NSString * responseData);
typedef void (^OnFailure)(NSError * error);
typedef void (^OnAPISuccess)(NSString * responseData,int statusCode);
typedef void (^OnGetTokenSuccess)(NSArray * success);

@protocol EnrollmentEntry <NSObject>

@property(weak,nonatomic) NSString* uniqueMessageId;
@property(weak,nonatomic) NSString* data;
@property(weak,nonatomic) NSString* status;
@property(weak,nonatomic) NSString* environment;

@end

@interface EnrollmentEntry : NSObject <EnrollmentEntry>

@end
