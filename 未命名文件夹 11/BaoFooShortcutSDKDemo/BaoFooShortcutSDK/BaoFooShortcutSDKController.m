//
//  BaoFooShortcutSDKController.m
//  BaoFooShortcutSDK
//
//  Created by 路国良 on 16/6/13.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "BaoFooShortcutSDKController.h"
#import "EGISDevice.h"
#import "EGISDID.h"
#import "BFProgressHUD.h"
@interface BaoFooShortcutSDKController ()<UIWebViewDelegate,UIAlertViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    UIWebView*_web;
    NSURLRequest* originRequest;
    NSString*judje;
    NSArray* alertArray;
}

@end

@implementation BaoFooShortcutSDKController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView*ststusBarView = [[UIView alloc] init];
    [self.view addSubview:ststusBarView];
    ststusBarView.backgroundColor = [UIColor whiteColor];
#pragma mark
    ststusBarView.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray*stsConstraintsW  = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|-0-[view(20)]"
                                options:0
                                metrics:nil views:@{@"view":ststusBarView}
                                ];
    [self.view addConstraints:stsConstraintsW];
    
    NSArray*stsConstraintsH = [NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                               options:0
                               metrics:nil views:@{@"view":ststusBarView}
                               ];
    [self.view addConstraints:stsConstraintsH];
#pragma mark
    _web = [[UIWebView alloc] init];
    [self.view addSubview:_web];
    _web.scrollView.alwaysBounceVertical = NO;
    _web.delegate = self;
    _web.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray*webArrayH = [NSLayoutConstraint
                         constraintsWithVisualFormat:@"V:[view]-0-[web]-0-|"
                         options:0
                         metrics:nil views:@{@"web":_web,@"view":ststusBarView}
                         ];
    [self.view addConstraints:webArrayH];
    
    
    NSArray*webArrayW = [NSLayoutConstraint
                         constraintsWithVisualFormat:@"H:|-0-[web]-0-|"
                         options:0
                         metrics:nil views:@{@"web":_web}
                         ];
    [self.view addConstraints:webArrayW];
    
    switch (self.operState) {
        case 0:
        {
            [self loadHtml:@"http://paytest.baofoo.com/baofoo-custody/custody/inAccredit.do"];
        }
            break;
        case 1:
        {
            [self loadHtml:@"https://qas-pm.baofoo.com/custody/inAccredit.do"];
        }
            break;
            
        default:
        {
            [_delegate callBack:@"请传入正确的操作环境"];
            return;
        }
            break;
    }

    [self sdkinit];
    
    // Do any additional setup after loading the view.
}
-(void)loadHtml:(NSString*)urlString
{
    NSString*urlStr = [NSString stringWithFormat:@"<html><head><script type='text/javascript'>window.onload=function(){ document.getElementById('submitForm').submit(); }</script></head><body><form action='%@' method='post' id='submitForm'><input type='hidden' name ='merchant_id' value='%@' /><input type='hidden' name ='terminal_id' value='%@'/><input type='hidden' name ='page_url' value='%@'/><input type='hidden' name ='model' value='%@'/><input type='hidden' name ='user_id' value='%@'/><input type='hidden' name ='service_url' value='%@'/></form></body></html>",urlString,@"",@"",@"",@"",@"",@""];
    [_web loadHTMLString:urlStr baseURL:nil];
}

#pragma mark -  UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString*scheme = [[request URL] scheme];
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.isAuthed) {
            originRequest = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [_web stopLoading];
            return NO;
        }
    }
    NSString*urlString = [[request URL] absoluteString];
    if ([urlString length]<=17) {
        return YES;
    }
