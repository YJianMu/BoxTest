//
//  ViewController.m
//  BoxTest
//
//  Created by YJianMu on 2021/1/16.
//  Copyright © 2021 YJianMu. All rights reserved.
//

#import "ViewController.h"
#import <BoxTest-Swift.h>
#import "FileTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)login:(id)sender {
    
    [[BoxTools sharedInstance] boxOAuthClientWithResultsBlock:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            FileTableViewController * vc = [[FileTableViewController alloc] initWithFolderId:@"0" folderName:@"Box"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}


@end
