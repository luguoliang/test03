//
//  BaoFooShortcutSDKViewController.m
//  BaoFooShortcutSDK
//
//  Created by 路国良 on 16/6/13.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "BaoFooShortcutSDKViewController.h"

@interface BaoFooShortcutSDKViewController ()
{
    UIWebView*_web;
}

@end

@implementation BaoFooShortcutSDKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_web];
    [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tgw.baofoo.com/quickpay/sdk/confirmorder?pay_cert_id=%@",@"MjAxNjA2MTMxNjQ1MzY1ODV8OTM="]]]];
    // Do any additional setup after loading the view.
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
