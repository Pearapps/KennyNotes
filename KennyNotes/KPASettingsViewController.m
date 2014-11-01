//
//  KPASettingsViewController.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/27/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPASettingsViewController.h"
#import "MSCellAccessory/MSCellAccessory.h"
#import "KPAThemeController.h"
#import "KPAKit.h"

@interface KPASettingsViewController () <UIActionSheetDelegate>

@end

@implementation KPASettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    [[KPAThemeController controller] themeViewController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSetTheme:) name:KPADidSetThemeNotificationName object:nil];
    
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)]];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor kpa_systemBlue];
}

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSetTheme:(id)notification {
    [[KPAThemeController controller] themeViewController:self];
    [[self tableView] reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    cell.selectedBackgroundView.backgroundColor = [[KPAThemeController controller] currentCellSelectionColor];

    cell.textLabel.text = @"Theme";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.backgroundColor = [[KPAThemeController controller] currentCellColor];
    cell.textLabel.textColor = [[KPAThemeController controller] currentCellTextColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Dark", @"Light", nil];
    [actionSheet showInView:self.view];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([actionSheet cancelButtonIndex] == buttonIndex) {
        return;
    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Dark"]) {
        [[KPAThemeController controller] didSelectTheme:KPAThemeDark];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Light"]) {
        [[KPAThemeController controller] didSelectTheme:KPAThemeLight];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
