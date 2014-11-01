//
//  KPANoteViewController.m
//  KennyNotes
//
//  Created by Kenneth Parker Ackerson on 6/24/14.
//  Copyright (c) 2014 Kenny. All rights reserved.
//

#import "KPANoteViewController.h"
#import "KPAKit.h"
#import "KPAThemeController.h"
#import "KPAActionSelectorView.h"
#import <MessageUI/MessageUI.h>
#import "KPANoteAdditionalButtonView.h"
#import "KPANoteImageDisplayView.h"
#import "KPAImageDisplayingViewController.h"
#import "KPATagContainerView.h"
#import "KPATagController.h"
#import "KPATagButton.h"
#import "KPACustomNoteTextView.h"
#import "UIImage+KPAAdditions.h"

@interface KPANoteViewController () <UIActionSheetDelegate, KPAActionSelectorViewDelegate, MFMailComposeViewControllerDelegate, KPANoteAdditionalButtonViewDelegate, KPANoteImageDisplayViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, KPATagContainerViewDelegate>

@property (nonatomic, strong) KPANote *currentNote;
@property (nonatomic, strong) KPACustomNoteTextView *textView;
@property (nonatomic, strong) KPAActionSelectorView *actionSelector;
@property (nonatomic, strong) UITapGestureRecognizer *actionBarDismissalTap;
@property (nonatomic, strong) KPANoteAdditionalButtonView *otherButtons;
@property (nonatomic, strong) KPANoteImageDisplayView *imageDisplayView;
@property (nonatomic, strong) KPATagContainerView *tagContainer;
@property (nonatomic, assign) BOOL isKeyboardUp;

@property (nonatomic, weak) KPATagButton *selectedTagButton;
@property (nonatomic, assign) NSInteger selectedImageID;

@end

@implementation KPANoteViewController


- (id)initWithNote:(KPANote *)note {
    self = [super init];
    if (self) {
        
        self.textView = [[KPACustomNoteTextView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.textView];
        [self.textView setTextColor:[[KPAThemeController controller] currentCellTextColor]];
        [self.textView setFont:[UIFont systemFontOfSize:15]];

        if ([KPAThemeController controller].currentTheme == KPAThemeDark) {
            [self.textView setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1.0]];
        } else {
            [self.textView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.backgroundColor = self.textView.backgroundColor;
        });
        
        self.textView.keyboardAppearance = [[KPAThemeController controller] currentKeyboardAppearance];
        
        self.currentNote = note;
        
        self.textView.text = self.currentNote.note;
        
        self.otherButtons = [[KPANoteAdditionalButtonView alloc] initWithNote:note withTypes:@[@(KPAAdditionalButtonTypePicture)]];
        self.otherButtons.scale = 0.75;
        [self.view addSubview:self.otherButtons];
        self.otherButtons.delegate = self;
        
        if (!self.currentNote.existsInDatabase) { self.title = @"New Note"; } else { self.title = @"Editing"; }
        
        UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(more:)];
        [self.navigationItem setRightBarButtonItem:more];
        [more setTintColor:[UIColor kpa_systemBlue]];
        
        self.tagContainer = [[KPATagContainerView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:self.tagContainer];
        self.tagContainer.delegate = self;
        [self.tagContainer setCurrentNote:self.currentNote];
        
    }
    return self;
}

#pragma mark KPATagController -

- (void)didCreateNewTag:(KPATag *)tag {
    [self.currentNote addTag:tag];
}

- (void)wantsToRemoveTag:(KPATag *)tag {
    [self.currentNote removeTag:tag];
}

- (void)didSelectTagButton:(KPATagButton *)tagButton {
    CGRect frame = tagButton.frame;
    frame = [self.view convertRect:frame fromView:tagButton.superview];
    [[UIMenuController sharedMenuController] setMenuItems:@[[[UIMenuItem alloc] initWithTitle:@"Remove Tag" action:@selector(removeThisTag)]]];
    [self showMenuAtFrame:frame];
    self.selectedTagButton = tagButton;
}

