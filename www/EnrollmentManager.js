var exec = require('cordova/exec');

var PLUGIN_NAME = "EnrollmentManager";

var EnrollmentManager = {

    setupKeychainWithServiceName: function(serviceName,bundleIdentifier){
        exec(null, null, PLUGIN_NAME, 'setupKeychainWithServiceName', [serviceName,bundleIdentifier]);
    },

    saveValueInKeychain: function(success,failure,key,value){
        exec(success, failure, PLUGIN_NAME, 'saveValueInKeychain', [key,value]);
    },

    getValueFromKeychain: function(success,failure,key){
        exec(success, failure, PLUGIN_NAME, 'getValueFromKeychain', [key]);
    },

    getAllKeysFromKeychain: function(success){
        exec(success,null,PLUGIN_NAME,'getAllKeysFromKeychain',[]);
    },

    removeValueFromKeychain: function(success,failure,key){
        exec(success, failure, PLUGIN_NAME, 'removeValueFromKeychain', [key]);
    },

    getAllItemsFromKeychain: function(success){
        exec(success,null,PLUGIN_NAME,'getAllItemsFromKeychain',[]);
    },

    getAllPendingUploadMessageIDs: function(success){
        exec(success,null,PLUGIN_NAME,'getAllPendingUploadMessageIDs',[]);
    },

    getAllUnsuccessfulDeletionsFromKeychain: function(success){
        exec(success,null,PLUGIN_NAME,'getAllUnsuccessfulDeletionsFromKeychain',[]);
    },

    changeStatusForMessageID: function(success,key,changedStatus){
        exec(success,null,PLUGIN_NAME,'changeStatusForMessageID',[key,changedStatus]);
    },

    sendEnrollmentToAzureFunction: function(success,failure,messageID,data,environment){
        exec(success,failure,PLUGIN_NAME,'sendEnrollmentToAzureFunction',[messageID,data,environment]);
    }

};

module.exports = EnrollmentManager;