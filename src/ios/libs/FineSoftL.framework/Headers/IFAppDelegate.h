//
//  IFAppDelegate.h
//  IFWidget
//
//  Created by richie on 14-3-26.
//  Copyright (c) 2014年 FineSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface IFAppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
