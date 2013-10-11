//
//  TIMenuCell.m
//
//  Created by ishtar on 13. 10. 8..
//  Copyright (c) 2013년 Coupang. All rights reserved.
//

#import "TIMenuCell.h"

@implementation TIMenuCell

- (id)initWithData:(NSDictionary *)data withSize:(CGSize)size withDepth:(int)depth withType:(TIButtonType)type
{
    self = [super init];
    
    if (self) {
        _menuData = data;
        _menuSize = size;
        _menuDepth = depth;
        
        _contentPaddings = CGPointZero;
        
        [self setCellButtonType:type];
    
        [self setClipsToBounds:YES];
        [self setAutoresizesSubviews:YES];
        
        [self initSubviews];
        [self updateSubviews];
    }
    
    return self;
}

- (void)initSubviews
{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        [_iconView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_iconView];
    }
    
    if (_cellTitle == nil) {
        _cellTitle = [[UILabel alloc] init];
        [_cellTitle setFont:[UIFont systemFontOfSize:14.0f]];
        [_cellTitle setTextColor:[UIColor whiteColor]];
        [_cellTitle setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_cellTitle];
    }
    
    if (_subCellTitle == nil) {
        _subCellTitle = [[UILabel alloc] init];
        [_subCellTitle setFont:[UIFont systemFontOfSize:10.0f]];
        [_subCellTitle setTextColor:[UIColor whiteColor]];
        [_subCellTitle setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_subCellTitle];
    }
}

- (void)setCellButtonType:(TIButtonType)type
{
    _menuType = type;
    [self setUserInteractionEnabled:(_menuType != TIButtonTypeLabel)];
    [self updateSubviews];
}

- (void)setContentPadding:(CGPoint)contentPaddings
{
    _contentPaddings = contentPaddings;
    [self updateSubviews];
}

- (void)updateSubviews
{
    CGFloat contentHeight = _menuSize.height - (_contentPaddings.y*2);
    CGFloat titleWidth = _menuSize.width - (contentHeight + _contentPaddings.x*2)*2;
    
    if (_menuType & TIButtonIconLeft) {
        [_iconView setFrame:CGRectMake(_contentPaddings.x, _contentPaddings.y, contentHeight, contentHeight)];
    } else if (_menuType & TIButtonIconRight) {
        [_iconView setFrame:CGRectMake(_menuSize.width - _menuSize.height, _contentPaddings.y, contentHeight, contentHeight)];
    }

    [_cellTitle setFrame:CGRectMake(contentHeight + _contentPaddings.x*2, _contentPaddings.y, titleWidth, contentHeight)];

    // Title layout
    if (_menuType & TIButtonTextLeftAlign) {
        [_cellTitle setTextAlignment:NSTextAlignmentLeft];
    } else if (_menuType & TIButtonTextCenterAlign) {
        [_cellTitle setTextAlignment:NSTextAlignmentCenter];
    } else if (_menuType & TIButtonTextRightAlign) {
        [_cellTitle setTextAlignment:NSTextAlignmentRight];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
