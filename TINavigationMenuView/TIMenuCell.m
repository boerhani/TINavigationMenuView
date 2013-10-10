//
//  TIMenuCell.m
//
//  Created by ishtar on 13. 10. 8..
//  Copyright (c) 2013년 Coupang. All rights reserved.
//

#import "TIMenuCell.h"

@implementation TIMenuCell

- (id)initWithData:(NSDictionary *)menuData currentDepth:(int)menuDepth isCascadingTitle:(BOOL)isCascading cellHeight:(CGFloat)cellHeight
          menuType:(TIButtonType)buttonType contentPadding:(CGPoint)padding cellWidth:(CGFloat)cellWidth;
{
    self = [super init];
    
    if (self) {
        _menuDepth = menuDepth;
        
        _menuWidth = cellWidth;
        _menuHeight = cellHeight;
        
        _menuData = menuData;
        _contentPadding = padding;
        
        [self setCellButtonType:buttonType];
    
        [self setClipsToBounds:YES];
        [self setAutoresizesSubviews:YES];
        
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
        
        [self updateSubViews];
    }
    
    return self;
}

- (void)setCellButtonType:(TIButtonType)type
{
    _menuType = type;
    [self setUserInteractionEnabled:(_menuType != TIButtonTypeLabel)];
}

- (void)updateSubViews
{
    CGFloat contentHeight = _menuHeight - (_contentPadding.y*2);
    CGFloat titleWidth = _menuWidth - (contentHeight + _contentPadding.x*2)*2;
    
    if (_menuType & TIButtonIconLeft) {
        [_iconView setFrame:CGRectMake(_contentPadding.x, _contentPadding.y, contentHeight, contentHeight)];
    } else if (_menuType & TIButtonIconRight) {
        [_iconView setFrame:CGRectMake(_menuWidth - _menuHeight, _contentPadding.y, contentHeight, contentHeight)];
    }

    [_cellTitle setFrame:CGRectMake(contentHeight + _contentPadding.x*2, _contentPadding.y, titleWidth, contentHeight)];

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
