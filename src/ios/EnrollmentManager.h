#import <Cordova/CDVPlugin.h>
#import "UICKeyChainStore.h"
#import "AzureFunctionHelper.h"

@interface EnrollmentManager : CDVPlugin{
    UICKeyChainStore *keychain ;
};

- (void) setupKeychainWithServiceName:(CDVInvokedUrlCommand *) command;
- (void) saveValueInKeychain: (CDVInvokedUrlCommand *) command;
- (void) getValueFromKeychain: (CDVInvokedUrlCommand *) command;
- (void) getAllKeysFromKeychain: (CDVInvokedUrlCommand *) command;
- (void) getAllItemsFromKeychain: (CDVInvokedUrlCommand *) command;
- (void) removeValueFromKeychain: (CDVInvokedUrlCommand *) command;
- (void) getAllPendingUploadMessageIDs: (CDVInvokedUrlCommand *) command;
- (void) getAllUnsuccessfulDeletionsFromKeychain: (CDVInvokedUrlCommand *) command;
- (void) changeStatusForMessageID: (CDVInvokedUrlCommand *) command;

- (void) sendEnrollmentToAzureFunction: (CDVInvokedUrlCommand *) command;


@end
