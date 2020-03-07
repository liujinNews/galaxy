//
//  ExmineApproveView.m
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/25.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "ExmineApproveView.h"
#import "ExmineApproveModel.h"
#import "ExmineApproveCollectionViewCell.h"

@implementation ExmineApproveView

-(ExmineApproveView *)initWithBaseView:(UIView *)baseView Withmodel:(MyProcurementModel *)model WithInfodict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        if (baseView) {
            [baseView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@137);
            }];
        }
        UICollectionView *co;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(60, 100);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(layout.minimumLineSpacing, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        co = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 27, Main_Screen_Width-30, 110) collectionViewLayout:layout];
        self.frame = CGRectMake(0, 0, Main_Screen_Width, 137);
        NSString *title=@"";
        if (dict[@"title"]) {
            title=[NSString stringWithFormat:@"%@",dict[@"title"]];
        }
        if (model) {
            title=[NSString stringWithIdOnNO:model.Description];
        }
        self.arr_Result=dict[@"array"];
        self.arr_Main=[NSMutableArray array];
        for (buildCellInfo *firstinfo in self.arr_Result) {
            ExmineApproveModel *newModel = [[ExmineApproveModel alloc]init];
            newModel.str_HandlerUserName = [NSString stringWithIdOnNO:firstinfo.requestor];
            newModel.str_HandlerUserId = [NSString stringWithFormat:@"%ld",(long)firstinfo.requestorUserId];
            newModel.str_HandlerUserNamePhoto = firstinfo.photoGraph;
            newModel.str_HandlerUserNamegender = [NSString isEqualToNull:[NSString stringWithFormat:@"%d",firstinfo.gender]]?firstinfo.gender:0;
            [self.arr_Main addObject:newModel];
        }
        [self.arr_Main addObject:[[ExmineApproveModel alloc]init]];
        [self addSubview:[self createHeadView:title]];
        co.delegate = self;
        co.dataSource = self;
        co.showsHorizontalScrollIndicator = NO;
        [co registerClass:[ExmineApproveCollectionViewCell class] forCellWithReuseIdentifier:@"ExmineApproveCollectionViewCell"];
        co.backgroundColor = Color_form_TextFieldBackgroundColor;
        [self addSubview:co];
    }
    return self;
}


-(UIView *)createHeadView:(NSString *)title{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    
    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 4, 27)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [view addSubview:ImgView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 18)];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+8+90, 13.5);
    titleLabel.font=Font_Important_15_20 ;
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=Color_Unsel_TitleColor;
    [view addSubview:titleLabel];
    titleLabel.text = [NSString stringWithIdOnNO:title];
    view.backgroundColor=Color_White_Same_20;
    
    UIView *lineUp=[[UIView alloc]initWithFrame:CGRectMake(0,0, Main_Screen_Width,0.5)];
    lineUp.backgroundColor=Color_GrayLight_Same_20;
    [view addSubview:lineUp];
    
    UIView *downUp=[[UIView alloc]initWithFrame:CGRectMake(0,26.5, Main_Screen_Width,0.5)];
    downUp.backgroundColor=Color_GrayLight_Same_20;
    [view addSubview:downUp];
    return view;
}



#pragma mark - CollectionView Delegate & DataSource
#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arr_Main.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExmineApproveModel *model = self.arr_Main[indexPath.row];
    ExmineApproveCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExmineApproveCollectionViewCell" forIndexPath:indexPath];
    [cell bk_eachSubview:^(UIView *subview) {
        [subview removeFromSuperview];
    }];
    [cell initWithModel:model block:^{
        [self.arr_Main removeObjectAtIndex:indexPath.row];
        [collectionView reloadData];
    }];
    return cell;
}

#pragma mark - 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i<self.arr_Main.count ; i++) {
        ExmineApproveModel *ex = self.arr_Main[i];
        if ([NSString isEqualToNull:ex.str_HandlerUserId]) {
            NSDictionary *dic = @{@"requestorUserId":ex.str_HandlerUserId};
            [array addObject:dic];
        }
    }
    contactsVController *contactVC=[[contactsVController alloc]init];
    contactVC.status = @"12";
    contactVC.isCleanSelf = YES;
    contactVC.arrClickPeople = array;
    contactVC.menutype=3;
    contactVC.Radio = @"2";
    contactVC.itemType = 99;
    __weak typeof(self) weakSelf = self;
    [contactVC setBlock:^(NSMutableArray *array) {
        [weakSelf.arr_Main removeAllObjects];
        [weakSelf.arr_Result removeAllObjects];
        for (buildCellInfo *firstinfo in array) {
            if ([NSString isEqualToNull:firstinfo.photoGraph]) {
                NSDictionary * dic = (NSDictionary *)[NSString transformToObj:firstinfo.photoGraph];
                NSString *str =[NSString stringWithFormat:@"%@",[dic objectForKey:@"filepath"]];
                firstinfo.photoGraph = str;
            }
            [weakSelf.arr_Result addObject:firstinfo];
            ExmineApproveModel *newModel = [[ExmineApproveModel alloc]init];
            newModel.str_HandlerUserName = firstinfo.requestor;
            newModel.str_HandlerUserId = [NSString stringWithFormat:@"%ld",(long)firstinfo.requestorUserId];
            newModel.str_HandlerUserNamePhoto = firstinfo.photoGraph;
            newModel.str_HandlerUserNamegender = firstinfo.gender;
            [weakSelf.arr_Main addObject:newModel];
        }
        [weakSelf.arr_Main addObject:[[ExmineApproveModel alloc]init]];
        [collectionView reloadData];
    }];
    [[[AppDelegate appDelegate]navigationViewController] pushViewController:contactVC animated:YES];
}

@end
