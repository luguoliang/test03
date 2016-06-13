//
//  EGISSecurity.h
//  EgisSecurity
//
//  Created by zhiwei.ma on 14-2-18.
//  Copyright (c) 2014年 Payegis Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

enum
{
    EGISSecurityErrorCode_Network = 100,         //网络错误
    EGISSecurityErrorCode_Common = 101,          //普通错误
};
typedef NSInteger EGISSecurityErrorCode;

extern NSString *const EGISSecurityContextAppId;
extern NSString *const EGISSecurityContextAppKey;
extern NSString *const EGISSecurityContextHostURL;
extern NSString *const EGISSecurityContextSession;

typedef void (^EGISSecurityInitCompletionBlock)(NSError *error);
typedef void (^EGISSecurityUninitCompletionBlock)(NSError *error);

@interface EGISDID : NSObject

/**
 获取SDK版本号
 */
+ (NSString *)version;//获取SDK版本号

/**
 设置SDK上下文环境
 */
+ (void)setContext:(NSDictionary *)context;

/**
 SDK初始化
 @param context:SDK上下文，包括EGISSecurityContextHostURL，EGISSecurityContextLisenceKey，EGISSecurityContextPartnerCodeKey，EGISSecurityContextSDKTestMode
        completionBlock:初始化完成后的异步回调
                contenxt为nil时，不改变原有的值
*/
+ (void)init:(NSDictionary *)context completionBlock:(EGISSecurityInitCompletionBlock)completionBlock;

/**
 判断SDK是否已经初始化完成
*/
+ (BOOL)isInitFinished;

/**
 SDK去初始化
 不再需要使用SDK时调用
 */
+ (void)uninit:(EGISSecurityUninitCompletionBlock)completionBlock;

/**
 获取SDK上下文
 */
+ (NSDictionary *)context;

@end

extern NSString *const EGISSecurityNotificationInitCompletion;//对应的userInfo中有error时代表失败

extern NSString *const EGISSecurityContextLisenceKey;
extern NSString *const EGISSecurityContextPartnerCodeKey;
extern NSString *const EGISSecurityContextSDKTypeKey;
