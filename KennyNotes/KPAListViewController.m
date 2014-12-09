//
//  KPAListViewController.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/24/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPAListViewController.h"
#import "KPANote.h"
#import "KPANoteViewController.h"
#import "MSCMoreOptionTableViewCell.h"
#import "KPAKit.h"
#import "KPANotesController.h"
#import "BVReorderTableView.h"
#import "KPAThemeController.h"

@interface KPAListViewController () <MSCMoreOptionTableViewCellDelegate, KPANotesControllerDelegate, ReorderTableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate> {
    NSIndexPath *pathToSave;
}

@property (nonatomic, strong) KPANotesController *notesController;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation KPAListViewController

- (instancetype)initWithTag:(KPATag *)tag {
    self = [super init];
    if (self) {
        self.notesController = [[KPANotesController alloc] initWithAsscociatedTag:tag];
        [self sharedInitWithArchived:NO];
        self.title = tag.name;
    }
    return self;
}

- (instancetype)initWithIsArchived:(BOOL)isArchived {
    self = [super init];
    if (self) {
        self.notesController = [[KPANotesController alloc] initWithDisplayArchive:isArchived];
        [self sharedInitWithArchived:isArchived];
    }
    return self;
}

- (void)sharedInitWithArchived:(BOOL)isArchived {
    self.notesController.delegate = self;
    
    self.tableView.separatorColor = [UIColor grayColor];
    
    if (!isArchived) {
        UIBarButtonItem *addNote = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote)];
        [self.navigationItem setRightBarButtonItem:addNote];
        [addNote setTintColor:[UIColor greenColor]];
        self.title = @"All Notes";
    } else {
        self.title = @"Archived";
    }
    self.tableView.tableFooterView = [UIView new];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar sizeToFit];
    [searchBar setBarStyle:[[KPAThemeController controller] currentBarStyle]];
    
    self.tableView.tableHeaderView = searchBar;
    searchBar.delegate = self;
    
    self.searchBar = searchBar;
    
    {
        //            [@1000 kpa_repititions:^(NSInteger i) {
        //                KPANote *note = [KPANote new];
        //                [note setCreationTime:[NSDate date]];
        //
        //                [note setNote:[@"Whats good " stringByAppendingFormat:@"%ld", (long)i]];
        //                [note save];
        //
        //                [self.notesController didSaveNewNote:note];
        //            }];
        
    }
    
    if ([self.notesController amountOfNotes] > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    self.tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height);
    
    ((BVReorderTableView *)self.tableView).canReorder = !isArchived;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.notesController startSearch];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.tableView addGestureRecognizer:tap];
    ((BVReorderTableView *)self.tableView).canReorder = NO;

    // HACK
    // https://gist.github.com/hebertialmeida/7548793
    for (UIView *subView in searchBar.subviews) {
        if([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *)subView setKeyboardAppearance:[[KPAThemeController controller] currentKeyboardAppearance]];
        } else {
            for (UIView *subSubView in [subView subviews]) {
                if([subSubView conformsToProtocol:@protocol(UITextInputTraits)]) {
                    [(UITextField *)subSubView setKeyboardAppearance:[[KPAThemeController controller] currentKeyboardAppearance]];
                }
            }
        }
    }
    
    // END HACK
    
}

// http://stackoverflow.com/questions/8192480/uitapgesturerecognizer-breaks-uitableview-didselectrowatindexpath
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"];
}

- (void)didTap:(UIGestureRecognizer *)gesRec {
    [self.searchBar setText:@""];
    [self.searchBar resignFirstResponder];
    [gesRec removeTarget:self action:@selector(didTap:)];
    [self.tableView removeGestureRecognizer:gesRec];
    gesRec.delegate = nil;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.notesController stopSearch];
    ((BVReorderTableView *)self.tableView).canReorder = !self.notesController.isDisplayingArchived;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.notesController searchWithQueryString:searchText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSetTheme:) name:KPADidSetThemeNotificationName object:nil];
    [[KPAThemeController controller] themeViewController:self];
}

- (void)didSetTheme:(id)notification {
    [[KPAThemeController controller] themeViewController:self];
    [[self tableView] reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)popView {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (id)saveObjectAndInsertBlankRowAtIndexPath:(NSIndexPath *)indexPath {
    pathToSave = indexPath;
    return nil;
}

- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [self.notesController switchNoteAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    pathToSave = toIndexPath;
}

- (void)finishReorderingWithObject:(id)object atIndexPath:(NSIndexPath *)indexPath; {
    pathToSave = nil;
}

- (void)loadView {
    self.view = [[BVReorderTableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
    ((BVReorderTableView *)self.view).delegate = self;
    ((BVReorderTableView *)self.view).dataSource = self;
}

- (void)addNote {
    KPANote *currentNote = nil;
    
    if (self.notesController.associatedTag) {
        currentNote = [KPANote new];
        [currentNote addTag:self.notesController.associatedTag];
    }
    
    KPANoteViewController *noteAdder = [[KPANoteViewController alloc] initWithNote:currentNote];
    noteAdder.delegate = self.notesController;
    
    [[self navigationController] pushViewController:noteAdder animated:YES];
    
    [[KPAThemeController controller] themeViewController:noteAdder];
}

#pragma - TableView delegate/datasource methods -

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.notesController deleteNoteAtIndexPath:indexPath];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notesController amountOfNotes];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSCMoreOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[MSCMoreOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell.delegate = self;
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    cell.selectedBackgroundView.backgroundColor = [[KPAThemeController controller] currentCellSelectionColor];
    
    if (self.notesController.isDisplayingArchived) {
        cell.textLabel.font = [UIFont italicSystemFontOfSize:15];
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.backgroundColor = [[KPAThemeController controller] currentCellColor];
    cell.textLabel.textColor = [[KPAThemeController controller] currentCellTextColor];
    
    if ([indexPath isEqual:pathToSave]) {
        cell.textLabel.text = @"";
        return cell;
    }
    
    [[cell textLabel] setText:[[self.notesController noteForIndexPath:indexPath] truncatedNote]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KPANoteViewController *noteAdder = [[KPANoteViewController alloc] initWithNote:[self.notesController noteForIndexPath:indexPath]];
    noteAdder.delegate = self.notesController;
    
    [[self navigationController] pushViewController:noteAdder animated:YES];
    
    [[KPAThemeController controller] themeViewController:noteAdder];
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.notesController switchNoteAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

#pragma - MSCMoreOptionTableViewCellDelegate -

- (UIColor *)tableView:(UITableView *)tableView backgroundColorForMoreOptionButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.notesController.isDisplayingArchived) {
        return [UIColor orangeColor];
    } else {
        return [UIColor greenColor];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForMoreOptionButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.notesController.isDisplayingArchived) {
        return @"Archive";
    } else {
        return @"Restore";
    }
}

- (void)tableView:(UITableView *)tableView moreOptionButtonPressedInRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.notesController.isDisplayingArchived) {
        [self.notesController archiveNoteAtIndexPath:indexPath];
    } else {
        [self.notesController restoreNoteAtIndexPath:indexPath];
    }
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)updatedDataSource {
    
    [self.tableView reloadData];
    
    // self.tableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height);
    
    
}


@end