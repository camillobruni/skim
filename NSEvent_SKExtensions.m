//
//  NSEvent_SKExtensions.m
//  Skim
//
//  Created by Christiaan Hofman on 6/11/08.
/*
 This software is Copyright (c) 2008-2012
 Christiaan Hofman. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 - Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

 - Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.

 - Neither the name of Christiaan Hofman nor the names of any
    contributors may be used to endorse or promote products derived
    from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "NSEvent_SKExtensions.h"
#import <Carbon/Carbon.h>

#define SKStandardModifierFlagsMask (NSCommandKeyMask | NSAlternateKeyMask | NSShiftKeyMask | NSControlKeyMask)

#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5
@interface NSEvent (SKSnowLeopardDeclarations)
+ (NSUInteger)modifierFlags;
@end
#endif


@implementation NSEvent (SKExtensions)

+ (NSUInteger)standardModifierFlags {
    if ([self respondsToSelector:@selector(modifierFlags)])
        return [self modifierFlags] & SKStandardModifierFlagsMask;
    
    NSUInteger flags = 0;
    UInt32 currentKeyModifiers = GetCurrentKeyModifiers();
    if (currentKeyModifiers & cmdKey)
        flags |= NSCommandKeyMask;
    if (currentKeyModifiers & shiftKey)
        flags |= NSShiftKeyMask;
    if (currentKeyModifiers & optionKey)
        flags |= NSAlternateKeyMask;
    if (currentKeyModifiers & controlKey)
        flags |= NSControlKeyMask;
    
    return flags;
}

- (NSUInteger)deviceIndependentModifierFlags {
    return [self modifierFlags] & NSDeviceIndependentModifierFlagsMask;
}

- (NSUInteger)standardModifierFlags {
    return [self modifierFlags] & SKStandardModifierFlagsMask;
}

- (unichar)firstCharacter {
    NSString *characters = [self charactersIgnoringModifiers];
    return [characters length] > 0 ? [characters characterAtIndex:0] : 0;
}

- (NSPoint)locationInView:(NSView *)view {
    return [view convertPoint:[self locationInWindow] fromView:nil];
}

@end
