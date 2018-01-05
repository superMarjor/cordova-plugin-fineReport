//
//  IFIntegrationUtils.h
//  IFWidget
//
//  Created by 魏阳露 on 15/6/23.
//  Copyright (c) 2015年 FineSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

/**
 *  开放给客户的集成工具类
 */
@interface IFIntegrationUtils : NSObject

/**
 *  登录服务器
 *
 *  @param serverName 服务器名称
 *  @param serverUrl  服务器地址
 *  @param username   用户名
 *  @param password   密码
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)logInto:(NSString *) serverName serverUrl:(NSString *)serverUrl withUsername:(NSString *)username andPassword:(NSString *)password success:(void (^)(NSDictionary *userInfo))success failure:(void (^)(NSString *message))failure;

+ (void)loadReportTree:(void (^)(NSMutableArray *reportsArray))success failure:(void (^)(NSString *message))failure;

/**
 *  得到已登录服务器的目录树节点
 *  @param success 成功回调，reportsArray为IFEntryNode数组
 *  @param failure 失败回调
 *  @param isObj 返回值是否是IFEntryNode对象，todo——后续版本会删除
 */
+ (void)loadReportTree:(void (^)(NSMutableArray *reportsArray))success failure:(void (^)(NSString *message))failure isObj:(BOOL) isObj;

/**
 *  所有收藏的报表
 *
 *  @param success 成功回调，favorites为IFEntryNode数组
 *  @param faliure 失败回调
 */
+ (void)favorites:(void (^)(NSMutableArray *favorites))success failure:(void (^)(NSString *message))failure;

/**
 *  登出
 */
+ (void) logOut;

/**
 *  创建需要的数据库表，主要用于使用离线功能
 */
+ (void) createTable;

/**
 *  修改密码
 *  @param oldPassword 旧密码
 *  @param newPassword 新密码
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void) changePassword:(NSString *) oldPassword newPassword:(NSString *) newPassword success:(void (^)()) success failure:(void (^)(NSString *message)) failure;

//当前登录的用户是否可以更改密码（非管理员并且是同步数据集/http认证/ldap认证时不支持更改密码）
+ (BOOL) canChangePassword;

/**
 *  获取用于推送的设备码
 */
+ (NSString *) deviceToken;

/**
 *  设置用于推送的设备码
 *  @param dt 设备码
 */
+ (void) setDeviceToken:(NSString *) dt;

//读取报表/目录的缩略图
+ (void) readEntryImage:(NSString *) entryId coverId:(NSString *) coverId sucess:(void (^)(UIImage *image)) success;

@end