- (void)removeThisTag {
    [self wantsToRemoveTag:self.selectedTagButton.associatedTag];
    [self.tagContainer removeTagButton:self.selectedTagButton];
}

#pragma mark -

- (void)showMenuAtFrame:(CGRect)frame {
    
    if ([self.textView isFirstResponder]) {
        self.textView.overrideNextResponder = self;
    } else {
        [self becomeFirstResponder];
    }
    
    [[UIMenuController sharedMenuController] setTargetRect:frame inView:self.view];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide:) name:@"UIMenuControllerWillHideMenuNotification" object:nil];
    
}

- (void)menuDidHide:(NSNotification*)notification {
    self.selectedTagButton = nil;
    self.textView.overrideNextResponder = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIMenuControllerWillHideMenuNotification" object:nil];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (action == @selector(removeThisTag) || action == @selector(showThisImage) || action == @selector(removeThisTagImage)) {
        return YES;
    }
    
    return NO;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.otherButtons.scale = 0.75;
    } else {
        self.otherButtons.scale = 0.6;
    }
    [self layoutTextView];
    [self positionAll];
}

- (void)didSelectButtonType:(KPAAdditionalButtonType)buttonType {
    if (buttonType == KPAAdditionalButtonTypePicture) {
        
        if (self.imageDisplayView) {
            [self.imageDisplayView removeFromSuperview];
            self.imageDisplayView = nil;
            return;
        }
        
        [self addGestureRecognizer];
        
        self.imageDisplayView = [[KPANoteImageDisplayView alloc] initWithNote:self.currentNote];
        self.imageDisplayView.delegate = self;
        [self positionImageDisplay];
        [self.view addSubview:self.imageDisplayView];
    } else {
        [self.textView resignFirstResponder];
        [self.tagContainer resignTheTextFields];
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([actionSheet cancelButtonIndex] == buttonIndex) { return; }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
 
    
    picker.sourceType = ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Photo Library"] ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera);
    
    
    [self presentViewController:picker animated:YES completion:NULL];

    
}


#pragma mark KPANoteImageDisplayViewDelegate -

- (void)requestAdditionalImageForNote:(KPANote *)note {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:@"Camera"];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [actionSheet addButtonWithTitle:@"Photo Library"];
    }
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
    [actionSheet showInView:self.view];
    
}

- (void)didSelectImageID:(NSInteger)imageID withViewOfSelectedImage:(UIView *)view {
    CGRect frame = view.frame;
    frame = [self.view convertRect:frame fromView:view.superview];
    self.selectedImageID = imageID;
    [[UIMenuController sharedMenuController] setMenuItems:@[[[UIMenuItem alloc] initWithTitle:@"Remove" action:@selector(removeThisTagImage)], [[UIMenuItem alloc] initWithTitle:@"Show" action:@selector(showThisImage)]]];
    [self showMenuAtFrame:frame];
}

- (void)showThisImage {
    KPAImageDisplayingViewController *imageDisplayer = [[KPAImageDisplayingViewController alloc] initWithImageID:self.selectedImageID andNote:self.currentNote];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:imageDisplayer];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)removeThisTagImage {
    [self.currentNote removeImageWithID:self.selectedImageID];
    [self.imageDisplayView reloadImages];
}

#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *noteImage = info[UIImagePickerControllerOriginalImage];
    noteImage = [noteImage normalizedImage];
    KPANoteImage *image = [[KPANoteImage alloc] initWithCGImage:noteImage.CGImage];
    [self.currentNote addImage:image];
    [self.imageDisplayView addImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self positionAll];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self positionAll];
}

#pragma mark Layout -

- (void)positionAll { // positions all these things
    [self positionOtherButtons];
    [self positionImageDisplay];
    [self positionTagContainer];
}

- (void)positionTagContainer {
    [self.tagContainer kpa_modifyBoundsSize:CGSizeMake(self.otherButtons.frame.origin.x-2, CGRectGetHeight(self.otherButtons.bounds))];
    self.tagContainer.center = CGPointMake(CGRectGetWidth(self.tagContainer.bounds)/2, self.otherButtons.center.y);
}

