//
//  PGSDeviceId.h
//  PGSDeviceId
//
//  Created by zhiwei.ma on 13-12-3.
//  Copyright (c) 2013年 payegis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EGISDeviceIdInfo;

typedef void (^EGISRequestDeviceIdCompletionBlock)(NSString *deviceId, NSError *error);
typedef void (^EGISQueryDeviceIdCompletionBlock)(EGISDeviceIdInfo *deviceIdInfo, NSError *error);


@interface EGISDevice : NSObject

+ (void)requestDeviceId:(EGISRequestDeviceIdCompletionBlock)completionBlock;
+ (void)cancelRequestDeviceId;

+ (void)queryDeviceId:(EGISQueryDeviceIdCompletionBlock)completionBlock;
+ (void)cancelQueryDeviceId;

+ (BOOL)updateDeviceId:(NSDictionary *)dict;

+ (void)destory;

@end

@interface EGISDeviceIdInfo : NSObject

//deviceID 是否合法
@property (nonatomic) BOOL isValid;
//deviceID 对应的是否是真机
@property (nonatomic) BOOL isRealDevice;
//设备是否是刷机状态
@property (nonatomic) BOOL isOriginal;

@end

extern NSString *const EGISNotifacationRequestDeviceIdCompletion;