//
//  ViewController.m
//  MailBox
//
//  Created by Victor Zhu on 7/2/15.
//  Copyright (c) 2015 Interactivelabs. All rights reserved.
//

#import "ViewController.h"
#import "NSString+MB.h"
#import "UIViewController+MB.h"
#import "MailService.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextField *field, *emailField, *passwordField, *serverField, *portField;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.automaticallyAdjustsScrollViewInsets = NO;
	[self addTapGestureObserver];
	
	self.serverField.text = @"imap.gmail.com";
	self.portField.text = @"993";
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self registerKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self unregisterKeyboard];
}

- (UIScrollView *)activeScrollView
{
	return self.scrollView;
}

- (UIView *)activeField
{
	return self.field;
}

- (void)addTapGestureObserver
{
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing:)];
	[self.view addGestureRecognizer:tap];
}

- (void)endEditing:(UITapGestureRecognizer *)tap
{
	[self.view endEditing:YES];
}

- (IBAction)save:(id)sender
{
	if (!self.emailField.text.length || !self.passwordField.text.length || !self.serverField.text.length || !self.portField.text.length) {
		[SVProgressHUD showErrorWithStatus:@"Please fill the following fields"];
		return;
	}
	
	if (![self.emailField.text validateEmail]) {
		[SVProgressHUD showErrorWithStatus:@"Your email isn't valid"];
		return;
	}
	
	[MailService.service configureWithHostname:self.serverField.text port:[self.portField.text intValue] username:self.emailField.text password:self.passwordField.text];
	[self performSegueWithIdentifier:@"save" sender:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	self.field = textField;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.emailField) {
		[self.passwordField becomeFirstResponder];
		return NO;
	}
	if (textField == self.passwordField) {
		[self.serverField becomeFirstResponder];
		return NO;
	}
	if (textField == self.serverField) {
		[self.portField becomeFirstResponder];
		return NO;
	}
	if (textField == self.portField) {
		[self.portField resignFirstResponder];
	}
	return YES;
}

@end
