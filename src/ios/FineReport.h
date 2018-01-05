/********* FineReport.h Cordova Plugin Header *******/

#import <Cordova/CDV.h>
@interface FineReport : CDVPlugin
- (void)showFromUrl:(CDVInvokedUrlCommand*)command;
- (void)logInto:(CDVInvokedUrlCommand*)command;
- (void)test:(CDVInvokedUrlCommand*)command;
@end