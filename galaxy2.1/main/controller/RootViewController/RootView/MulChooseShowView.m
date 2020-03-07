//
//  MulChooseShowView.m
//  galaxy
//
//  Created by hfk on 2018/8/10.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "MulChooseShowView.h"
#import "MulChooseShowCell.h"

@interface MulChooseShowView ()<UITableViewDelegate,UITableViewDataSource>

//1新建 2查看 3审批查看
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSMutableArray *showIdArray;
@property (nonatomic, strong) NSMutableArray *showDataArray;
@property (nonatomic, strong) UITableView *tableView;


@end


@implementation MulChooseShowView

-(instancetype)initWithStatus:(NSInteger)status withFlowCode:(NSString *)flowcode{
    self = [super init];
    
    if (self) {
        [self setClipsToBounds:YES];
        _status = status;
        _flowCode = flowcode;
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = Color_form_TextFieldBackgroundColor;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.clipsToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [_tableView registerClass:[MulChooseShowCell class] forCellReuseIdentifier:@"MulChooseShowCell"];
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
    
    NSString *Id = dict[@"Id"];
    NSString *Value = dict[@"Value"];
    if (!self.model) {
        self.model = dict[@"Model"];
        if (self.status == 3 && ![[NSString stringWithFormat:@"%@",self.model.isOnlyRead]isEqualToString:@"1"]) {
            self.status = 1;
        }
    }
    self.showIdArray = [NSMutableArray arrayWithArray:[Id componentsSeparatedByString:@","]];
    self.showDataArray = [NSMutableArray arrayWithArray:[Value componentsSeparatedByString:@"⊕"]];
    NSInteger height = _status != 2 ? 10:0;
    if (self.showDataArray.count > 1) {
        height += 50+(self.showDataArray.count-1)*30;
    }else{
        height += 50;
    }
    if (!self.model || (self.model&&[self.model.isShow floatValue]==0)) {
        height = 0;
    }
    [_tableView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.showDataArray) {
        return self.showDataArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    }else{
        return 30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.status != 2 ? 10:0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, self.status != 2 ? 10:0.01)];
    view.backgroundColor = Color_White_Same_20;
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MulChooseShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MulChooseShowCell" forIndexPath:indexPath];
    NSString *str = self.showDataArray[indexPath.row];
    [cell configCellWithModel:_model WithValue:str WithIndex:indexPath withStatus:_status];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.CellClickBlock) {
        NSDictionary *dict = @{@"flowcode":self.flowCode,
                               @"taskId": self.showIdArray.count > indexPath.row ? [NSString stringWithIdOnNO:self.showIdArray[indexPath.row]]:@""
                               };
        self.CellClickBlock(dict, self.status);
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
