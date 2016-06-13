//
//  BFAuthorizeViewController.h
//  BFAuthorizeSDK
//
//  Created by 路国良 on 16/5/9.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaofooSdkDelegate <NSObject>
-(void)callBack:(NSString*)params;
@end

@interface BaoFooAuthorizeViewController : UIViewController
/*
 0:测试环境
 1:准生产环境
 2:正式环境
 */
typedef NS_ENUM(NSInteger,operationalState){
    operational_test = 0,
    operational_true
};
@property(nonatomic,assign)operationalState operState;
@property(nonatomic,assign,getter =isAuthed)BOOL authed;
@property(nonatomic,copy)NSString*PAY_TOKEN;//用户id
@property(nonatomic,copy)NSString*merchant_id;//商户号
@property(nonatomic,copy)NSString*terminal_id;//终端号
@property(nonatomic,copy)NSString*page_url;//页面通知地址，可为空
@property(nonatomic,copy)NSString*model;//指定页面显示模式，可为空
@property(nonatomic,copy)NSString*service_url;//服务端通知地址
@property(nonatomic,weak)id<BaofooSdkDelegate>delegate;
@end
