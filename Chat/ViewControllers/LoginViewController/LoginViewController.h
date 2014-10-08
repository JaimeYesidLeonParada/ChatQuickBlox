//
//  LoginViewController.h
//  Chat
//
//  Created by Jaime Yesid Leon Parada on 10/7/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

- (IBAction)login:(id)sender;
- (IBAction)signup:(id)sender;
- (IBAction)logout:(id)sender;

@end
