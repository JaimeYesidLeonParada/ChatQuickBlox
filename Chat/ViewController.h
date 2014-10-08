//
//  ViewController.h
//  Chat
//
//  Created by Jaime Yesid Leon Parada on 10/1/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)loginChat:(id)sender;
- (IBAction)signUpChat:(id)sender;
- (IBAction)showDialogAndUsers:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

