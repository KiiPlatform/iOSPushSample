//
//  KiiLoginViewController.m
//  iOSPushSample
//
//  Copyright (c) 2015年 Kii Corporation. All rights reserved.
//

#import "KiiLoginViewController.h"
#import "KiiAppSingleton.h"
#import <KiiSDK/Kii.h>

@interface KiiLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;
@property (weak, nonatomic) IBOutlet UILabel *messageText;

@end

@implementation KiiLoginViewController

- (IBAction)signUpClicked:(id)sender {
    [_messageText setText:@""];
    [_loginIndicator startAnimating];
    NSString* uname = [_userNameText text];
    NSString* pass = [_passwordText text];
    KiiUser* user = nil;
    if ([uname rangeOfString:@"^\\+?[0-9]{7,20}$" options:NSRegularExpressionSearch].location != NSNotFound) {
        user = [KiiUser userWithPhoneNumber:uname andPassword:pass];
    } else if ([uname rangeOfString:@"@"].location != NSNotFound) {
        user = [KiiUser userWithEmailAddress:uname andPhoneNumber:nil andPassword:pass];
    } else {
        user = [KiiUser userWithUsername:uname andPassword:pass];
    }
    [user performRegistrationWithBlock:^(KiiUser *user, NSError *error) {
        [_loginIndicator stopAnimating];
        if (error != nil) {
            NSString *errorMessage = error.userInfo[@"description"];
            if (errorMessage == nil)
                errorMessage = error.description;
            NSString *message = [NSString stringWithFormat:@"Error: %@", errorMessage];
            [_messageText setText:message];
            return;
        }
        [[KiiAppSingleton sharedInstance]setCurrentUser:[KiiUser currentUser]];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)loginClicked:(id)sender {
    [_messageText setText:@""];
    [_loginIndicator startAnimating];
    NSString* uname = [_userNameText text];
    NSString* pass = [_passwordText text];
    [KiiUser authenticate:uname withPassword:pass
                 andBlock:^(KiiUser *user, NSError *error) {
                     [_loginIndicator stopAnimating];
                     if (error != nil) {
                         NSString *errorMessage = error.userInfo[@"description"];
                         if (errorMessage == nil)
                             errorMessage = error.description;
                         NSString *message = [NSString stringWithFormat:@"Error: %@", errorMessage];
                         [_messageText setText:message];
                         return;
                     }
                     [[KiiAppSingleton sharedInstance]setCurrentUser:[KiiUser currentUser]];
                     [self.navigationController popViewControllerAnimated:YES];
                 }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_messageText setText:@""];
    _loginIndicator.hidesWhenStopped = YES;
    [_loginIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
