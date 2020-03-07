//
//  SearchResultsTableViewController.m
//  UISearchControllerDemo
//
//  Created by Jason Hoffman on 1/13/15.
//  Copyright (c) 2015 JHM. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "ComPeopleModel.h"
#import "ComGroupTableViewCell.h"
#import "ComPeopleTableViewCell.h"
#import "PeopleInfoViewController.h"
#import "RootTabViewController.h"
#import "CommonPeopleTableViewCell.h"

@interface SearchResultsTableViewController ()

@end

@implementation SearchResultsTableViewController

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResults.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 69;
}
//返回两个组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *check = @"cell";
    ComPeopleModel *model = _searchResults[indexPath.row];
    
    if ([NSString isEqualToNull:model.groupId]) {
        ComGroupTableViewCell *Cell =[tableView dequeueReusableCellWithIdentifier:check];
        if (!Cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ComGroupTableViewCell" owner:self options:nil];
            Cell = [nib lastObject];
        }
        Cell.model = model;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消点击的灰色
        UIImageView *image;
        if (indexPath.section == 0 && _searchResults.count>0) {
            image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 68, Main_Screen_Width, 0.5)];
        }
        else
        {
            image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 68, Main_Screen_Width, 0.5)];
        }
        image.backgroundColor = Color_GrayLight_Same_20;
        [Cell addSubview:image];
        return Cell;
    }
    
    CommonPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:check];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommonPeopleTableViewCell" owner:self options:nil];
        cell = [nib lastObject];
    }
//    cell.dic = [NSObject getObjectData:model];
    cell.lab_name.text = model.requestor;
    cell.lab_department.text = model.requestorDept;
    if ([NSString isEqualToNull:model.photoGraph]) {
        NSDictionary * dics = (NSDictionary *)[NSString transformToObj:model.photoGraph];
        NSString * nicai = [NSString stringWithFormat:@"%@",[dics objectForKey:@"filepath"]];
        if ([NSString isEqualToNull:nicai]) {
            [cell.img_head sd_setImageWithURL:[NSURL URLWithString:nicai]];
        }
        else
        {
            cell.img_head.image = [UIImage imageNamed:@"Message_Man"];
        }
    }else
    {
        cell.img_head.image = [UIImage imageNamed:@"Message_Man"];
    }
    
    //添加一个线
    UIImageView *image;
    if (indexPath.row == _searchResults.count-1) {
        image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 68, Main_Screen_Width, 0.5)];
    }
    else
    {
        image = [[UIImageView alloc]initWithFrame:CGRectMake(60, 68, Main_Screen_Width, 0.5)];
    }
    image.backgroundColor = Color_GrayLight_Same_20;
    [cell addSubview:image];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消点击的灰色
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComPeopleModel *model = _searchResults[indexPath.row];
    
    if (![NSString isEqualToNull:model.groupName]) {
        PeopleInfoViewController *peopleinfo = [[PeopleInfoViewController alloc]init];
        peopleinfo.model = model;
        UIWindow *window=[[[UIApplication sharedApplication] delegate]window];
        RootTabViewController *root = (RootTabViewController *)window.rootViewController;
        UINavigationController *navi =  root.childViewControllers[0];
        [navi pushViewController:peopleinfo animated:YES];
    }
}


@end
