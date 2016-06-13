//
//  RootViewController.m
//  BaoFooShortcutSDK
//
//  Created by 路国良 on 16/6/13.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "RootViewController.h"
#import "BaoFooShortcutSDKViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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

- (IBAction)switchButton:(id)sender {
}

- (IBAction)submitButton:(id)sender {
    BaoFooShortcutSDKViewController*sdkView = [[BaoFooShortcutSDKViewController alloc] init];
    sdkView.pay_cert_id = _userIDField.text;
    [self.navigationController presentViewController:sdkView animated:YES completion:^{
    }];
}
@end
