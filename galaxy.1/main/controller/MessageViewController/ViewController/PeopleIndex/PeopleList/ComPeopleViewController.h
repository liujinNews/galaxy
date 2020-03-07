//
//  ComPeopleViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/13.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@protocol ComPeopleViewControllerDelegate <NSObject>
@optional
- (void)ComPeopleViewController_BtnClick:(NSDictionary *)dic;
@end

@interface ComPeopleViewController : RootViewController

@property (weak, nonatomic) IBOutlet UISearchBar *sea_Search;

@property (weak, nonatomic) IBOutlet UIScrollView *scr_deparScroll;

@property (weak, nonatomic) IBOutlet UITableView *tab_PeopleTable;

@property (weak, nonatomic) IBOutlet UIButton *btn_rootBtn;

@property (nonatomic, copy)NSString *nowGroup;//现在的部门ID
@property (nonatomic, copy)NSString *nowGroupname;//现在的部门Name
@property (nonatomic, strong)NSMutableArray *arrGroup;
@property (nonatomic, strong) NSString *parentId;//父级ID
@property (nonatomic, copy) void (^ComPeopleViewControllerBlock)(NSDictionary *dict);
@property (nonatomic, weak) id<ComPeopleViewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger type;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end
