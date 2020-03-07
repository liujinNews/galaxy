//
//  MyTeamCell.m
//  MyDemo
//
//  Created by tomzhu on 15/11/13.
//  Copyright © 2015年 sofawang. All rights reserved.
//

#import "MyTeamCell.h"
#import "MyTeamModel.h"

@interface MyTeamCell(){
    UILabel *_nameLabel;
    UIImageView *_headerFaceView;
    UIView *_bgView;
}
@end
@implementation MyTeamCell

- (id)initWithType:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:RGBACOLOR(0xf7, 0xf7, 0xf1, 1.0f)];
        self.contentView.backgroundColor = RGBACOLOR(0xf7, 0xf7, 0xf1, 1.0f);
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTACT_CELL_H)];
        [self.contentView addSubview:_bgView];
        
        //设置表格单元样式
        UIImage *headerImage = [UIImage imageNamed:@"contacts_unfoldfriend_pressed"];
        _headerFaceView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CONTACT_CELL_H-headerImage.size.height)/2,
                                                                        headerImage.size.width, headerImage.size.height)];
        _headerFaceView.image = headerImage;
        [self.contentView addSubview:_headerFaceView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerFaceView.frame.origin.x + _headerFaceView.frame.size.width+10, 20, 200, 20)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.numberOfLines = 0;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_nameLabel];
        
        [self setSelected:NO];
    }
    return self;
}

- (void) updateModel:(MyTeamModel *)model{
    
    //头像,目前是写死统一
    
    //名字
    NSString* name = model.teamTitle;
    
    _nameLabel.text = NSLocalizedString(name, @"");
    
    NSString *imageName = model.isFold ? @"contacts_unfoldfriend_pressed":@"contacts_foldfriend_pressed";
    
    UIImage *headerImage = [UIImage imageNamed:imageName];
    _headerFaceView.image = headerImage;
}

@end
