//
//  LoginViewController.m
//  Chat
//
//  Created by Jaime Yesid Leon Parada on 10/7/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "ChatService.h"
#import "UIViewController+ShowAlert.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Login";
    self.userName.text = @"jaime";
    self.userPassword.text = @"jaimeyesid";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions
- (IBAction)login:(id)sender
{
    User *user = [User new];
    user.name = self.userName.text;
    user.password = self.userPassword.text;
    
    [[ChatService instance] loginWithUser:user
                          completionBlock:^(QBResponse *response, QBUUser *user) {
                              [self showAlertViewWithMessage:[NSString stringWithFormat:@"Se ha logeado correctamente: %@",user.login]
                                                       title:@"Login"];
                              
                              [self.userName setEnabled:NO];
                              [self.userPassword setEnabled:NO];
                              [self.btnLogin setEnabled:NO];
                              //[self.btnLogout setEnabled:YES];
                              self.btnLogout.enabled = YES;
                              
                          } errorBlock:^(QBResponse *responseError) {
                              [self showAlertViewWithMessage:@"Existe un error al hacer login"
                                                       title:@"Signup"];
                          }];
}

- (IBAction)signup:(id)sender
{
    if ([self.userPassword.text length] < 8)
    {
        [self showAlertViewWithMessage:@"La constraseña debe tener al menos 8 letras" title:@"SignUp"];
    }else{
        User *user = [User new];
        user.name = self.userName.text;
        user.password = self.userPassword.text;
        
        [[ChatService instance]signupWithUser:user
                              completionBlock:^(QBResponse *response, QBUUser *user) {
                                  NSLog(@"Ha creado al usuario: %@", user);
                                  
                                  [self showAlertViewWithMessage:[NSString stringWithFormat:@"Se ha creado correctamente: %@",user.login]
                                                           title:@"SignUp"];
                                  
                              } errorBlock:^(QBResponse *responseError) {
                                  [self showAlertViewWithMessage:@"Existe un error al crear al usuario" title:@"Signup"];
                              }];
    }

}

- (IBAction)logout:(id)sender
{
    [[ChatService instance] logoutChat:^(QBResponse *response) {
        [self showAlertViewWithMessage:@"Ha hecho logout" title:@"Logout"];
        [self.userName setEnabled:YES];
        [self.userPassword setEnabled:YES];
        [self.btnLogin setEnabled:YES];
        [self.btnLogout setEnabled:NO];
    } errorBlock:^(QBResponse *response) {
        NSLog(@"No ha podido hacer logout: %@", response);
    }];
}


@end
