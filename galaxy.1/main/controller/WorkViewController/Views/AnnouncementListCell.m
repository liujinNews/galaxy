//
//  AnnouncementListCell.m
//  galaxy
//
//  Created by hfk on 2018/2/9.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "AnnouncementListCell.h"
@implementation AnnouncementListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView{
    if (!_lab_Title) {
        _lab_Title=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_Black_Important_20 textAlignment:NSTextAlignmentLeft];
        _lab_Title.numberOfLines=0;
        [self.contentView addSubview:_lab_Title];
    }
    [_lab_Title makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(@12);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.right.equalTo(self.contentView.right).offset(@-12);
        make.height.equalTo(@0);
    }];
    
    if (!_lab_Draft) {
        _lab_Draft=[GPUtils createLable:CGRectZero text:Custing(@"草稿", nil) font:Font_Same_10_20 textColor:Color_Blue_Important_20 textAlignment:NSTextAlignmentCenter];
        [_lab_Draft.layer setMasksToBounds:YES];
        [_lab_Draft.layer setCornerRadius:8.0];
        [_lab_Draft.layer setBorderWidth:1.0];
        _lab_Draft.layer.borderColor=Color_Blue_Important_20.CGColor;
        [self.contentView addSubview:_lab_Draft];
    }
    [_lab_Draft makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Title.bottom).offset(@10);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.size.equalTo(CGSizeMake(0, 0));
    }];
    
    if (!_lab_TimeAndName) {
        _lab_TimeAndName=[GPUtils createLable:CGRectZero text:nil font:Font_Same_12_20 textColor:Color_LineGray_Same_20 textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_lab_TimeAndName];
    }
    
    [_lab_TimeAndName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_Title.bottom).offset(@11);
        make.left.equalTo(self.lab_Draft.right);
        make.size.equalTo(CGSizeMake(Main_Screen_Width-12-40-10-12, 14));
    }];
    
    if (!_lab_Body) {
        _lab_Body=[GPUtils createLable:CGRectZero text:nil font:Font_Important_15_20 textColor:Color_GrayDark_Same_20 textAlignment:NSTextAlignmentLeft];
        _lab_Body.numberOfLines=0;
        [self.contentView addSubview:_lab_Body];
    }
    [_lab_Body makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_TimeAndName.bottom).offset(@10);
        make.bottom.equalTo(self.contentView.bottom).offset(@-15);
        make.left.equalTo(self.contentView.left).offset(@12);
        make.right.equalTo(self.contentView.right).offset(@-12);
    }];
}


-(void)configCellWithModel:(AnnouncementListModel *)model{
    NSString *title=[NSString isEqualToNull:model.subject]?model.subject:@"";
    CGSize size = [title sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    [_lab_Title updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(size.height));
    }];
    _lab_Title.text=model.subject;
    
    if ([model.status floatValue]==0) {
        [_lab_Draft updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(36, 16));
        }];
        [_lab_TimeAndName updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lab_Draft.right).offset(@10);
        }];
    }else{
        [_lab_Draft updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        [_lab_TimeAndName updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lab_Draft.right);
        }];
    }
    
    _lab_TimeAndName.text=[GPUtils getSelectResultWithArray:@[[NSString stringWithFormat:@"%@",model.publishedDate],[NSString stringWithFormat:@"%@",model.author]] WithCompare:@" "];
    
    _lab_Body.text=[NSString isEqualToNull:model.body]?[NSString stringWithFormat:@"%@",model.body]:@"";
    
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight =12+10+15+5+15;
    AnnouncementListModel *model=(AnnouncementListModel *)obj;
    NSString *title=[NSString isEqualToNull:model.subject]?model.subject:@"";
    CGSize size = [title sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    if (size.height>20) {
        cellHeight += size.height;
    }else{
        cellHeight += 20;
    }
    NSString *body=[NSString isEqualToNull:model.body]?model.body:@"";
    CGSize size1 = [body sizeCalculateWithFont:Font_Important_15_20 constrainedToSize:CGSizeMake(Main_Screen_Width-12-12, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    if (size1.height>40) {
        cellHeight += 40;
    }else if (size1.height>20&&size1.height<40) {
        cellHeight += size1.height;
    }else{
        cellHeight += 20;
    }
    return cellHeight;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
