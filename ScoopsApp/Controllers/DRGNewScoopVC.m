//
//  DRGNewScoopVC.m
//  ScoopsApp
//
//  Created by David Regatos on 29/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

@import QuartzCore;

#import "DRGNewScoopVC.h"
#import "DRGAzureManager.h"
#import "DRGScoop.h"
#import "DRGUser.h"
#import "UIImageView+AsyncDownload.h"
#import "UIImage+Resize.h"
#import "NSString+Validation.h"
#import "NotificationKeys.h"
#import "DRGThemeManager.h"

#define HEADLINE_TAG    100
#define LEAD_TAG        101
#define BODY_TAG        102

#define HEIGHT_TOP_CONTAINER 124
#define HEIGHT_BAR_BOTTOM    44

@interface DRGNewScoopVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,
                                UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic) float initialTxtBoxHeight;

@property (nonatomic, strong) UIImage *photo;

@end

@implementation DRGNewScoopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.authorTextField.delegate = self;
    self.headlineTextView.delegate = self;
    self.leadTextView.delegate = self;
    self.bodyTextView.delegate = self;

    if (!self.scoop) {
        // Create new scoop
        self.scoop = [DRGScoop scoopWithHeadline:self.headlineTextView.text
                                            lead:self.leadTextView.text
                                            body:self.bodyTextView.text
                                      authorName:self.authorTextField.text];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self customizeAppearence];
    
    [self syncViewAndModel];
    
    // Autolayout
    [self applyInitialLayout];
        
    // Notifications **********************
    [self registerForNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self unregisterForNotifications];   //optionally we can unregister a notification when the view disappears
}

#pragma mark - NSNotification