#pragma mark 去掉http://
    NSString *urlScheme = [urlString substringFromIndex:7];
    if ([[urlScheme lastPathComponent] isEqualToString:@"/"]) {
        urlScheme = [urlScheme substringToIndex:[urlScheme length] - 1];
    }
    if ([urlScheme rangeOfString:@"baofoosdk/saveData"].location != NSNotFound)
    {
        NSArray *splitFuncInfo = [urlScheme componentsSeparatedByString:@"/"];
        if ([splitFuncInfo lastObject]) {
            [self SaveWebDataToLocal:[[splitFuncInfo lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            [self SaveWebDataToLocal:@""];
        }
    }
    else if ([urlScheme rangeOfString:@"baofoosdk/readData"].location != NSNotFound)
    {
        judje = @"1";
        NSArray *splitFuncInfo = [urlScheme componentsSeparatedByString:@"/"];
        NSString*str = [self ReadData];
        
        if (str.length == 0) {
            str = @"";
        }
        NSString*calljs = [NSString stringWithFormat:@"__iOSNativeBridge.resultForCallback('%@','%@')",[splitFuncInfo objectAtIndex:2],str];
        [webView stringByEvaluatingJavaScriptFromString:calljs];
    }
    else if ([urlScheme rangeOfString:@"baofoosdk/payResult"].location != NSNotFound)
    {
        NSArray *splitFuncInfo = [urlScheme componentsSeparatedByString:@"/"];
        NSString *params = [splitFuncInfo lastObject];
        params = [params stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self returnOperatingResult:params];
    }
    else if ([urlScheme rangeOfString:@"baofoosdk/alert"].location != NSNotFound)
    {
        NSArray *splitFuncInfo = [urlScheme componentsSeparatedByString:@"/"];
        NSString *params = [[splitFuncInfo lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* str =  params;
        [self jsCallAlert:str];
    }
    
    else if ([urlScheme rangeOfString:@"baofoosdk/confirm"].location != NSNotFound)
    {
        NSArray *splitFuncInfo = [urlScheme componentsSeparatedByString:@"/"];
        NSString *params = [[splitFuncInfo lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        alertArray = [params componentsSeparatedByString:@","];
        [self jsCallconfirm:alertArray];
    }
    return YES;
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [BFProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [BFProgressHUD hideHUDForView:self.view animated:YES];
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('h1')[0].innerHTML";
    NSString *HTMLSource = [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    if ([HTMLSource rangeOfString:@"HTTP Status 404"].location != NSNotFound) {
        [self performSelector:@selector(stasMehod) withObject:nil afterDelay:3.0];
    }
}

-(void)stasMehod
{
    _web.hidden = YES;
    judje = @"1";
    [self performSelector:@selector(delayMehod) withObject:nil afterDelay:3];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    [BFProgressHUD hideHUDForView:self.view animated:YES];
    [self returnOperatingResult:@"-1,亲，网络连接有问题哦，请检查网路后再试"];
}

#pragma mark － NSURLConnectionDelegate <NSObject>
- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount]== 0) {
        _authed = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }
    else
    {
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
}
// Deprecated authentication delegates.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust];
    return YES;
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
#pragma mark － NSURLConnectionDataDelegate <NSURLConnectionDelegate>
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    return request;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.authed = YES;
    [_web loadRequest:originRequest];
    [connection cancel];
}
#pragma mark js调用本地方法
-(void)SaveWebDataToLocal:(NSString*)data
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:data forKey:@"baofooSdk"];
}

-(void)returnOperatingResult:(NSString*)result
{
    [_delegate callBack:result];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString*yescalljs = [NSString stringWithFormat:@"%@()",[alertArray objectAtIndex:1]];
    NSString*nocalljs = [NSString stringWithFormat:@"%@()",[alertArray objectAtIndex:2]];
    switch (buttonIndex) {
        case 0:
            [_web stringByEvaluatingJavaScriptFromString:nocalljs];
            break;
        case 1:
            [_web stringByEvaluatingJavaScriptFromString:yescalljs];
            break;
            
        default:
            break;
    }
}
#pragma mark - js调用本地alert confirm
-(void)jsCallAlert:(NSString*)aletr
{
    NSString*str = aletr;
    UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@""
                                                   message:str
                                                  delegate:nil
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - js调用本地alert confirm
-(void)jsCallconfirm:(NSArray*)aletr
{
    
    UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@""
                                                   message:[aletr objectAtIndex:0]
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)delayMehod
{
    [BFProgressHUD hideHUDForView:self.view animated:YES];
    [self returnOperatingResult:@"-1,亲，网络连接有问题哦，请检查网路后再试"];
}
#pragma mark - js读取本地方法
-(NSString*)ReadData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"baofooSdk"];
}

-(void)sdkinit{
    /*
     *EGISSecurityContextAppId :登录www.payegis.com 获取app ID
     *EGISSecurityContextAppKey:登录www.payegis.com 获取app key
     *EGISSecurityContextSession:从app服务器获取的session
     */
    self.session = @"session_from_app_server";
    NSDictionary *context=@{EGISSecurityContextAppId:@"******",
                            EGISSecurityContextAppKey:@"******************************",
                            EGISSecurityContextSession:self.session
                            };
    [EGISDID init:context completionBlock:^(NSError *error){
        if(error){
            [self showAlertView:[error localizedDescription]];
            NSLog(@"error description is %@", [error localizedDescription]);
        }else{
            [self showAlertView:[NSString stringWithFormat:@"初始化成功,APP服务器请根据\"%@\"来获取DeviceId！",self.session]];
            
        }
        
    }];
    
}

-(void)showAlertView:(NSString *)message{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"响应信息" message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
