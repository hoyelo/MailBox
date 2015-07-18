//
//  MailService.h
//  MailBox
//
//  Created by Victor Zhu on 7/3/15.
//  Copyright (c) 2015 Interactivelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>

@interface MailService : NSObject

+ (instancetype)service;
- (void)configureWithHostname:(NSString *)hostname port:(unsigned int)port username:(NSString *)username password:(NSString *)password;
- (NSString *)folderName:(MCOIMAPFolder *)folder;
- (void)fetchAllFolders:(void (^)(NSError *error, NSArray *folders))completionBlock;
- (void)fetchMessages:(MCOIMAPFolder *)folder requestKind:(MCOIMAPMessagesRequestKind)kind uids:(MCOIndexSet *)uids completion:(void (^)(NSError *error, NSArray *messages, MCOIndexSet *vanishedMessages))completionBlock;

@end
