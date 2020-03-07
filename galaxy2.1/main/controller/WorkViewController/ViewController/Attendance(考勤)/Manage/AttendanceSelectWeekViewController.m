//
//  AttendanceSelectWeekViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AttendanceSelectWeekViewController.h"

@interface AttendanceSelectWeekViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *muarr_Show;

@end

@implementation AttendanceSelectWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"打卡日期", nil) backButton:YES];
    if (_muarr_return == nil || _muarr_return.count==0) {
        _muarr_return = [NSMutableArray array];
        [_muarr_return addObject:@"1"];
        [_muarr_return addObject:@"2"];
        [_muarr_return addObject:@"3"];
        [_muarr_return addObject:@"4"];
        [_muarr_return addObject:@"5"];
    }
    _muarr_Show = [NSMutableArray array];
    [_muarr_Show addObject:Custing(@"周一", nil)];
    [_muarr_Show addObject:Custing(@"周二", nil)];
    [_muarr_Show addObject:Custing(@"周三", nil)];
    [_muarr_Show addObject:Custing(@"周四", nil)];
    [_muarr_Show addObject:Custing(@"周五", nil)];
    [_muarr_Show addObject:Custing(@"周六", nil)];
    [_muarr_Show addObject:Custing(@"周日", nil)];
    
    UITableView *tbv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
    tbv.backgroundColor = Color_White_Same_20;
    tbv.tableFooterView = [[UIView alloc] init];
    tbv.delegate = self;
    tbv.dataSource = self;
    [self.view addSubview:tbv];
    
    UIButton *rigbtn = [UIButton new];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:rigbtn title:Custing(@"确定", nil) titleColor:Color_Blue_Important_20 titleIndex:0 imageName:nil target:self action:@selector(rightbtn)];
}

-(void)rightbtn{
    if (_muarr_return.count == 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"必须选择一条数据", nil) duration:1.5];
    }else{
        NSString *rt_Str = [NSString setDateListReturnString:_muarr_return];
        _block(_muarr_return,rt_Str);
        [self returnBack];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = Color_form_TextFieldBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *selectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,18, 18)];
    selectImageView.center=CGPointMake(25, 22.5);
    selectImageView.image=[UIImage imageNamed:@"MyApprove_UnSelect"];
    selectImageView.highlightedImage=[UIImage imageNamed:@"MyApprove_Select"];
    [cell addSubview:selectImageView];
    
    UILabel *_TypeLabel = [GPUtils createLable:CGRectMake(50, 0, Main_Screen_Width-65, 45) text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
    _TypeLabel.text = _muarr_Show[indexPath.row];
    [cell addSubview:_TypeLabel];
    
    if ([_muarr_return containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]]) {
        selectImageView.highlighted = YES;
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _muarr_Show.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_muarr_return containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]]) {
        [_muarr_return removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]];
    }else{
        if (indexPath.row+1>_muarr_return.count) {
            [_muarr_return addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]];
        }else{
            for (int i = 0; i<_muarr_return.count; i++) {
                NSInteger a = [_muarr_return[i] integerValue];
                if (a>indexPath.row+1) {
                    [_muarr_return insertObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1] atIndex:i];
                    break;
                }
            }
        }
    }
    [tableView reloadData];
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([_muarr_return containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]]) {
//        [_muarr_return removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//    }else{
//        for (int i = 0; i<_muarr_return.count; i++) {
//            NSInteger a = [_muarr_return[i] integerValue];
//            if (a>indexPath.row) {
//                [_muarr_return insertObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1] atIndex:i];
//                break;
//            }
//        }
//    }
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
