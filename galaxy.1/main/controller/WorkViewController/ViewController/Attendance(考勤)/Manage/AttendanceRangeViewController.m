//
//  AttendanceRangeViewController.m
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AttendanceRangeViewController.h"

@interface AttendanceRangeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *muarr_Show;
@end

@implementation AttendanceRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:Custing(@"打卡范围", nil) backButton:YES];
    _muarr_Show = [NSMutableArray array];
    for (int i = 0; i<10; i++) {
        [_muarr_Show addObject:[NSString stringWithFormat:@"%d",(i+1)*100]];
    }
    UITableView *tbv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
    tbv.tableFooterView = [[UIView alloc] init];
    tbv.dataSource = self;
    tbv.delegate = self;
    tbv.backgroundColor = Color_White_Same_20;
    [self.view addSubview:tbv];
    
//    UIButton *rigbtn = [UIButton new];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RootCustomNavButtonWithWithButton:rigbtn title:Custing(@"确定", nil) titleColor:Color_Blue_Important_20 titleIndex:0 imageName:@"" target:self action:@selector(rightbtn)];
}

//-(void)rightbtn{
//    
//}


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
    _TypeLabel.text = [NSString stringWithFormat:@"%@%@",_muarr_Show[indexPath.row],Custing(@"米", nil)];
    [cell addSubview:_TypeLabel];
    
    if ([_str_return isEqualToString:_muarr_Show[indexPath.row]]) {
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
    if (_block) {
        _block(_muarr_Show[indexPath.row]);
    }
    [self returnBack];
}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
