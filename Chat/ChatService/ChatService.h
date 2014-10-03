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
      completionBlock:(void(^)(QBResponse *response))completionBlock;
- (void)signupWithUser:(User *)user
       completionBlock:(void(^)(QBResponse *response, QBUUser *user))completionBlock
            errorBlock:(void(^)(QBResponse *responseError))errorBlock;

- (NSArray*)dialogs;
- (NSArray*)users;

@end
