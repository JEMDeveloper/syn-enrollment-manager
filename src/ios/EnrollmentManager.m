#import "EnrollmentManager.h"
#import "ACPTModel.h"
#import "Logger.h"

@implementation EnrollmentManager

static int const NUMBER_OF_REQUIRED_PARAMETERS_IN_SAVE = 2;
static int const NUMBER_OF_REQUIRED_PARAMETERS_IN_GET = 1;
static int const NUMBER_OF_REQUIRED_PARAMETERS_IN_REMOVE = 1;
static int const NUMBER_OF_REQUIRED_PARAMETERS_IN_CHANGE_STATUS = 2;
static int const NUMBER_OF_REQUIRED_PARAMETERS_IN_SEND_TO_AZURE_FUNCTION = 3;
static NSString const *APP_ID_PREFIX = @"LDR9D628P7";

//PRAGMA MARK: INIT METHODS

- (void) setupKeychainWithServiceName:(CDVInvokedUrlCommand *) command{

    [self.commandDelegate runInBackground:^{
        NSString *serviceName = [command.arguments objectAtIndex:0];
        NSString *bundleIdentifier = [command.arguments objectAtIndex:1];
        NSString *accessGroup = [NSString stringWithFormat: @"%@.%@",APP_ID_PREFIX,bundleIdentifier];
        keychain = [UICKeyChainStore keyChainStoreWithService:serviceName accessGroup:accessGroup];
    }];

}

//PRAGMA MARK: KEYCHAIN METHODS

- (bool) hasRequiredNumberOfArguments: (NSArray *) array numberOfRequiredArguments: (int) numberOfRequiredArguments{
    bool result = ([array count] == numberOfRequiredArguments);
    return result;
}

- (void) saveValueInKeychain: (CDVInvokedUrlCommand *) command {

    [self.commandDelegate runInBackground:^{

        CDVPluginResult* pluginResult = nil;
        bool hasRequiredArguments = [self hasRequiredNumberOfArguments:command.arguments
                                             numberOfRequiredArguments:NUMBER_OF_REQUIRED_PARAMETERS_IN_SAVE];
        if(hasRequiredArguments){

            NSString *key = [command.arguments objectAtIndex:0];
            NSString *value = [command.arguments objectAtIndex:1];

            NSError *error;
            [keychain setString:value forKey:key error:&error];
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
            }else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            }
        }
        else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                             messageAsString:@"incorrect number of arguments for saveValueInKeychain"];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void) getValueFromKeychain: (CDVInvokedUrlCommand *) command{


    [self.commandDelegate runInBackground:^{

        CDVPluginResult* pluginResult = nil;

        bool hasRequiredArguments = [self hasRequiredNumberOfArguments:command.arguments
                                             numberOfRequiredArguments:NUMBER_OF_REQUIRED_PARAMETERS_IN_GET];
        if(hasRequiredArguments){

            NSString *key = [command.arguments objectAtIndex:0];

            NSError *error;
            NSString *result = [keychain stringForKey:key error:&error];
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
            }else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString :result];
            }
        }
        else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                             messageAsString:@"incorrect number of arguments for getValueFromKeychain"];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void) getAllKeysFromKeychain: (CDVInvokedUrlCommand *) command{

    [self.commandDelegate runInBackground:^{

        NSArray *items = keychain.allKeys;

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:items];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];
}

- (void) removeValueFromKeychain: (CDVInvokedUrlCommand *) command{

    [self.commandDelegate runInBackground:^{

        CDVPluginResult* pluginResult = nil;

        bool hasRequiredArguments = [self hasRequiredNumberOfArguments:command.arguments
                                             numberOfRequiredArguments:NUMBER_OF_REQUIRED_PARAMETERS_IN_REMOVE];
        if(hasRequiredArguments){

            NSString *key = [command.arguments objectAtIndex:0];
            NSError *error;
            [keychain removeItemForKey:key error:&error];
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
            }else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            }
        }
        else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                             messageAsString:@"incorrect number of arguments for getValueFromKeychain"];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void) getAllItemsFromKeychain: (CDVInvokedUrlCommand *) command{

    [self.commandDelegate runInBackground:^{

        NSMutableArray *items = [[NSMutableArray alloc] init];
        NSArray *keychainItems = keychain.allItems;

        for( NSDictionary *item in keychainItems){
            NSString *keyValuePair = [[NSString alloc] initWithFormat:@"%@:%@",item[@"key"],item[@"value"]];
            [items addObject:keyValuePair];
        }

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:items];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];
}

