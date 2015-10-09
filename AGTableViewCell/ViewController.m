//
//  ViewController.m
//  AGTableViewCell
//
//  Created by Agenric on 15/9/22.
//  Copyright (c) 2015年 Agenric. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<AGTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *totalData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.mainTableView setTableFooterView:view];
    self.totalData = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6"]];
}

#pragma mark -
#pragma mark UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"disSelectRowAtIndexPath");
}

#pragma mark -
#pragma mark UITableView Datasources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.totalData.count;
}

- (AGTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"myIdentifier";
    AGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AGTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier inTableView:self.mainTableView withAG_Style:AGTableViewCellStyleRightItems];
        cell.delegate = self;
    }
    
    [cell.textLabel setText:self.totalData[indexPath.row]];
    return cell;
}


#pragma mark - AGTableViewCellDelegate
- (AGTableViewCellStyle)AGTableView:(UITableView *)tableView editStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AGTableViewCellStyleRightItems;
}

- (NSArray *)AGTableView:(UITableView *)tableView leftEditActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @[];
}

- (NSArray *)AGTableView:(UITableView *)tableView rightEditActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    AGTableViewRowAction *action1 = [[AGTableViewRowAction alloc] initWithTitle:@"更多" backgroundColor:[UIColor lightGrayColor] index:0];
//    AGTableViewRowAction *action2 = [[AGTableViewRowAction alloc] initWithTitle:@"旗标" backgroundColor:[UIColor orangeColor] index:1];
//    AGTableViewRowAction *action3 = [[AGTableViewRowAction alloc] initWithTitle:@"删除" backgroundColor:[UIColor redColor] index:2];
//    return @[action1,action2,action3];

    return [AGTableViewRowAction actionsWithTitles:@[@"更多",@"旗标",@"删除"] backgroundColors:@[[UIColor lightGrayColor],[UIColor redColor],[UIColor orangeColor]]];
    
}


- (void)AGTableView:(UITableView *)tableView didSelectActionIndex:(NSInteger)index forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (index) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            [self.totalData removeObjectAtIndex:indexPath.row];
            [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            break;
        default:
            break;
    }
}
@end
