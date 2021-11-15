# iBirdcall Librarian *by Jonathan Mason for You Decide!, iOS Developer Nanodegree*

Allows the birdwatcher to record birdcalls in the field, for later identification.

A birdcall is sometimes the best way to identify a bird. However, it is difficult to remember a sound, and many birdcalls are also indistinct, so that when attempting to match the remembered birdcall to an audio reference guide, e.g. a CD, it is often an almost impossible task.

The location, time and date of the recording are automatically captured along with each recording. Other information may also be entered, including species, title and notes.

Once a species has been entered, an image is downloaded form the internet and saved with the birdcall. This can be changed at any time by simply tapping the image.

Past recordings can be reviewed either on a map or in a list.

# Notes for Building and Running App

It should be possible to build and run the app using the code as it is.

## Development Tools

iBirdcall Librarian was debveloped using:

- XCode 13.1
- Swift 5
- UIKit/Storyboard

## External Libraries/Web APIs

- Flickr API (key already included in apiKey constant of FlickrClient class).

## Implementation Notes

- Internet access is used by Details screen to load and update image corresponding to entered bird species.
- The Auto-Play setting and map state is persisted to UserDefaults.
- Birdcall meta-data is persisted to Core Data.
- Recordings are saved as files with unique UUIDs.

# User Guide

## Main Screen

The Main screen is the first screen to be shown and can be toggled between Map and List modes using the Map and List buttons at the bottom of the screen. The starting mode is Map.

### Map Mode

Map mode shows a map of the current location. A past recording is represented as a pin. The map can be zoomed and moved in the usual way. Changes to map zoom level and position are automatically persisted.

*Record*: There are 2 round Record buttons, a large red one to the top-right of the screen and a smaller one in the top-left of the navigation bar. Pressing either of these will show the Record screen and immediately begin recording.

*Pin*: Selecting a pin by tapping it shows a bubble containing a summary of the birdcall. Pressing the bubble itself shows the details of the birdcall in the Details screen.

*Settings*: Pressing the Settings button shows the Settings screen.

*Info*: Pressing the Info button shows the Info screen.

### List Mode

List mode shows a list of past recordings, newest first. A past recording is represented as a row of the list.

*Record*: Same as Map mode.

*Row*: Selecting a row by tapping it shows the details of the birdcall in the Details screen.

*Settings*: Same as Map mode.

*Info*: Same as Map mode.

## Record Screen

When shown, the Record screen immediately begins recording, which is indicated by a flashing red, ON-AIR indicator. Date, time and location are also automatically captured. A default title is shown along with the captured date and time.

*Stop*: There are 2 square Stop buttons, a large black one to the bottom-right of the screen and a smaller one in the top-left of the navigation bar. Pressing either of these will stop the recording. The flashing red ON-AIR indicator changes to OFF-AIR to indicate the recording has been stopped. The screen is automatically saved and the screen closed, returning to the main screen. The main screen shows the newly recorded birdcall, either at its location on the map or at the top of the list.

## Details Screen

The details screen shows the details of the birdcall.

*Species*: Enter or edit speicies, if known, e.g. Coot, Kestrel, Wren. As soon as editing finishes, a corresponding image is downloaded from the internet. To change, simply tap the image.

*Title*: Edit title. A default title is automatically generated at the time of recording based upon the time of day, i.e. morning, afternoon, evening or night.

*Notes*: Enter or edit any notes about the bird or recording.

*Latitude and Longitude*: Location of birdcall; cannot be edited.

*Date and time*: Date and time of birdcall; cannot be edited.

*Image*: Image corresponding to species, if entered; downloaded from the internet. To change, simply tap the image.

*Play*: There are 2 triangular Play buttons, a large green one to the top-right of the screen and a smaller one in the top-left of the navigation bar. Press either of these to play the recording of the birdcall. The birdcall can also be set to automatically play as the Details screen is shown by enabling the Auto-Play setting. See the Settings screen.

*Delete*: Press to delete the birdcall, which also automatically closes the screen.

## Settings Screen

Contains the settings of the app.

*Auto-Play*: If enabled, automatically plays the birdcall when showing the Details screen.

## Info Screen

Contains information about the app, including acknowledgments.
