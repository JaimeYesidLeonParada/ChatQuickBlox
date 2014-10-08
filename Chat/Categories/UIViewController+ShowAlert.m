//
//  UIViewController+ShowAlert.m
//  Chat
//
//  Created by Jaime Yesid Leon Parada on 10/7/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "UIViewController+ShowAlert.h"

@implementation UIViewController (ShowAlert)


- (void)showAlertViewWithMessage:(NSString*)message title:(NSString*)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}
@end