- (void)positionOtherButtons {
    [self.otherButtons setCenter:CGPointMake(CGRectGetWidth(self.textView.bounds) - CGRectGetWidth(self.otherButtons.bounds)/2, CGRectGetHeight(self.textView.bounds) - CGRectGetHeight(self.otherButtons.bounds)/2 + (self.isKeyboardUp ? CGRectGetHeight(self.otherButtons.bounds) : 0))];
}

- (void)positionImageDisplay {
    CGRect buttonFrame = [self.view convertRect:[[self otherButtons] frameForButtonType:KPAAdditionalButtonTypePicture] fromView:[self otherButtons]];
    [self.imageDisplayView setCenter:CGPointMake(buttonFrame.origin.x + CGRectGetWidth(buttonFrame) - CGRectGetWidth(self.imageDisplayView.frame)/2 - 5, self.otherButtons.center.y - CGRectGetHeight(self.otherButtons.bounds)/2 - CGRectGetHeight(self.imageDisplayView.bounds)/2-5)];
    [self.imageDisplayView readjustBounds];
}

#pragma mark -

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if (self.isMovingFromParentViewController) { // self.isBeingDismissed
        [self save];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSetTheme:) name:KPADidSetThemeNotificationName object:nil];
//    [[KPAThemeController controller] themeViewController:self];
//}
//
//- (void)didSetTheme:(id)notification {
//    [self.textView setBackgroundColor:[[KPAThemeController controller] currentBackgroundColor]];
//    [self.textView setTextColor:[[KPAThemeController controller] currentCellTextColor]];
//    [[KPAThemeController controller] themeViewController:self];
//}

#pragma mark Keybaoard Code -

// Modified code from: http://stackoverflow.com/questions/7169702/how-to-resize-uitextview-on-ios-when-a-keyboard-appears
- (void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up {
    self.isKeyboardUp = up;
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.view.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:[[[UIApplication sharedApplication] windows] firstObject]];
    
    if (up) {
        newFrame.size.height -= (keyboardFrame.size.height + CGRectGetHeight(self.otherButtons.bounds)); //* (up?1:-1); // keep up/down in here for now
    } else {
        newFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.otherButtons.bounds); // This fixes getting a keyboard frame of the whole screen (?)
    }
    
    self.textView.frame = newFrame;

    // NSLog(@"%@", NSStringFromCGRect(self.textView.bounds));
    [self positionAll];
    [UIView commitAnimations];
}

- (void)keyboardWillShown:(NSNotification*)aNotification {
    [self.otherButtons setCurrentButtonTypes:@[@(KPAAdditionalButtonTypeLowerKeyboard), @(KPAAdditionalButtonTypePicture)]];
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    [self.otherButtons setCurrentButtonTypes:@[@(KPAAdditionalButtonTypePicture)]];
    [self moveTextViewForKeyboard:aNotification up:NO];
}

#pragma mark

- (void)more:(UIBarButtonItem *)sender {
    
    NSMutableArray *activityItems = [[NSMutableArray alloc] initWithArray:@[self.textView.text]];
    
    [activityItems addObjectsFromArray:[self.currentNote imagesWithThumbnails:NO]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
    
    return;
    {
        [sender setEnabled:NO];
        
        if (self.actionSelector) {
            
            [UIView animateWithDuration:0.1 animations:^{
                [self.actionSelector setCenter:CGPointMake(CGRectGetWidth(self.view.bounds)/2, self.navigationController.navigationBar.center.y)];
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.actionSelector removeFromSuperview];
                    self.actionSelector = nil;
                    [sender setEnabled:YES];
                }
            }];
            return;
        }
        
        [self addGestureRecognizer];
        
        KPAActionSelectorView *viewToPullDown = [[KPAActionSelectorView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 55 : 60)) andSelectionTypes:(KPAActionSheetSelectionTypeMail)];
        [self.view addSubview:viewToPullDown];
        viewToPullDown.delegate = self;
        [viewToPullDown setCenter:CGPointMake(CGRectGetWidth(self.view.bounds)/2, self.navigationController.navigationBar.center.y)];
        
        [UIView animateWithDuration:0.1 animations:^{
            [viewToPullDown setCenter:CGPointMake(CGRectGetWidth(self.view.bounds)/2, self.navigationController.navigationBar.center.y + CGRectGetHeight(self.navigationController.navigationBar.bounds)/2 + CGRectGetHeight(viewToPullDown.bounds)/2)];
        } completion:^(BOOL finished) {
            if (finished) {
                [sender setEnabled:YES];
            }
        }];
        
        self.actionSelector = viewToPullDown;
    }
}


