//
//  ViewController.m
//  Chat
//
//  Created by Jaime Yesid Leon Parada on 10/1/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "ChatService.h"

#define demoUserLogin @"igorquickblox"
#define demoUserPassword @"igorquickblox"

@interface ViewController () <QBChatDelegate,QBActionStatusDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark Actions

- (IBAction)loginChat:(id)sender
{
    User *user = [User new];
    user.name = @"jaime";
    user.password = @"jaimeyesid";
    
    [[ChatService instance] loginWithUser:user completionBlock:^(QBResponse *response) {
        NSLog(@"response: %@", response);
        
        
        
        
    }];
}


- (IBAction)signUpChat:(id)sender
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
                              } errorBlock:^(QBResponse *responseError) {
                                  
                              }];
    }
}


- (void)showAlertViewWithMessage:(NSString *)message title:(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}


@end