- (void)dealloc {
    [self unregisterForNotifications];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)unregisterForNotifications {
    // Clear out _all_ observations that this object was making
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// UIKeyboardWillShowNotification
- (void)notifyKeyboardWillShow:(NSNotification *)notification {
    
    if (self.authorTextField.isFirstResponder) {
        return;
    }
    
    // Sacar tamaño del teclado del userinfo de la notification
    NSDictionary *kbInfo = notification.userInfo;
    NSValue *wrappedFrame = [kbInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect kbFrame = [wrappedFrame CGRectValue];
    
    [self.view setNeedsLayout];
    CGFloat heightView = self.view.bounds.size.height;
    CGFloat newTxtViewHeight = heightView - kbFrame.size.height - 20;
    self.heightTopContainerViewConstrain.constant = 0;
    self.heightBottomBarConstrain.constant = kbFrame.size.height;
    
    if (self.headlineTextView.isFirstResponder) {
        
        self.heigthHeadlineConstrain.constant = newTxtViewHeight; // - self.headlineTextView.frame.origin.y;
        self.heightLeadConstrain.constant = 0;
        self.leadTextView.alpha = 0;
        self.heightBodyConstrain.constant = 0;
        self.bodyTextView.alpha = 0;

    } else if (self.leadTextView.isFirstResponder) {
        
        self.heigthHeadlineConstrain.constant = 0;
        self.headlineTextView.alpha = 0;
        self.heightLeadConstrain.constant = newTxtViewHeight; // - self.leadTextView.frame.origin.y;
        self.heightBodyConstrain.constant = 0;
        self.bodyTextView.alpha = 0;
        
    } else if (self.bodyTextView.isFirstResponder) {
        
        self.heigthHeadlineConstrain.constant = 0;
        self.headlineTextView.alpha = 0;
        self.heightLeadConstrain.constant = 0;
        self.leadTextView.alpha = 0;
        self.heightBodyConstrain.constant = newTxtViewHeight; // - self.bodyTextView.frame.origin.y;
    }
    
    // Sacar la duración de la animación del teclado
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration == 0 ? 1 : duration
                     animations:^{
                         self.topContainer.alpha = 0;
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

// UIKeyboardWillHideNotification
- (void)notifyKeyboardWillHide:(NSNotification *)notification {
    
    if (!self.authorTextField.isFirstResponder) {
        // Deshacer todo lo modificado en notifyKeyboardWillShow con animacións
        // Sacar la duración de la animación del teclado
        double duration = [[notification.userInfo
                            objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [self.view setNeedsLayout];
        [self applyInitialLayout];
        [UIView animateWithDuration:duration == 0 ? 1 : duration
                         animations:^{
            self.topContainer.alpha = 1;
            self.headlineTextView.alpha = 1;
            self.leadTextView.alpha = 1;
            self.bodyTextView.alpha = 1;
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (void)applyInitialLayout {
    
    if (!self.initialTxtBoxHeight) {
        CGFloat heightView = self.view.frame.size.height - 20;
//        NSLog(@"heightView: %f", self.view.frame.size.height);
        self.initialTxtBoxHeight = ((heightView - HEIGHT_BAR_BOTTOM) - HEIGHT_TOP_CONTAINER)/3;
//        NSLog(@"initialTxtBoxHeight: %f", self.initialTxtBoxHeight);
    }

    self.heightTopContainerViewConstrain.constant = HEIGHT_TOP_CONTAINER;
    self.heightBottomBarConstrain.constant = HEIGHT_BAR_BOTTOM;
    self.heigthHeadlineConstrain.constant = self.initialTxtBoxHeight;
    self.heightLeadConstrain.constant = self.initialTxtBoxHeight;
    self.heightBodyConstrain.constant = self.initialTxtBoxHeight;
    
//    NSLog(@"heightTopContainerViewConstrain: %f", self.heightTopContainerViewConstrain.constant);
//    NSLog(@"heigthHeadlineConstrain: %f", self.heigthHeadlineConstrain.constant);
//    NSLog(@"heightLeadConstrain: %f", self.heightLeadConstrain.constant);
//    NSLog(@"heightBodyConstrain: %f", self.heightBodyConstrain.constant);
//    NSLog(@"heightBottomBarConstrain: %f", self.heightBottomBarConstrain.constant);
}

#pragma mark - IBActions

- (IBAction)hideKeyboard:(UIControl *)sender {
    [self.view endEditing:YES];
}

- (IBAction)cancenBtnPressed:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)saveBtnPressed:(id)sender {
    
    // update current scoop
    self.scoop.authorName = self.authorTextField.text;
    self.scoop.headline = self.headlineTextView.text;
    self.scoop.lead = self.leadTextView.text;
    self.scoop.body = self.bodyTextView.text;
    self.scoop.published = self.publishSwitch.on;
    
    [self saveCurrentScoop];
}

- (IBAction)photoImageTapped:(UITapGestureRecognizer *)sender {
    if (!self.photo) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // ask user if he wants to take a new picture or use an existing one.
            [self askForTakingPhotoOrPickFromLibrary];
        } else {
            [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    } else {
        [self deleteCurrentPicture];
    }
}

#pragma mark - Utils

- (void)customizeAppearence {
    self.view.backgroundColor = [DRGThemeManager colorOfType:ThemeColorType_NormalGreen];
    self.activityIndicator.color = [UIColor whiteColor];
    
    self.authorTextField.textColor = [UIColor colorWithWhite:0.15 alpha:1.];
    
    self.toolbar.backgroundColor = [DRGThemeManager colorOfType:ThemeColorType_DarkGreen];
    self.toolbar.tintColor = [UIColor whiteColor]; //[DRGThemeManager colorOfType:ThemeColorType_LightGreen];
    self.publishSwitch.onTintColor = [DRGThemeManager colorOfType:ThemeColorType_NormalGreen];
    
    for (UITextView *txtView in self.textViewCollection) {
        txtView.backgroundColor = [DRGThemeManager colorOfType:ThemeColorType_LightGreen];
        txtView.layer.cornerRadius = 5;
        txtView.textColor = [UIColor colorWithWhite:0.15 alpha:1.];
    }
}

- (void)syncViewAndModel {
    
    self.authorTextField.text = self.user.name;
    if (self.scoop.authorName && ![NSString isEmpty:self.scoop.authorName]) {
        self.authorTextField.text = self.scoop.authorName;
    }
    self.headlineTextView.text = self.scoop.headline;
    self.leadTextView.text = self.scoop.lead;
    self.bodyTextView.text = self.scoop.body;
    
    self.publishSwitch.on = self.scoop.published;
    
    self.photoImageView.clipsToBounds = YES;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.photo) {
        self.photoImageView.image = self.photo;
    } else if (self.scoop.photo) {
        self.photoImageView.image = self.scoop.photo;
    } else {
        self.photoImageView.image = [UIImage imageNamed:@"image_placeholder"];
    }
}

- (void)saveCurrentScoop {
    [self.activityIndicator startAnimating];
    if (!self.scoop.scoopID) {
        // Scoop doesn't exist, we must create it
        [self uploadScoopInfo:self.scoop withCompletion:^(BOOL finished, NSError *error) {
            [self checkResultWithStatus:finished andError:error];
        }];
    } else {
        // Update scoop info
        [self updateScoopInfo:self.scoop withCompletion:^(BOOL finished, NSError *error) {
            [self checkResultWithStatus:finished andError:error];
        }];
    }
}

- (void)checkResultWithStatus:(BOOL)isFinished andError:(NSError *)error {
    
    [self.activityIndicator stopAnimating];
    
    if (error) {
        [self showAlertWithMessage:error.localizedDescription];
    } else if (isFinished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SCOOP_WAS_SAVED object:nil];
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self showAlertWithMessage:@"UNFINISHED WITH NO ERROR!!!"];
    }
}

#pragma mark - Connection

- (void)uploadScoopInfo:(DRGScoop *)aScoop withCompletion:(void(^)(BOOL finished, NSError *error))completionBlock {
    [[DRGAzureManager sharedInstance] insertScoop:aScoop
                                   withCompletion:^(DRGScoop *scoop, NSError *error) {
        if (error) {
           completionBlock (NO, error);
        } else {
           self.scoop = scoop;  // Update scoop. we need his id
           if (self.photo) {
               [[DRGAzureManager sharedInstance] uploadImage:self.photo
                                                    forScoop:self.scoop
                                              withCompletion:^(BOOL success, DRGScoop *scoop, NSError *error) {
                                                  
                                                  if (success) {
                                                      self.scoop = scoop;
                                                  }
                                                  completionBlock (success, error);
               }];
               
           } else {
               completionBlock (YES, error);
           }
        }
    }];
}

- (void)updateScoopInfo:(DRGScoop *)aScoop withCompletion:(void(^)(BOOL finished, NSError *error))completionBlock {
    [[DRGAzureManager sharedInstance] updateScoop:aScoop
                                   withCompletion:^(DRGScoop *scoop, NSError *error) {
        if (error) {
           completionBlock (NO, error);
        } else if (self.photo) {
           [[DRGAzureManager sharedInstance] uploadImage:self.photo
                                                forScoop:scoop
                                          withCompletion:^(BOOL success, DRGScoop *scoop, NSError *error) {
                                              
                                              if (success) {
                                                  self.scoop = scoop;
                                              }
                                              completionBlock (success, error);
           }];
            
        } else {
           completionBlock (YES, error);
        }
    }];
}

#pragma mark - Alert controller

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {
                                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                                  }];
    [alert addAction:okBtn];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)askForTakingPhotoOrPickFromLibrary {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to...?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoBtn = [UIAlertAction actionWithTitle:@"Take a picture"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                                                         ;
                                                     }];
    UIAlertAction *libraryBtn = [UIAlertAction actionWithTitle:@"Select one from Library"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                           ;
                                                       }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style: UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * action) {
                                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }];
    [alert addAction:photoBtn];
    [alert addAction:libraryBtn];
    [alert addAction:cancelBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteCurrentPicture {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to remove current photo?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *removeBtn = [UIAlertAction actionWithTitle:@"YES"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          self.photo = nil;
                                                          self.photoImageView.image = [UIImage imageNamed:@"image_placeholder"];
                                                      }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"No"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * action) {
                                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }];
    [alert addAction:removeBtn];
    [alert addAction:cancelBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)launchImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                         // Cuando termine la animación que muestra el picker
                         // se ejecutará este bloque.
                     }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    __block UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.height * screenScale, screenBounds.size.width * screenScale);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        img = [img resizedImage:screenSize interpolationQuality:kCGInterpolationMedium];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photo = img;
            self.photoImageView.image = img;
        });
    });
    
    // Ocultar el presented VC
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // Ocultar el presented VC
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 // Cuando termine la animación que oculta el picker
                                 // se ejecutará este bloque.
                             }];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
//    [self notifyKeyboardWillShow:nil];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    switch (textView.tag) {
        case HEADLINE_TAG:
            self.scoop.headline = textView.text;
            break;
        case LEAD_TAG:
            self.scoop.lead = textView.text;
            break;
        case BODY_TAG:
            self.scoop.body = textView.text;
            break;
        default:
            break;
    }
    
    [textView resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.scoop.authorName = textField.text;
    [textField resignFirstResponder];
}



@end
