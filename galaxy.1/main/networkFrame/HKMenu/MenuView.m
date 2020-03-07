//
//  MenuView.m
//  PopMenuTableView
//
//  Created by hfk on 16/8/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "MenuView.h"
#import "MenuModel.h"
#import "MenuTableViewCell.h"

@interface MenuView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,assign) CGRect rect;
@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,strong) UIViewController * target;

@end

@implementation MenuView

- (void)setDataArray:(NSArray *)dataArray{
    
    NSMutableArray *tempMutableArr = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        MenuModel *model = [MenuModel MenuModelWithDict:dict];
        [tempMutableArr addObject:model];
    }
    _dataArray = tempMutableArr;
}

- (void)setUpUIWithFrame:(CGRect)frame{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed:@"pop_black_backGround"];
    [self addSubview:imageView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, frame.size.height -10)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.target.view.bounds.size.width, self.target.view.bounds.size.height)];
    backView.backgroundColor = Color_Unsel_TitleColor;
    backView.alpha = 0.0;
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [backView addGestureRecognizer:tap];
    self.backView = backView;
    
    
    [self.target.view addSubview:backView];
    [self addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuModel *model = self.dataArray[indexPath.row];
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.menuModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MenuModel *model = self.dataArray[indexPath.row];
    if (self.itemsClickBlock) {
        self.itemsClickBlock(model.itemName,indexPath.row);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)showMenuWithAnimation:(BOOL)isShow{
    [UIView animateWithDuration:0.25 animations:^{
        if (isShow) {
            self.alpha = 1;
            self.backView.alpha = 0.1;
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }else{
            self.alpha = 0;
            self.backView.alpha = 0;
            self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
    } completion:^(BOOL finished) {
        if (!isShow) {
            [self.backView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)tap:(UITapGestureRecognizer *)sender{
    
    [self showMenuWithAnimation:NO];
    if (self.backViewTapBlock) {
        self.backViewTapBlock();
    }
}


+ (MenuView *)createMenuWithFrame:(CGRect)frame target:(UIViewController *)target dataArray:(NSArray *)dataArray itemsClickBlock:(void (^)(NSString *, NSInteger))itemsClickBlock backViewTap:(void (^)())backViewTapBlock{
    
    MenuView *menuView = [[MenuView alloc] initWithFrame:frame];
    menuView.rect = frame;
    menuView.target = target;
    menuView.dataArray = dataArray;
    menuView.itemsClickBlock = itemsClickBlock;
    menuView.backViewTapBlock = backViewTapBlock;
    [menuView setUpUIWithFrame:frame];
    menuView.layer.anchorPoint = CGPointMake(1, 0);
    menuView.layer.position = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    menuView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [target.view addSubview:menuView];
    return menuView;
}

@end











