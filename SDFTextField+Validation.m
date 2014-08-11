//
//  NSTextField+Validation.m
//
//  Created by Trent Milton on 02/07/2014.
//  Copyright (c) 2014 shaydes.dsgn. All rights reserved.
//

#import "SDFTextField+Validation.h"
#import <objc/runtime.h>

static NSColor *kValidationTextFieldBackgroundColour;
static NSColor *kValidationTextFieldValidBackgroundColour;
static NSColor *kValidationTextFieldInvalidBackgroundColour;
static NSColor *kValidationTextFieldPlaceholderValidateFontColour;
static NSColor *kValidationTextFieldPlaceholderFontColour;

static void *ValidationTypePropertyKey = &ValidationTypePropertyKey;
static void *PlaceholderStringPropertyKey = &PlaceholderStringPropertyKey;

@implementation NSTextField (Validation)

+ (void)initialize
{
	if (self == [NSTextField class]) {
		kValidationTextFieldBackgroundColour = [NSColor whiteColor];
		kValidationTextFieldValidBackgroundColour = [NSColor greenColor];
		kValidationTextFieldInvalidBackgroundColour = [NSColor redColor];
		kValidationTextFieldPlaceholderValidateFontColour = [NSColor whiteColor];
		kValidationTextFieldPlaceholderFontColour = [NSColor grayColor];
	}
}

#pragma mark - Properties

- (ValidationType)validationType
{
	NSNumber *t = objc_getAssociatedObject(self, ValidationTypePropertyKey);
	return t.intValue;
}

- (void)setValidationType:(ValidationType)validationType
{
	objc_setAssociatedObject(self, ValidationTypePropertyKey, @(validationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)placeholderString
{
	return objc_getAssociatedObject(self, PlaceholderStringPropertyKey);
}

- (void)setPlaceholderString:(NSString *)placeholderString
{
	objc_setAssociatedObject(self, PlaceholderStringPropertyKey, placeholderString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public

- (BOOL)validate
{
	NSColor *bgColour = kValidationTextFieldBackgroundColour;
	NSColor *placeholderColour = kValidationTextFieldPlaceholderValidateFontColour;

	BOOL valid = YES;
	switch (self.validationType) {
		case ValidationTypeNone:
			placeholderColour = kValidationTextFieldPlaceholderFontColour;
			// Do nothing, we just want white
			break;

		case ValidationTypeEmail: {
			valid = [self.stringValue validEmail];
			bgColour = valid ? kValidationTextFieldValidBackgroundColour : kValidationTextFieldInvalidBackgroundColour;
			break;
		}

		case ValidationTypeOptional:
			placeholderColour = kValidationTextFieldPlaceholderFontColour;
			bgColour = kValidationTextFieldBackgroundColour;
			break;

		case ValidationTypeRequired:
		case ValidationTypePassword:
		default: {
			valid = self.stringValue.length > 0;
			bgColour = valid ? kValidationTextFieldValidBackgroundColour : kValidationTextFieldInvalidBackgroundColour;
			break;
		}
	}

	[self setPlaceholderFontColour:placeholderColour];

	self.backgroundColor = bgColour;
	// This will make sure the background updates
	[self setEditable:NO];
	[self setEditable:YES];

	return valid;
}

- (void)reset
{
	self.stringValue = @"";
	self.backgroundColor = kValidationTextFieldBackgroundColour;
	[self setPlaceholderFontColour:kValidationTextFieldPlaceholderFontColour];

	// This will make sure the background updates
	[self setEditable:NO];
	[self setEditable:YES];
}

#pragma mark - Private

- (void)setPlaceholderFontColour:(NSColor *)colour
{
	if (!self.placeholderString) {
        self.placeholderString = [self.cell placeholderString];
    }

	NSDictionary *d = @{
                        NSFontAttributeName : self.font,
                        NSForegroundColorAttributeName : colour
                        };
	NSAttributedString *as = [[NSAttributedString alloc] initWithString:self.placeholderString
	                                                         attributes:d];
	[self.cell setPlaceholderAttributedString:as];
}

#pragma mark - Static Properties

+ (void)setBackgroundColour:(NSColor *)colour
{
	kValidationTextFieldBackgroundColour = colour;
}

+ (void)setValidBackgroundColour:(NSColor *)colour
{
	kValidationTextFieldValidBackgroundColour = colour;
}

+ (void)setInvalidBackgroundColour:(NSColor *)colour
{
	kValidationTextFieldInvalidBackgroundColour = colour;
}

+ (void)setPlaceholderValidateFontColour:(NSColor *)colour
{
	kValidationTextFieldPlaceholderValidateFontColour = colour;
}

+ (void)setPlaceholderFontColour:(NSColor *)colour
{
	kValidationTextFieldPlaceholderFontColour = colour;
}

@end
