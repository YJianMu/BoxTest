//
//  FileTableViewController.m
//  BoxTest
//
//  Created by YJianMu on 2021/1/16.
//  Copyright © 2021 YJianMu. All rights reserved.
//

#import "FileTableViewController.h"
#import <BoxTest-Swift.h>

@interface FileTableViewController ()

@property (nonatomic, strong) NSString * folderId;
@property (nonatomic, strong) NSString * folderName;

@property (nonatomic, strong) NSMutableArray<BoxFileModel *> * dataArr;

@end

@implementation FileTableViewController

- (instancetype)initWithFolderId:(NSString *)folderId folderName:(NSString *)folderName{
    if (self = [super init]) {
        _folderId = folderId;
        _folderName = folderName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.folderName;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出登陆" style:(UIBarButtonItemStylePlain) target:self action:@selector(logout)];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"kCell"];
    
    [[BoxTools sharedInstance] getBoxFolderItemsWithFolderId:self.folderId resultsBlock:^(NSArray <BoxFileModel *> * _Nonnull arr, NSError * _Nullable error) {
        
        if (arr.count) {
            
            self.dataArr = arr.mutableCopy;
            [self.tableView reloadData];
            
        }else{
        
        }
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"kCell"];
    
    BoxFileModel * item = self.dataArr[indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   %lld B",item.modifyDate, item.size];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataArr[indexPath.row].file) {
        
        NSString * path = [NSString stringWithFormat:@"/Users/yanjianmin/Desktop/%@", self.dataArr[indexPath.row].name];
        //下载
        [[BoxTools sharedInstance] downloadFileWithFileId:self.dataArr[indexPath.row].id localPath:[NSURL fileURLWithPath:path] resultsBlock:^(BOOL success, NSError * _Nullable error) {
            
            NSLog(@"successful = %d     error = %@", success, error);
            
        }];
        
    }else{
        
        FileTableViewController * vc = [[FileTableViewController alloc] initWithFolderId:self.dataArr[indexPath.row].id folderName:self.dataArr[indexPath.row].name];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)logout{
    
    [[BoxTools sharedInstance] logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


@end
