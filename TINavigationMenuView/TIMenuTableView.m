//
//  CPNavigationMenuView.m
//
//  Created by ishtar on 13. 10. 8..
//  Copyright (c) 2013년 Coupang. All rights reserved.
//

#import "TIMenuTableView.h"
#import "TIMenuCell.h"

#define DEFAULT_BACK_BUTTON_HEIGHT 44

@implementation TIMenuTableView

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame withMenuData:(NSArray *)menuData
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _currentButtons = [[NSMutableArray alloc] init];
        _historyData = [[NSMutableArray alloc] init];
        
        _menuData = menuData;
        
        _menuDataDelegate = nil;
        _currentMenuButton = nil;
        
        _cascadingTitleMargin = YES;
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setMenuDelegate:(id)toDelegate
{
    _menuDataDelegate = toDelegate;
    [self loadMenuData];
}

- (TIMenuCell *)getBackButton
{
    TIMenuCell *backMenu = [[TIMenuCell alloc] initWithData:nil
                                                   withSize:CGSizeMake(self.bounds.size.width, DEFAULT_BACK_BUTTON_HEIGHT)
                                                  withDepth:0
                                                   withType:TIButtonTypeBack];
    [backMenu setContentPadding:CGPointMake(3, 3)];
    [backMenu addTarget:self action:@selector(onTouchBack:) forControlEvents:UIControlEventTouchUpInside];
    [backMenu setFrame:CGRectMake(0, 0, self.bounds.size.width, DEFAULT_BACK_BUTTON_HEIGHT)];
    
    [backMenu updateSubviews];
    
    if (_menuDataDelegate) {
        return [_menuDataDelegate applyRootButtonTheme:backMenu];
    }
    
    return backMenu;
}

