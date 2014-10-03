//
//  LocalStorage.m
//  Chat
//
//  Created by Jaime Yesid Leon Parada on 10/3/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "LocalStorage.h"

@implementation LocalStorage

+ (instancetype)shared
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)setUsers:(NSArray *)users
{
    _users = users;
    
    NSMutableDictionary *__usersAsDictionary = [NSMutableDictionary dictionary];
    for(QBUUser *user in users){
        [__usersAsDictionary setObject:user forKey:@(user.ID)];
    }
    
    _usersAsDictionary = [__usersAsDictionary copy];
}


@end
