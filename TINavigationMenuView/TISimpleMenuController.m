//
//  TIIconMenuController.m
//  TINavigationMenuView
//
//  Created by ishtar on 13. 10. 8..
//
//

#import "TISimpleMenuController.h"
#import "TIMenuTableView.h"
#import "UIColorHexString.h"

#define HAS_VISIBLE_VALUE(val) (val && [val isKindOfClass:[NSString class]] && val.length > 0)

@interface TISimpleMenuController ()
@end

@implementation TISimpleMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get menu array data
    NSArray *menuData = [self getMenuData:@"menu1"];
    
    // Initialization menu view
    TIMenuTableView *aMenuView = [[TIMenuTableView alloc] initWithFrame:self.view.bounds withMenuData:menuData];
    [aMenuView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
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
    TIMenuCell *aCategoryMenu = [[TIMenuCell alloc] initWithData:menuData
                                                        withSize:CGSizeMake(self.view.bounds.size.width, 44)
                                                       withDepth:0
                                                        withType:TIButtonTypeNormal | TIButtonIconLeft | TIButtonTextLeftAlign];
    
    NSString *aTitle = [menuData objectForKey:@"categoryName"];
    NSString *aTitleColor = [menuData objectForKey:@"titleColor"];
    NSString *aBackgroundColor = [menuData objectForKey:@"backgroundColor"];
    
    [aCategoryMenu setContentPadding:CGPointMake(2, 2)];

    if (HAS_VISIBLE_VALUE(aTitle)) {
        [aCategoryMenu.cellTitle setText:aTitle];
    }
    
    if (HAS_VISIBLE_VALUE(aBackgroundColor))
        [aCategoryMenu setBackgroundColor:[UIColor colorWithHexString:aBackgroundColor]];
    
    if (HAS_VISIBLE_VALUE(aTitleColor))
        [aCategoryMenu setTitleColor:[UIColor colorWithHexString:aTitleColor] forState:UIControlStateNormal];
    
    [aCategoryMenu.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    
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
- (NSArray *)getMenuData:(NSString*)name
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    NSError *aError = nil;
    NSMutableDictionary *resData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers
                                                                     error:&aError];
    if (aError) {
        NSLog(@"JSON parse errror : %@", [aError localizedDescription]);
        return nil;
    }
    
    NSMutableArray *menuData = [resData objectForKey:@"menuList"];
    return menuData;
}

@end
