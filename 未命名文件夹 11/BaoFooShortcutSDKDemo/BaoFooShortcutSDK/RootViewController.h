//
//  RootViewController.h
//  BaoFooShortcutSDK
//
//  Created by 路国良 on 16/6/13.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
- (IBAction)switchButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userIDField;

@property (weak, nonatomic) IBOutlet UITextField *moneyField;

- (IBAction)submitButton:(id)sender;


@end
