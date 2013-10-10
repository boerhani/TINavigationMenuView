//
//  TIViewController.m
//  TINavigationMenuView
//
//  Created by ishtar on 13. 10. 8..
//
//

#import "TIViewController.h"
#import "TIMenuTableView.h"
#import "UIColorHexString.h"

#define HAS_VISIBLE_VALUE(val) (val && [val isKindOfClass:[NSString class]] && val.length > 0)

@interface TIViewController ()
@end

@implementation TIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get menu array data
    NSArray *menuData = [self getMenuData];
    
    // Initialization menu view
    TIMenuTableView *aMenuView = [[TIMenuTableView alloc] initWithFrame:self.view.bounds withMenuData:menuData];
    [aMenuView setMenuDelegate:self];
    
    // Just add
    [self.view addSubview:aMenuView];
}


#pragma mark - MenuTableView delegate methods (like UITableViewDelegate & DataSourceDelegate)
- (void)didSelectCell:(TIMenuCell *)selectedCell hasChild:(BOOL)hasChildMenu;
{
    NSLog(@"onViewContent [%@] [%@]", selectedCell.cellTitle.text, hasChildMenu ? @"Has Child":@"No Child");
}

- (TIMenuCell *)menuCellForData:(NSDictionary*)menuData
{
    // Customized menu data (build with your own data)
    TIMenuCell *aCategoryMenu = [[TIMenuCell alloc] initWithData:menuData currentDepth:0 isCascadingTitle:YES cellHeight:44
                                                        menuType:TIButtonTypeNormal | TIButtonIconLeft | TIButtonTextLeftAlign contentPadding:CGPointMake(10, 3) cellWidth:self.view.bounds.size.width];
    
    NSString *aTitle = [menuData objectForKey:@"categoryName"];
    NSString *aTitleColor = [menuData objectForKey:@"titleColor"];
    NSString *aSubTitle = [menuData objectForKey:@"subTitleName"];
    NSString *aBackgroundImage = [menuData objectForKey:@"bgImage"];
    NSString *aBackgroundColor = [menuData objectForKey:@"backgroundColor"];
    NSString *aCategoryIconPath = [menuData objectForKey:@"categoryIconPath"];

    if (HAS_VISIBLE_VALUE(aTitle)) {
        [aCategoryMenu.cellTitle setText:aTitle];
    }
    
    if (HAS_VISIBLE_VALUE(aSubTitle)) {
        [aCategoryMenu.subCellTitle setText:aSubTitle];
        [aCategoryMenu.subCellTitle setTextAlignment:NSTextAlignmentLeft];
        [aCategoryMenu.subCellTitle setFrame:CGRectMake(20, aCategoryMenu.bounds.size.height - (10 + 12), aCategoryMenu.bounds.size.width - 20, 12)];
    }
    
    if (HAS_VISIBLE_VALUE(aBackgroundColor))
        [aCategoryMenu setBackgroundColor:[UIColor colorWithHexString:aBackgroundColor]];
    
    if (aBackgroundImage && aBackgroundImage.length > 0) {
        [aCategoryMenu setBackgroundImage:[UIImage imageNamed:aBackgroundImage] forState:UIControlStateNormal];
    }
    
    if (HAS_VISIBLE_VALUE(aTitleColor))
        [aCategoryMenu setTitleColor:[UIColor colorWithHexString:aTitleColor] forState:UIControlStateNormal];
    
    [aCategoryMenu.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    
    if (HAS_VISIBLE_VALUE(aCategoryIconPath))
        [aCategoryMenu.iconView setImage:[UIImage imageNamed:aCategoryIconPath]];
    
    if (aCategoryMenu.menuHeight > 0)
        [aCategoryMenu setFrame:CGRectMake(aCategoryMenu.frame.origin.x, aCategoryMenu.frame.origin.y,
                                           aCategoryMenu.frame.size.width, aCategoryMenu.frame.size.height)];

    return aCategoryMenu;
}

- (NSArray *)childMenuForData:(NSDictionary*)menuData
{
    id subCategoryList = [menuData objectForKey:@"subCategoryList"];
    
    if (subCategoryList && [subCategoryList isKindOfClass:[NSArray class]]) {
        return subCategoryList;
    }
    
    return nil;
}

- (TIMenuCell *)applyRootButtonTheme:(TIMenuCell *)passedRootButton
{
    [passedRootButton setBackgroundColor:[UIColor darkGrayColor]];
    [passedRootButton setTitle:@"Top Menu" forState:UIControlStateNormal];
    [passedRootButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    return passedRootButton;
}


#pragma mark - Get menu data from file or network
- (NSArray *)getMenuData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    NSError *aError = nil;
    NSMutableDictionary *resData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers
                                                                     error:&aError];
    if (aError) {
        NSLog(@"JSON parse errror : %@", [aError localizedDescription]);
        return nil;
    }
    
    NSMutableArray *menuData = [resData objectForKey:@"categoryList"];
    return menuData;
}

@end
