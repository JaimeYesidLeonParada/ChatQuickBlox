//
//  LocalStorage.h
//  Chat
//
//  Created by Jaime Yesid Leon Parada on 10/3/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalStorage : NSObject

@property (nonatomic, strong) QBUUser *currentUser;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *dialogs;
@property (nonatomic, readonly) NSDictionary *usersAsDictionary;

+ (instancetype)shared;

@end
