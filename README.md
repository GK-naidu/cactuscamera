# CactusCamera

CactusCamera is a native iOS camera app designed for concerts and low-light events.

## What it does (current state)

- Live camera preview using the back camera
- Start/stop video recording
- Saves recorded video to the Photos library
- Custom floating tab bar (Gallery / Camera / Settings)
- Permission gate for Camera, Mic, and Photos
- Early torch/strobe control modes (Off / Manual / Auto)

Tested on a real iPhone (iOS 18+).

## Core screens

- **Camera:** main capture UI with preview, record button, strobe mode selector
- **Gallery:** placeholder for recent clips (will load from Photos)
- **Settings:** toggles for behavior like auto strobe / auto save
- **Permissions screen:** shown on first launch to request camera, mic, and photo access

## Requirements

- iOS 18+
- Xcode (latest)
- Real device (not Simulator) to test camera, mic, flash, and saving to Photos

In the target Info, make sure these keys exist (or Xcode will kill the app when you access hardware):
- `NSCameraUsageDescription`
- `NSMicrophoneUsageDescription`
- `NSPhotoLibraryAddUsageDescription`
- `NSPhotoLibraryUsageDescription`

## Roadmap / next steps

- Show a live recording timer and “REC” badge while recording
- Show “Saving…” state after stop until the clip is written to Photos
- Respect safe areas (top notch / bottom home bar) in the camera UI
- Hook up manual flash pulse during recording
- Hook up audio-reactive flash (AUTO mode) using microphone input
- Replace Gallery placeholders with real photo library content

## Status

This is an in-progress build. It runs, records, and saves video on device. The strobe/flash sync feature and gallery import are under active development.
