//
//  UIViewController+MB.h
//  MailBox
//
//  Created by Victor Zhu on 7/3/15.
//  Copyright (c) 2015 Interactivelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MB)

- (void)unregisterKeyboard;
- (void)registerKeyboard;
- (UIView *)activeField;
- (void)setActiveField:(UIView *)field;
- (UIScrollView *)activeScrollView;
- (void)dismiss;

@end
