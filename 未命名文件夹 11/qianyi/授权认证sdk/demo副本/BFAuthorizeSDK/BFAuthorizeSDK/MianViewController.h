//
//  MianViewController.h
//  BFAuthorizeSDK
//
//  Created by 路国良 on 16/5/9.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MianViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *bftextfield;
@property (weak, nonatomic) IBOutlet UITextField *page_url;
@property (weak, nonatomic) IBOutlet UITextField *merchant_id;
@property (weak, nonatomic) IBOutlet UITextField *terminal_id;
@property (weak, nonatomic) IBOutlet UITextField *model;

@property (weak, nonatomic) IBOutlet UITextField *service_url;
- (IBAction)AuthorizeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *myswitch;
- (IBAction)switchcL:(UISwitch*)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

- (IBAction)segment:(id)sender;


@end