#pragma mark UITapGestureRecognizer -

- (void)addGestureRecognizer {
    self.actionBarDismissalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.textView addGestureRecognizer:self.actionBarDismissalTap];
}

- (void)didTap:(UITapGestureRecognizer *)gesture {
    
    if (self.imageDisplayView) {
        [self didSelectButtonType:KPAAdditionalButtonTypePicture]; // this will remove the image display
    }
    if (self.actionSelector) {
        [self more:self.navigationItem.rightBarButtonItem];
    }
    
    [self.textView removeGestureRecognizer:self.actionBarDismissalTap];
    self.actionBarDismissalTap = nil;
    
}

#pragma mark -

- (void)layoutTextView {
    if (self.isKeyboardUp) { return; }
    [self.textView kpa_modifyBoundsSize:CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    [self.textView kpa_positionViewInView:self.view withPercentage:KPA2dValueMake(0.5, 0.5) doesAllowEscapingViewBounds:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    UIView *viewToPullDown = self.actionSelector;
    viewToPullDown.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), (UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ? 55 : 60));
    [viewToPullDown setCenter:CGPointMake(CGRectGetWidth(self.view.bounds)/2, self.navigationController.navigationBar.center.y + CGRectGetHeight(self.navigationController.navigationBar.bounds)/2 + CGRectGetHeight(viewToPullDown.bounds)/2)];
}

#pragma mark KPAActionSheetSelectionType -

- (void)didSelect:(KPAActionSheetSelectionType)selectedAction {
    if (selectedAction == KPAActionSheetSelectionTypeMail) {
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.mailComposeDelegate = self;
        [mailComposeVC setMessageBody:self.textView.text isHTML:NO];
        [self presentViewController:mailComposeVC animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark

- (void)save {
    
    [[self textView] resignFirstResponder];
    
    BOOL wasEditing = self.currentNote.existsInDatabase; // Determines if this is a new note or not
    
    self.currentNote.note = [[self.textView text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (self.currentNote.note.length == 0) {
        
       // if (wasEditing) { TODO: tags will remain :/ -- Should be fixed now actually
            [self.currentNote delete];
       // }
        
        [self.delegate removedNote:self.currentNote];
        
        self.currentNote = nil;
        return;
    }
    
    if (self.currentNote.note.length <= 50) {
        self.currentNote.truncatedNote = self.currentNote.note;
    } else {
        self.currentNote.truncatedNote = [self.currentNote.note substringToIndex:50];
    }
    
    self.currentNote.updatedTime = [NSDate date];
    
    [self.currentNote save];
    NSLog(@"saved");
    
    if (wasEditing) {
        [self.delegate didUpdateNote:self.currentNote];
    } else {
        [self.delegate didSaveNewNote:self.currentNote];
    }
    
    //self.currentNote = nil; // This causes issues with swipe to go back, etc - duplicate notes
    
}

- (KPANote *)currentNote {
    if (!_currentNote) {
        _currentNote = [KPANote new]; // create a a new note if none was set.
        _currentNote.creationTime = [NSDate date];
    }
    return _currentNote;
}

- (void)dealloc {
    self.delegate = nil;
    self.currentNote = nil;
}

@end
