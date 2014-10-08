//
//  ChatService.m
//  Chat
//
//  Created by Jaime Yesid Leon Parada on 10/3/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "ChatService.h"
#import "User.h"
#import "LocalStorage.h"

typedef void(^CompletionBlock)(QBResponse *response, QBUUser *user);


@interface ChatService () 

@property (copy) CompletionBlock loginCompletionBlock;
@property (copy) QBUUser *currentUser;
@property (retain) NSTimer *presenceTimer;

@property (nonatomic) QBResponse *responseSession;

@end



@implementation ChatService


+ (instancetype)instance{
    static id instance_ = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    
    return instance_;
}

- (id)init{
    self = [super init];
    if(self){
        [QBChat instance].delegate = self;
    }
    return self;
}

#pragma mark - Methods
- (void)loginWithUser:(User *)user
      completionBlock:(void(^)(QBResponse *response, QBUUser *user))completionBlock
           errorBlock:(void(^)(QBResponse *responseError))errorBlock
{
    
    self.loginCompletionBlock = completionBlock;
    
    QBSessionParameters *extendedAuthRequest = [[QBSessionParameters alloc] init];
    extendedAuthRequest.userLogin = user.name;
    extendedAuthRequest.userPassword = user.password;
    
    [QBRequest createSessionWithExtendedParameters:extendedAuthRequest
                                      successBlock:^(QBResponse *response, QBASession *session) {
                                          // Save current user
                                          QBUUser *currentUser = [QBUUser user];
                                          currentUser.ID = session.userID;
                                          currentUser.login = user.name;
                                          currentUser.password = user.password;
                                          
                                          self.currentUser = currentUser;
                                          self.responseSession = response;
                                          
                                          [[QBChat instance] loginWithUser:currentUser];
                                          
                                      } errorBlock:^(QBResponse *response) {
                                          errorBlock(response);
                                      }];
}

- (void)signupWithUser:(User *)userSignup
       completionBlock:(void(^)(QBResponse *response, QBUUser *user))completionBlock
            errorBlock:(void(^)(QBResponse *responseError))errorBlock
{
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        QBUUser *newUser = [QBUUser user];
        newUser.login = userSignup.name;
        newUser.password = userSignup.password;
        newUser.fullName = userSignup.name;
        
        [QBRequest signUp:newUser successBlock:^(QBResponse *response, QBUUser *user) {
            // Success, do something
            //completionBlock(response,user);
            
            [self loginWithUser:userSignup completionBlock:completionBlock errorBlock:errorBlock];
            
        } errorBlock:^(QBResponse *response) {
            // error handling
            errorBlock(response);
        }];
    } errorBlock:^(QBResponse *response) {
        errorBlock(response);
    }];
}

- (void)findUsersWithCurrentPage:(NSInteger*)page perPage:(NSInteger*)perPage successBlock:(void(^)(QBResponse *response, QBGeneralResponsePage *page, NSArray *users))successBlock errorBlock:(void(^)(QBResponse *response))errorBlock
{
    if ([QBSession currentSession].isTokenValid){
        QBGeneralResponsePage *responsePage = [QBGeneralResponsePage responsePageWithCurrentPage:(NSUInteger)page perPage:(NSUInteger)perPage];
        [QBRequest usersForPage:responsePage
                   successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users)
         {
             successBlock(response, page, users);
         } errorBlock:^(QBResponse *response) {
             errorBlock(response);
         }];
    }else {
        errorBlock(nil);
        NSLog(@"No existe una session creada o el token no es valido");
    }
}

- (void)logoutChat:(void(^)(QBResponse *response))completionBlock errorBlock:(void(^)(QBResponse *response))errorBlock
{
    [QBRequest logOutWithSuccessBlock:^(QBResponse *response) {
        completionBlock(response);
        [self.presenceTimer invalidate];
        self.presenceTimer = nil;
    } errorBlock:^(QBResponse *response) {
        errorBlock(response);
    }];
}

#pragma mark QBChatDelegate

- (void)chatDidLogin{
    // Start sending presences
    [self.presenceTimer invalidate];
    self.presenceTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                          target:[QBChat instance] selector:@selector(sendPresence)
                                                        userInfo:nil repeats:YES];
    
    [QBChat dialogsWithExtendedRequest:nil
                              delegate:self];
    
    
    
    
    if(self.loginCompletionBlock != nil){
        self.loginCompletionBlock(self.responseSession,self.currentUser);
        self.loginCompletionBlock = nil;
    }
}

- (void)chatDidNotLogin
{
    if(self.loginCompletionBlock != nil){
        self.loginCompletionBlock(self.responseSession,self.currentUser);
        self.loginCompletionBlock = nil;
    }
}

#pragma mark QBChatDelegate

- (NSArray*)dialogs
{
    [QBChat dialogsWithExtendedRequest:nil
                              delegate:self];
    return [LocalStorage shared].dialogs;
}

- (NSArray*)users
{
    [QBChat dialogsWithExtendedRequest:nil
                              delegate:self];
    return [LocalStorage shared].users;
}


- (void)completedWithResult:(Result *)result
{
    if (result.success && [result isKindOfClass:[QBDialogsPagedResult class]]) {
        QBDialogsPagedResult *pagedResult = (QBDialogsPagedResult *)result;
        
        NSArray *dialogs = pagedResult.dialogs;
        
        
        
        
        [LocalStorage shared].dialogs = [dialogs mutableCopy];
        
        QBGeneralResponsePage *pagedRequest = [QBGeneralResponsePage responsePageWithCurrentPage:0
                                                                                         perPage:100];
        //
        NSSet *dialogsUsersIDs = pagedResult.dialogsUsersIDs;
        
        [QBRequest usersWithIDs:[dialogsUsersIDs allObjects] page:pagedRequest successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
            
            [LocalStorage shared].users = [users mutableCopy];
            [[LocalStorage shared] setUsers:[users mutableCopy]];
            
        } errorBlock:nil];
        
    }
}


@end