- (void) getAllPendingUploadMessageIDs: (CDVInvokedUrlCommand *) command{

    [self.commandDelegate runInBackground:^{

        NSMutableArray *uniqueArrayOfMessageIDs = [[NSMutableArray alloc] init];
        NSArray *keychainItems = keychain.allItems;

        for( NSDictionary *item in keychainItems){

            NSString *key = item[@"key"];
            NSString *value = item[@"value"];

            if([key containsString:@"En_STATUS_"] && ![value isEqualToString:@"4"]){
                NSString *messageID = [key stringByReplacingOccurrencesOfString:@"En_STATUS_" withString:@""];
                [uniqueArrayOfMessageIDs addObject:messageID];
            }

        }

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:uniqueArrayOfMessageIDs];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];

}

- (void) getAllUnsuccessfulDeletionsFromKeychain: (CDVInvokedUrlCommand *) command{

    [self.commandDelegate runInBackground:^{

        NSMutableArray *arrayOfUnsuccessfulDeletions = [[NSMutableArray alloc] init];
        NSArray *keys = keychain.allKeys;

        for( NSString *key in keys){

            NSString *messageID;

            if([key containsString:@"En_STATUS_"]){
                messageID = [key stringByReplacingOccurrencesOfString:@"En_STATUS_" withString:@""];
                NSString *dataKey = [[NSString alloc] initWithFormat:@"En_DATA_%@",messageID];
                if (![keys containsObject:dataKey]){
                    [arrayOfUnsuccessfulDeletions addObject:messageID];
                }
            }
            else if([key containsString:@"En_DATA_"]){
                messageID = [key stringByReplacingOccurrencesOfString:@"En_DATA_" withString:@""];
                NSString *statusKey = [[NSString alloc] initWithFormat:@"En_STATUS_%@",messageID];
                if (![keys containsObject:statusKey]){
                    [arrayOfUnsuccessfulDeletions addObject:messageID];
                }
            }
        }

        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:arrayOfUnsuccessfulDeletions];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

    }];

}

- (void) changeStatusForMessageID: (CDVInvokedUrlCommand *) command{

    [self.commandDelegate runInBackground:^{

        CDVPluginResult* pluginResult = nil;
        bool hasRequiredArguments = [self hasRequiredNumberOfArguments:command.arguments
                                             numberOfRequiredArguments:NUMBER_OF_REQUIRED_PARAMETERS_IN_CHANGE_STATUS];
        if(hasRequiredArguments){

            NSString *messageID = [command.arguments objectAtIndex:0];
            NSString *statusType = [command.arguments objectAtIndex:1];

            NSString *key = [[NSString alloc] initWithFormat:@"En_STATUS_%@",messageID];

            NSError *error;
            [keychain setString:statusType forKey:key error:&error];
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
            }else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            }
        }
        else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                             messageAsString:@"incorrect number of arguments for saveValueInKeychain"];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];

}

- (void) sendEnrollmentToAzureFunction: (CDVInvokedUrlCommand *) command{

    [self.commandDelegate runInBackground:^{
        
        CDVPluginResult* pluginResult = nil;
        bool hasRequiredArguments = [self hasRequiredNumberOfArguments:command.arguments
                                             numberOfRequiredArguments:NUMBER_OF_REQUIRED_PARAMETERS_IN_SEND_TO_AZURE_FUNCTION];
        if(hasRequiredArguments){
            
            NSString *messageID = [command.arguments objectAtIndex:0];
            NSString *data = [command.arguments objectAtIndex:1];
            NSString *environment = [command.arguments objectAtIndex:2];

            unsigned long size = (unsigned long)[[data dataUsingEncoding:NSUTF8StringEncoding] length] / 1000;
            [Logger.sharedInstance logInfo:@"Size of data sent is : %lu kB", size, nil];
            
            EnrollmentEntry *enrollmentEntry = (EnrollmentEntry *) [ACPTModel new];
            [enrollmentEntry setStatus:@""];
            [enrollmentEntry setUniqueMessageId:messageID];
            [enrollmentEntry setData:data];
            [enrollmentEntry setEnvironment:environment];
            
            
            [AzureFunctionHelper.sharedInstance sendDataToAzureFunction:enrollmentEntry WithOnSuccess:^(NSString *responseData) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } AndFailure:^(NSError *error) {
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }];

        }
        else{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                             messageAsString:@"incorrect number of arguments for saveValueInKeychain"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }

    }];

}

@end

