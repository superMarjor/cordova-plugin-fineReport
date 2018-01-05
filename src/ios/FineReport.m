/********* FineReport.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

#import <FineSoftL/IFEntryViewController.h>
#import <FineSoftL/IFIntegrationUtils.h>


@interface FineReport : CDVPlugin {
  
}

- (void)showFromUrl:(CDVInvokedUrlCommand*)command;
- (void)logInto:(CDVInvokedUrlCommand*)command;
- (void)test:(CDVInvokedUrlCommand*)command;

@end

@implementation FineReport

- (void)showFromUrl:(CDVInvokedUrlCommand*)command
{
   CDVPluginResult* pluginResult = nil;
       NSDictionary *_dictParams = [command.arguments objectAtIndex:0];

       NSString *url = [_dictParams objectForKey:@"url"];
       NSString *title = [_dictParams objectForKey:@"title"];

       if(url && url.length > 0){
           //根据?拆分url
           NSArray *urlItems = [url componentsSeparatedByString:@"?"];

           NSString *serverUrl = [urlItems objectAtIndex:0]; //服务器地址

           NSString *temppath = [urlItems objectAtIndex:1];

           //拆分临时路径, 生成报表路径和参数字典
           NSRange rangePathBegin = [temppath rangeOfString:@"="];

           //定义报表路径
           NSString *path = [temppath substringFromIndex:rangePathBegin.location+1];

           //获取&符号的位置范围
           NSRange rangePathEnd = [path rangeOfString:@"&"];

           //定义报表参数字符串
           NSString *param = @"";

           NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];


           if(rangePathEnd.length > 0){

               //获取参数字符串
               param = [path substringFromIndex:rangePathEnd.location+1];

               //获取报表路径
               path = [path substringToIndex:rangePathEnd.location];

               //循环参数列表，构建参数字典
               NSArray *paramItems = [param componentsSeparatedByString:@"&"];

               long int count = [paramItems count];
               for(int i=0; i<count; i++){
                   NSArray *paramObjeItems = [[paramItems objectAtIndex:1] componentsSeparatedByString:@"="];
                   [dic setObject:[paramObjeItems objectAtIndex:1] forKey:[paramObjeItems objectAtIndex:0]];
               }
           }

           //异步进程，打开帆软报表
           dispatch_async(dispatch_get_main_queue(), ^{
               IFEntryViewController *entryVC = [[IFEntryViewController alloc] initWithPath:path serverUrl:serverUrl viewType:IFEntryViewTypePage parameters:dic];

               entryVC.title = title;

               UIViewController *currentVC = [self getCurrentVC];


               UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:entryVC];

               entryVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];

               [currentVC presentModalViewController:navi animated:NO];
           });
       }

       [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)logInto:(CDVInvokedUrlCommand*)command
{
        CDVPluginResult* pluginResult = nil;
        NSDictionary *_dictParams = [command.arguments objectAtIndex:0];

        NSString *_loginIp = [_dictParams objectForKey:@"_loginIp"];
        NSString *_loginName = [_dictParams objectForKey:@"_loginName"];
        NSString *_loginPassword = [_dictParams objectForKey:@"_loginPassword"];
//        NSString *_loginFailMessage = [_dictParams objectForKey:@"_loginFailMessage"];

        //自己的代码实现
        [IFIntegrationUtils logInto:@"决策平台" serverUrl:_loginIp withUsername:_loginName andPassword:_loginPassword success:^(NSDictionary *dic){
            
        } failure:^(NSString *message) {
            
        }];


        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)test:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}

-(void)back:(id)sender
{
    
    UIViewController *currentVC =(UIViewController*)[self getCurrentVC];
    
    [currentVC dismissViewControllerAnimated:YES completion:nil];
}

@end
