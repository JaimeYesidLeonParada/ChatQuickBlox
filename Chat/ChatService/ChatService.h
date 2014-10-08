//
//  ChatService.h
//  Chat
//
//  Created by Jaime Yesid Leon Parada on 10/3/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface ChatService : NSObject <QBChatDelegate,QBActionStatusDelegate>

+ (instancetype)instance;

- (void)loginWithUser:(User *)user
      completionBlock:(void(^)(QBResponse *response, QBUUser *user))completionBlock
           errorBlock:(void(^)(QBResponse *responseError))errorBlock;

- (void)signupWithUser:(User *)userSignup
       completionBlock:(void(^)(QBResponse *response, QBUUser *user))completionBlock
            errorBlock:(void(^)(QBResponse *responseError))errorBlock;

- (void)findUsersWithCurrentPage:(NSInteger*)page
                         perPage:(NSInteger*)perPage
                    successBlock:(void(^)(QBResponse *response, QBGeneralResponsePage *page, NSArray *users))successBlock
                      errorBlock:(void(^)(QBResponse *response))errorBlock;

- (void)logoutChat:(void(^)(QBResponse *response))completionBlock
        errorBlock:(void(^)(QBResponse *response))errorBlock;

- (NSArray*)dialogs;
- (NSArray*)users;

@end
