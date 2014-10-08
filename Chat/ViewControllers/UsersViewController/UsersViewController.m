//
//  UsersViewController.m
//  Chat
//
//  Created by Jaime Yesid Leon Parada on 10/7/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "UsersViewController.h"
#import "ChatService.h"
#import "UIViewController+ShowAlert.h"

@interface UsersViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)  NSMutableArray *usersChat;

@end

@implementation UsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.usersChat = [NSMutableArray array];
    [self showDataUsers];
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

#pragma mark - Dataç
- (void)showDataUsers
{
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
    /*
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
    */
}

@end
