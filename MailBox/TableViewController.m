//
//  TableViewController.m
//  MailBox
//
//  Created by Victor Zhu on 7/3/15.
//  Copyright (c) 2015 Interactivelabs. All rights reserved.
//

#import "TableViewController.h"
#import "MailService.h"
#import "MessagesViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface TableViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation TableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
	__weak __typeof(self)weakSelf = self;
	[MailService.service fetchAllFolders:^(NSError *error, NSArray *folders) {
		if (error) {
			[SVProgressHUD showErrorWithStatus:error.localizedDescription];
		} else {
			__strong __typeof(weakSelf)strongSelf = weakSelf;
			strongSelf.items = folders;
			[strongSelf.tableView reloadData];
			[SVProgressHUD dismiss];
		}
	}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"message"]) {
		MessagesViewController *controller = (MessagesViewController *)segue.destinationViewController;
		controller.folder = sender;
	}
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	MCOIMAPFolder *folder = self.items[indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FolderCell" forIndexPath:indexPath];
	cell.textLabel.text = [MailService.service folderName:folder];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self performSegueWithIdentifier:@"message" sender:self.items[indexPath.row]];
}

@end
