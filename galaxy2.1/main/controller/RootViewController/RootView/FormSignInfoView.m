//
//  FormSignInfoView.m
//  galaxy
//
//  Created by hfk on 2019/2/22.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "FormSignInfoView.h"
#import "FormSignInfoCell.h"

@interface FormSignInfoView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *showDict;

@end

@implementation FormSignInfoView

-(instancetype)init{
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = Color_form_TextFieldBackgroundColor;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.clipsToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [_tableView registerNib:[UINib nibWithNibName:@"FormSignInfoCell" bundle:nil] forCellReuseIdentifier:@"FormSignInfoCell"];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(0);
        }];
        [self makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tableView.bottom);
        }];
    }
    return self;
}

-(void)updateView:(NSDictionary *)dict{
    self.showDict = dict;
    NSInteger height = (27 + 80);
    [_tableView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    [self.tableView reloadData];
}
//MARK: UITableViewDataSource 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDict ? 1:0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *View_head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 27)];
    View_head.backgroundColor=Color_White_Same_20;

    UIImageView *ImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5, 4, 26)];
    ImgView.image=[UIImage imageNamed:@"Work_HeadBlue"];
    ImgView.backgroundColor=Color_Blue_Important_20;
    [View_head addSubview:ImgView];
    
    UILabel *titleLabel = [GPUtils createLable:CGRectMake(0, 0, 180, 18) text:Custing(@"单据签收", nil) font:Font_Important_15_20 textColor:Color_Unsel_TitleColor textAlignment:NSTextAlignmentLeft];
    titleLabel.center=CGPointMake(X(ImgView)+WIDTH(ImgView)+90+8, 13.5);
    [View_head addSubview:titleLabel];
    
    return View_head;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FormSignInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FormSignInfoCell"];
    if (cell==nil) {
        cell=[[FormSignInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FormSignInfoCell"];
    }
    [cell configCellWithDict:self.showDict];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
