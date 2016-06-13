//
//  BaoFooShortcutSDKController.h
//  BaoFooShortcutSDK
//
//  Created by 路国良 on 16/6/13.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaofooSdkDelegate <NSObject>
-(void)callBack:(NSString*)params;
@end

@interface BaoFooShortcutSDKController : UIViewController

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

@property(nonatomic,copy) NSString*session;
@property(nonatomic,copy) NSString*pay_cert_id;
@property(nonatomic,weak)id<BaofooSdkDelegate>delegate;
@end
