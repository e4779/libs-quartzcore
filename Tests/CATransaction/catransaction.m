/* Tests/CATransaction/catransaction.m

   Copyright (C) 2026 Free Software Foundation, Inc.

   Author: e4779
   Date: October 2026

   This file is part of QuartzCore.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; see the file COPYING.LIB.
   If not, see <http://www.gnu.org/licenses/> or write to the
   Free Software Foundation, 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.
*/

#import <Foundation/Foundation.h>
#import "QuartzCore/CATransaction.h"
#import "../Testing.h"

int main(int argc, char ** argv)
{
  int testsFailed = 0;

  //////////////////////////

  /* The class getter answers nil while no block has been set. */
  PASS([CATransaction completionBlock] == nil,
    "completionBlock is nil when never set");

  //////////////////////////

  /* The block fires exactly once, and only at commit. */
  {
    __block int firedCount = 0;

    [CATransaction begin];
    [CATransaction setCompletionBlock: ^{ firedCount++; }];

    PASS([CATransaction completionBlock] != nil,
      "setCompletionBlock: stores the block");

    PASS(firedCount == 0,
      "completionBlock does not fire before commit");

    [CATransaction commit];

    PASS(firedCount == 1,
      "completionBlock fires exactly once on commit");
  }

  //////////////////////////

  /* A transaction without a block completes silently. */
  {
    __block int firedCount = 0;

    [CATransaction begin];
    [CATransaction setCompletionBlock: ^{ firedCount++; }];
    [CATransaction setCompletionBlock: nil];

    PASS([CATransaction completionBlock] == nil,
      "setCompletionBlock: nil clears a stored block");

    [CATransaction commit];

    PASS(firedCount == 0,
      "no completion fires when no block is set");
  }

  //////////////////////////

  /* Nested transactions each fire their own block, inner first. */
  {
    NSMutableString *order = [NSMutableString string];

    [CATransaction begin];
    [CATransaction setCompletionBlock: ^{ [order appendString: @"outer"]; }];

    [CATransaction begin];
    [CATransaction setCompletionBlock: ^{ [order appendString: @"inner"]; }];

    [CATransaction commit];
    [CATransaction commit];

    PASS([order isEqualToString: @"innerouter"],
      "nested transactions fire the inner block, then the outer one");
  }

  //////////////////////////

  /* A block may safely commit further transactions of its own. */
  {
    __block int nestedFires = 0;

    [CATransaction begin];
    [CATransaction setCompletionBlock: ^{
        [CATransaction begin];
        [CATransaction setCompletionBlock: ^{ nestedFires++; }];
        [CATransaction commit];
      }];
    [CATransaction commit];

    PASS(nestedFires == 1,
      "a completionBlock may commit its own nested transaction");
  }

  if(testsFailed)
    {
      printf("\7");
    }
  printf("\n\n===== %d tests failed\n\n", testsFailed);

  return testsFailed;
}

/* vim: set cindent cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1 expandtabs shiftwidth=2 tabstop=8: */
