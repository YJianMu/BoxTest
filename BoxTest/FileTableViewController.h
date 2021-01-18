//
//  FileTableViewController.h
//  BoxTest
//
//  Created by YJianMu on 2021/1/16.
//  Copyright © 2021 YJianMu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileTableViewController : UITableViewController

- (instancetype)initWithFolderId:(NSString *)folderId folderName:(NSString *)folderName;

@end

NS_ASSUME_NONNULL_END
