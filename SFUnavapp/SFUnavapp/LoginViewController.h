//
//  LoginViewController.h
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-03-10.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *errorDisplay;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UIWebView *web;
@property (strong, nonatomic) IBOutlet UISwitch *keychainSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *goSwitch;

- (IBAction)loginButtonPress:(id)sender;

@end
