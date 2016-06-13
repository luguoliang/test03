//
//  MianViewController.m
//  BFAuthorizeSDK
//
//  Created by 路国良 on 16/5/9.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import "MianViewController.h"
#import <BaoFooAuthorize/BaoFooAuthorize.h>
@interface MianViewController ()<BaofooSdkDelegate,UITextFieldDelegate>

@end

@implementation MianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bftextfield.text = @"20140715";
    _page_url.text = @"http://www.p2p.com/page";
    _merchant_id.text = @"100000675";
    _terminal_id.text = @"100000701";
    _model.text = @"app";
    _service_url.text = @"http://www.p2p.com/service";
    _bftextfield.delegate = self;
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

- (IBAction)AuthorizeButton:(id)sender {
    BaoFooAuthorizeViewController*bfauthor = [[BaoFooAuthorizeViewController alloc] init];
    bfauthor.operState = operational_test;
    bfauthor.delegate = self;
//    if (self.myswitch.on) { 
//        bfauthor.operState = operational_true;
//    }
    switch (self.segment.selectedSegmentIndex) {
        case 0:
        {
            bfauthor.operState = operational_test;
        }
            break;
        default:
        {
             bfauthor.operState = operational_true;
        }
            break;
    }

    bfauthor.page_url = _page_url.text;
    bfauthor.merchant_id  = _merchant_id.text;
    bfauthor.terminal_id = _terminal_id.text;
    bfauthor.model = _model.text;
    bfauthor.service_url = _service_url.text;
    bfauthor.PAY_TOKEN = _bftextfield.text;
    NSLog(@"_bftextfield.text = %@",_bftextfield.text);

    [self presentViewController:bfauthor animated:YES completion:^{
    }];
}
- (IBAction)switchcL:(UISwitch*)sender {
    if (sender.on) {
        self.title = @"宝付授权协议demo-生产";
    }
    else{
        self.title = @"宝付授权协议demo-测试";
    }
}
-(void)callBack:(NSString*)params{
    UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"" message:params delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)segment:(id)sender {
}
@end