- (NSString*)randomUIColorString
{
    NSString *letters = @"0123456789ABCDEF";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:6];
    
    for (int i=0; i<6; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

#pragma mark - Create & Update Menu Buttons
- (void)loadMenuData
{
    if (_menuDataDelegate == nil) return;
    
    NSMutableArray *disaplyMenuData = [[NSMutableArray alloc] init];
    
    NSUInteger menuCount = [_menuData count];
    
    for (int i=0; i<menuCount; i++) {
        NSDictionary *cellData = [_menuData objectAtIndex:i];
        TIMenuCell *aCategoryMenuCell = [_menuDataDelegate menuCellForData:cellData];
        [aCategoryMenuCell addTarget:self action:@selector(onTouchNext:) forControlEvents:UIControlEventTouchUpInside];
        [disaplyMenuData addObject:aCategoryMenuCell];
        [self addSubview:aCategoryMenuCell];
    }
    
    [self updateViewPositions:disaplyMenuData];
    
    [_currentButtons removeAllObjects];
    [_currentButtons addObjectsFromArray:disaplyMenuData];
}

- (void)updateViewPositions:(NSArray*)buttons
{
    _offsetY = 0.0f;
    
    for (TIMenuCell *aMenuButton in buttons) {
        BOOL isLastHistoryButton = [[_historyData lastObject] isEqual:aMenuButton.menuData];
        
        if (aMenuButton.menuType == TIButtonTypeBack || (aMenuButton.menuType == TIButtonTypeHistory && isLastHistoryButton == NO)) {
            _offsetY += aMenuButton.menuSize.height;
            continue;
        }
        
        CGRect buttonRect = CGRectMake(0.0f, 0.0f + _offsetY, self.bounds.size.width, aMenuButton.menuSize.height);
        _offsetY += aMenuButton.menuSize.height;
        [aMenuButton setFrame:buttonRect];
    }
        
    [self setContentSize:CGSizeMake(self.bounds.size.width, _offsetY)];
}

- (void)updateHistoryPositions:(NSArray*)buttons
{
    _offsetY = 0.0f;
    
    for (TIMenuCell *aMenuButton in buttons) {
        BOOL isLastHistoryButton = [[_historyData lastObject] isEqual:aMenuButton.menuData];
        
        if (aMenuButton.menuType != TIButtonTypeHistory || isLastHistoryButton == YES) {
            _offsetY += aMenuButton.bounds.size.height;
            continue;
        }
        
        CGRect buttonRect = CGRectMake(0.0f, 0.0f + _offsetY, self.bounds.size.width, aMenuButton.bounds.size.height);
        _offsetY += aMenuButton.menuSize.height;
        [aMenuButton setFrame:buttonRect];
    }
    
    [self setContentSize:CGSizeMake(self.bounds.size.width, _offsetY)];
}

- (NSMutableArray *)createHistoryButtons:(NSArray*)menuData withOriginY:(CGFloat)originY
{
    NSMutableArray *createdButtons = [[NSMutableArray alloc] init];
    
    for (NSDictionary *aMenuData in menuData) {
        TIMenuCell *newCell = [_menuDataDelegate menuCellForData:aMenuData];
        [newCell addTarget:self action:@selector(onTouchNext:) forControlEvents:UIControlEventTouchUpInside];
        [newCell setCellButtonType:TIButtonTypeHistory];
        
        CGRect buttonRect = CGRectMake(0.0f, originY, self.bounds.size.width, newCell.menuSize.height);
        [newCell setFrame:buttonRect];
        
        [self addSubview:newCell];
        
        [createdButtons addObject:newCell];
    }
    
    return createdButtons;
}

- (NSMutableArray *)createButtons:(NSArray *)menuData defaultFrame:(CGRect)buttonRect currentButton:(TIMenuCell *)curButton
{
    NSMutableArray *createdButtons = [[NSMutableArray alloc] init];
    
    for (NSDictionary *aMenuData in menuData) {
        TIMenuCell *newCell = [_menuDataDelegate menuCellForData:aMenuData];
        buttonRect.origin.y = curButton.frame.origin.y;
        buttonRect.size.height = newCell.menuSize.height;
        [newCell setFrame:buttonRect];
        [newCell addTarget:self action:@selector(onTouchNext:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:newCell];
        
        [createdButtons addObject:newCell];
    }
    
    return createdButtons;
}

- (void)divideButtons:(NSMutableArray *)fromArray toTop:(NSMutableArray **)topArray toBottom:(NSMutableArray **)bottomArray
          pivotButton:(id)pivotButton
{
    BOOL toTop = YES;
    
    for (id aButton in fromArray) {
        if ([aButton isKindOfClass:[TIMenuCell class]] == NO) {
            continue;
        }
        
        if (toTop) [*topArray addObject:aButton];
        else [*bottomArray addObject:aButton];
        
        if ([aButton isEqual:pivotButton]) {
            toTop = NO;
        }
    }
}

- (void)onTouchBack:(id)sender
{
    [_historyData removeAllObjects];
    [self updateMenu:sender toRoot:YES];
}

- (void)onTouchNext:(id)sender
{
    [self updateMenu:sender toRoot:NO];
}

- (void)updateMenu:(TIMenuCell *)btnSender toRoot:(BOOL)gotoRoot
{
    if (btnSender == nil || [btnSender isEqual:_currentMenuButton]) {
        return;
    }
    
    NSArray *childMenus = gotoRoot ? _menuData : [_menuDataDelegate childMenuForData:btnSender.menuData];
    
    BOOL hasChild = (childMenus && [childMenus count] > 0);
    
    if (gotoRoot == NO) {
        [_menuDataDelegate didSelectCell:btnSender hasChild:hasChild];
        
        if (hasChild == NO) return;
    }
    
    _currentMenuButton = btnSender;    
    
    // Divie buttons remove to TOP & BOTTOM
    __block NSMutableArray *removeToTop = [[NSMutableArray alloc] init];
    __block NSMutableArray *removeToBottom = [[NSMutableArray alloc] init];
    
    [self divideButtons:_currentButtons toTop:&removeToTop toBottom:&removeToBottom pivotButton:btnSender];
    
    // Create sub buttons
    CGRect newPosition = btnSender.frame;
    NSMutableArray *createData = [[NSMutableArray alloc] init];
    
    if (gotoRoot == NO) {
        BOOL removeBelows = NO;
        NSMutableArray *toDelete = [[NSMutableArray alloc] init];
        for (id data in _historyData) {
            if ([data isEqual:btnSender.menuData]) {
                removeBelows = YES;
            }
            
            if (removeBelows) {
                [toDelete addObject:data];
            }
        }
        
        [_historyData removeObjectsInArray:toDelete];
    }
    
    [createData addObjectsFromArray:childMenus];
    
    CGFloat offsetHeight = newPosition.origin.y + self.bounds.size.height;
    
    [btnSender setSelected:NO];
    [self applyCurrentButtons:createData withOriginY:newPosition.origin.y withNewPosition:newPosition sender:btnSender
                     gotoRoot:gotoRoot];
    [self animateCurrentButtons:offsetHeight toTopButton:removeToTop toBottomButton:removeToBottom];
}

- (void)animateCurrentButtons:(CGFloat)offsetHeight
                  toTopButton:(NSMutableArray *)removeToTop toBottomButton:(NSMutableArray *)removeToBottom
{
    __weak TIMenuTableView *selfView = self;
    
    [self updateHistoryPositions:_currentButtons];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [selfView updateViewPositions:_currentButtons];
                         [selfView moveOutFromView:removeToTop withDirection:YES offset:offsetHeight];
                         [selfView moveOutFromView:removeToBottom withDirection:NO offset:offsetHeight];
                     }
                     completion:^(BOOL finished) {
                         [selfView removeButtonFromView:removeToTop];
                         [selfView removeButtonFromView:removeToBottom];
                         
                         [removeToTop removeAllObjects];
                         [removeToBottom removeAllObjects];
                     }];
}

- (void)applyCurrentButtons:(NSMutableArray *)createData withOriginY:(CGFloat)originY withNewPosition:(CGRect)newPosition
                     sender:(TIMenuCell *)btnSender gotoRoot:(BOOL)gotoRoot
{
    NSMutableArray *createdButtons = [self createButtons:createData defaultFrame:newPosition currentButton:btnSender];
    
    [_currentButtons removeAllObjects];
    
    if (gotoRoot == NO) {
        TIMenuCell *backButton = [self getBackButton];
        
        [_menuDataDelegate childMenuForData:btnSender.menuData];
        
        [self addSubview:backButton];
        [self bringSubviewToFront:backButton];
        [_currentButtons addObject:backButton];
        
        [_historyData addObject:btnSender.menuData];
    }

    NSMutableArray *historyButtons = [self createHistoryButtons:_historyData withOriginY:originY];
    [_currentButtons addObjectsFromArray:historyButtons];
    [_currentButtons addObjectsFromArray:createdButtons];
}

- (void)moveOutFromView:(NSMutableArray *)array withDirection:(BOOL)toTop offset:(CGFloat)viewHeight
{
    for (TIMenuCell *delButton in array) {
        if (delButton.menuType == TIButtonTypeBack) {
            continue;
        }
        
        CGRect curFrame = delButton.frame;
        curFrame.origin.y = (toTop ? DEFAULT_BACK_BUTTON_HEIGHT : self.bounds.size.height);

        [delButton setFrame:curFrame];
        [delButton updateSubviews];
    }
}

- (void)removeButtonFromView:(NSMutableArray *)array
{
    for (TIMenuCell *delButton in array) {
        [delButton removeFromSuperview];
    }
}

@end
