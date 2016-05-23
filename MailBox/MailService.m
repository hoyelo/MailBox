//
//  MailService.m
//  MailBox
//
//  Created by Victor Zhu on 7/3/15.
//  Copyright (c) 2015 Interactivelabs. All rights reserved.
//

#import "MailService.h"

@interface MailService ()

@property (nonatomic, strong) MCOIMAPSession *session;

@end

@implementation MailService

+ (instancetype)service
{
	static MailService *service;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		service = [MailService new];
	});
	return service;
}

- (void)configureWithHostname:(NSString *)hostname port:(unsigned int)port username:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completionBlock
{
	if (self.session) {
		MCOIMAPOperation *op = [self.session disconnectOperation];
		[op start:^(NSError *error) {
			NSLog(@"%@", error.localizedDescription);
		}];
	}
	MCOIMAPSession *session = [MCOIMAPSession new];
	session.connectionType = MCOConnectionTypeTLS;
	session.authType = MCOAuthTypeXOAuth2Outlook;
	session.hostname = hostname;
	session.port = port;
	session.username = username;
	session.password = password;
	[session.checkAccountOperation start:^(NSError *error) {
		if (completionBlock) {
			completionBlock(error);
		}
	}];
	self.session = session;
}

- (NSString *)folderName:(MCOIMAPFolder *)folder
{
	if ([folder.path hasPrefix:@"&"] && [folder.path hasSuffix:@"-"]) {
		return [self.session.defaultNamespace componentsFromPath:folder.path].firstObject;
	}
	return folder.path;
}

- (void)fetchAllFolders:(void (^)(NSError *error, NSArray *folders))completionBlock
{
	MCOIMAPFetchFoldersOperation *foldersOp = [self.session fetchAllFoldersOperation];
	[foldersOp start:completionBlock];
}

- (void)fetchMessages:(MCOIMAPFolder *)folder requestKind:(MCOIMAPMessagesRequestKind)kind uids:(MCOIndexSet *)uids completion:(void (^)(NSError *error, NSArray *messages, MCOIndexSet *vanishedMessages))completionBlock
{
	MCOIMAPFetchMessagesOperation *messagesOp = [self.session fetchMessagesOperationWithFolder:[self folderName:folder] requestKind:kind uids:uids];
	[messagesOp start:completionBlock];
}

@end
