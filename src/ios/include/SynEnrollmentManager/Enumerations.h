typedef enum ServiceBusPriority{
    HIGH_1,
    HIGH_2,
    LOW_1,
    LOW_2
} ServiceBusPriority;

typedef enum Environment {
    PROD,
    TESTPROD,
    TESTSYS,
    DEVPROD,
    DEVSYS,
    DEVDEV
} Environment;

@interface Enumerations : NSObject

+(NSString *) getServiceBusPriorityStringFromEnum:(ServiceBusPriority) priority;
+(int) getEnvironmentEnumFromString:(NSString *) environment;

@end
