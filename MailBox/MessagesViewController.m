//
//  MessagesViewController.m
//  MailBox
//
//  Created by Victor Zhu on 7/3/15.
//  Copyright (c) 2015 Interactivelabs. All rights reserved.
//

#import "MessagesViewController.h"
#import "MailService.h"
#import "TableViewCell.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MessagesViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation MessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
	__weak __typeof(self)weakSelf = self;
	[MailService.service fetchMessages:self.folder requestKind:MCOIMAPMessagesRequestKindHeaders uids:[MCOIndexSet indexSetWithRange:MCORangeMake(1,UINT64_MAX)] completion:^(NSError *error, NSArray *messages, MCOIndexSet *vanishedMessages) {
		if (error) {
			[SVProgressHUD showErrorWithStatus:error.localizedDescription];
		} else {
			__strong __typeof(weakSelf)strongSelf = weakSelf;
			strongSelf.items = messages;
			[strongSelf.tableView reloadData];
			[SVProgressHUD dismiss];
		}
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MCOIMAPMessage *message = self.items[indexPath.row];
	TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
	cell.titleLabel.text = message.header.subject;
	return cell;
}

@end
