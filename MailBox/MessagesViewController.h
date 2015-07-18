//
//  MessagesViewController.h
//  MailBox
//
//  Created by Victor Zhu on 7/3/15.
//  Copyright (c) 2015 Interactivelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MailCore/MailCore.h>

@interface MessagesViewController : UITableViewController

@property (nonatomic, strong) MCOIMAPFolder *folder;

@end
