# Pre-work - *Tips & Splits*

**Tips & Splits** is a tip calculator application for iOS.

Submitted by: **Nathan Ansel**

Time spent: **20** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] Blue and orange color schemes.
- [x] Ability to edit the tip percentages used in the app.
- [x] Displays the bill amount owed by each person if split between multiple people.
- [x] Custom animations of the settings view, which appears contextually over the root view.
- [x] Only one period is allowed to be entered in the billField text field (This limits user-error when entering a number using the on-screen keyboard).
- [x] App Icon

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/aW6AcHx.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

The main issues I ran into when making Tips & Splits were learning Swift (I come from an Objective-C background), learning how to use UIScrollViews, and designing the app’s interface.

I do not come from a design background, so deciding on where to place UI elements and what colors to use was initially difficult. After much deliberation I was able to fit myself into the roll of the designer and work with the little design knowledge I had.

I learned that I can make outlets for NSLayoutConstraints in code, and that I could then use those outlets to animate changes in constraints. This allowed me to animate views sliding into or out of view. I found this to be a much better way of animating views than by updating frames.

I also learned about creating graphics in Sketch for my application, including, but not limited to, the app’s icon and the gear used for the settings button’s icon.

## License

    Copyright 2015 Nathan Ansel

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.