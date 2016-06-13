//
//  LGL_HttpRequest.h
//  ManagedFuns2.0Demo
//
//  Created by 路国良 on 16/3/23.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol lgl_httpRequestDelegate <NSObject>

-(void)sucessfull:(NSString*)result;
-(void)fail:(NSString*)errorStr;

@end

@interface LGL_HttpRequest : NSObject
@property(nonatomic,weak)id<lgl_httpRequestDelegate>delegate;
-(void)postRequest:(NSString*)postString urlString:(NSURL*)url;
@end
