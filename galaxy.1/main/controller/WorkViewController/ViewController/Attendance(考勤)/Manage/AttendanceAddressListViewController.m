//
//  AttendanceAddressListViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AttendanceAddressListViewController.h"
#import "AttendanceAddLocationViewController.h"

@interface AttendanceAddressListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *muarr_Show;
@property (nonatomic, strong) UITableView *tbv;
@property (nonatomic, strong) UIButton *btn_content;
@property (nonatomic, strong) DoneBtnView *dockView;//下部按钮底层视图

@end

@implementation AttendanceAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"考勤地点", nil) backButton:YES];
    
    _tbv = [[UITableView alloc]init];
    _tbv.backgroundColor = Color_White_Same_20;
    _tbv.tableFooterView = [[UIView alloc] init];
    _tbv.delegate = self;
    _tbv.dataSource = self;
    [self.view addSubview:_tbv];
    [_tbv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(@50);
    }];
    self.dockView=[[DoneBtnView alloc]initWithFrame:CGRectMake(0, Main_Screen_Height-NavigationbarHeight-50, Main_Screen_Width, 50)];
    self.dockView.userInteractionEnabled=YES;
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [self.dockView updateLookFormViewWithTitleArray:@[Custing(@"确定", nil)]];
    __weak typeof(self) weakSelf = self;
    self.dockView.btnClickBlock = ^(NSInteger index) {
        if (index==0){
            [weakSelf Btn_ok];
        }
    };
    
    [_dockView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    
    _muarr_Show = [NSMutableArray array];
    if (_muarr_return.count>0) {
        _muarr_Show = [NSMutableArray arrayWithArray:_muarr_return];
    }else{
        _muarr_return = [NSMutableArray array];
    }
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:nil title:nil titleColor:Color_Blue_Important_20 titleIndex:0 imageName:@"Attendance_Add" target:self action:@selector(rightbtn)];

    
    
    if (_muarr_Show.count==0) {
        NSString *str_title = Custing(@"暂无考勤地点，", nil);
        NSString *str_content = Custing(@"请添加", nil);
        NSMutableAttributedString *attriString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",str_title,str_content]];
        [attriString1 addAttribute:NSForegroundColorAttributeName value:Color_Blue_Important_20 range:NSMakeRange(str_title.length, str_content.length)];
        [attriString1 addAttribute:NSForegroundColorAttributeName value:Color_GrayDark_Same_20 range:NSMakeRange(0, str_title.length)];
        _btn_content = [GPUtils createButton:CGRectMake(0, 30, Main_Screen_Width, 30) action:nil delegate:nil title:@"" font:Font_Important_15_20 titleColor:Color_GrayDark_Same_20];
        [_btn_content setAttributedTitle:attriString1 forState:UIControlStateNormal];
        [self.view addSubview:_btn_content];
        
        __weak typeof(self) weakSelf = self;
        [_btn_content bk_whenTapped:^{
            AttendanceAddLocationViewController *add = [[AttendanceAddLocationViewController alloc]init];
            [add setBlock:^(AMapPOI *Poi) {
                [weakSelf.muarr_Show addObject:Poi];
                [weakSelf.tbv reloadData];
                [weakSelf.dockView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@50);
                }];
                [weakSelf.btn_content removeFromSuperview];
                weakSelf.btn_content.hidden = YES;
            }];
            [self.navigationController pushViewController:add animated:YES];
        }];
    }else{
        [_btn_content removeFromSuperview];
        [_dockView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
    }
}

-(void)rightbtn{
    __weak typeof(self) weakSelf = self;
    AttendanceAddLocationViewController *add = [[AttendanceAddLocationViewController alloc]init];
    [add setBlock:^(AMapPOI *Poi) {
        [weakSelf.muarr_Show addObject:Poi];
        [weakSelf.tbv reloadData];
        [weakSelf.dockView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
        [weakSelf.btn_content removeFromSuperview];
        weakSelf.btn_content.hidden = YES;
    }];
    [self.navigationController pushViewController:add animated:YES];
}

-(void)Btn_ok{
    if (_muarr_return.count == 0) {
        [[GPAlertView sharedAlertView]showAlertText:self WithText:Custing(@"必须选择一条数据", nil) duration:1.5];
    }else{
        if (_block) {
            _block(_muarr_return);
        }
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
    AMapPOI *ama = _muarr_Show[indexPath.row];
    _TypeLabel.text = ama.name;
    [cell addSubview:_TypeLabel];
    
    if (_muarr_return.count>0) {
        for (AMapPOI *aMAP in _muarr_return) {
            if ([ama.name isEqualToString:aMAP.name]) {
                selectImageView.highlighted = YES;
            }
        }
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
    __block BOOL isremove = NO;
    AMapAOI *ama = _muarr_Show[indexPath.row];
    if (_muarr_return.count>0) {
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        [_muarr_return enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AMapAOI *aMAP = obj;
            if ([ama.name isEqualToString:aMAP.name]) {
                [indexSet addIndex:idx];
                isremove = YES;
            }
        }];
        [_muarr_return removeObjectsAtIndexes:indexSet];
    }
    if (!isremove) {
        [_muarr_return addObject:ama];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isremove = NO;
    AMapPOI *ama = _muarr_Show[indexPath.row];
    if (_muarr_return.count>0) {
        for (AMapPOI *aMAP in _muarr_return) {
            if ([ama.name isEqualToString:aMAP.name]) {
                [_muarr_return removeObject:aMAP];
                isremove = YES;
            }
        }
    }
    
    if (!isremove) {
        [_muarr_return addObject:ama];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
