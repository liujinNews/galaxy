//
//  ComPeopleEditViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/15.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface ComPeopleEditViewController : RootViewController

@property (weak, nonatomic) IBOutlet UISearchBar *sea_Search;

@property (weak, nonatomic) IBOutlet UIScrollView *scr_deparScroll;

@property (weak, nonatomic) IBOutlet UITableView *tab_PeopleTable;

@property (weak, nonatomic) IBOutlet UIButton *btn_rootBtn;

@property (weak, nonatomic) IBOutlet UIButton *btn_addPeople;

@property (weak, nonatomic) IBOutlet UIButton *btn_addDepar;

@property (weak, nonatomic) IBOutlet UIButton *btn_editDepar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lc_btn_addPeople_width;

@property (nonatomic, strong)NSString *nowGroup;

@property (nonatomic, copy)NSString *nowGroupname;//现在的部门Name

@property (nonatomic, strong)NSMutableArray *arrGroup;

@property (weak, nonatomic) IBOutlet UIImageView *view_scrLine;



@end
