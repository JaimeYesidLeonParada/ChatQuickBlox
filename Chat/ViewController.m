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
#import "ChatViewController.h"

#define demoUserLogin @"igorquickblox"
#define demoUserPassword @"igorquickblox"



@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)  NSMutableArray *usersChat;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usersChat = [NSMutableArray array];
}

#pragma mark Actions

- (IBAction)loginChat:(id)sender
{
    User *user = [User new];
    user.name = self.userName.text;
    user.password = self.userPassword.text;
    
    [[ChatService instance] loginWithUser:user
                          completionBlock:^(QBResponse *response, QBUUser *user) {
                              [self showAlertViewWithMessage:[NSString stringWithFormat:@"Se ha logeado correctamente: %@",user.login]
                                                       title:@"Login"];
                          } errorBlock:^(QBResponse *responseError) {
                              [self showAlertViewWithMessage:@"Existe un error al hacer login"
                                                       title:@"Signup"];
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
                                  
                                  [self showAlertViewWithMessage:[NSString stringWithFormat:@"Se ha creado correctamente: %@",user.login]
                                                           title:@"SignUp"];
                                  
                              } errorBlock:^(QBResponse *responseError) {
                                  [self showAlertViewWithMessage:@"Existe un error al crear al usuario" title:@"Signup"];
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


- (IBAction)showDialogAndUsers:(id)sender
{
    NSLog(@"Dialogos: %@", [ChatService instance].dialogs);
    //NSLog(@"Users: %@", [ChatService instance].users);
    
    [[ChatService instance] findUsersWithCurrentPage:(NSInteger*)1 perPage:(NSInteger*)100 successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users)
    {
        self.usersChat = [NSMutableArray arrayWithArray:users];
        [self.tableView reloadData];
    } errorBlock:^(QBResponse *response) {
        [self showAlertViewWithMessage:@"Error al consultar usuarios" title:@"Usuarios"];
    }];
}

#pragma mark TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.usersChat count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    QBUUser *user = (QBUUser *)self.usersChat[indexPath.row];
    cell.textLabel.text = user.login;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChatViewController *chatViewCtlr = [self.storyboard instantiateViewControllerWithIdentifier:@"MainStoryboard"];
    [chatViewCtlr setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self.navigationController pushViewController:chatViewCtlr animated:YES];
    
    NSDate *sessionExpiratioDate = [QBSession currentSession].sessionExpirationDate;
    NSDate *currentDate = [NSDate date];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:sessionExpiratioDate];
    if(interval > 0){
        // recreate session here
        NSLog(@"La sesion ha expirado");
    }else{
        NSLog(@"La session esta activa");
    }
   
}




@end
